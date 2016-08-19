//
//  ZXSpectrum48.swift
//  SwiftZ80
//
//  Created by Mike Daley on 13/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

import Foundation
import Cocoa

public struct PixelData {
    
    var r: UInt8 = 255
    var g: UInt8
    var b: UInt8
    var a: UInt8
    
}

class ZXSpectrum48 {
    
    // MARK: Emulation properties

    let emulationQueue = dispatch_queue_create("emulationQueue", nil)
    var emulationTimer: dispatch_source_t
    
    // MARK: Memory and Z80 core properties

    var memory = [Byte](count: 0x10000, repeatedValue: 0x00)
    var core: SwiftZ80Core?
    
    // MARK: General emulation properties
    
    var tStatesInCurrentFrame: Int = 0
    var shouldReset: Bool = false

    //MARK : Screen details
    
    let pixelLeftBorderWidth = 32
    let pixelScreenWidth = 256
    let pixelRightBorderWidth = 32
    let pixelTopBorderHeight = 56 //56
    let pixelScreenHeight = 192
    let pixelBottomBorderHeight:Int = 56 //56
    let pixelLinesVerticalBlank = 8
    
    let tStatesPerFrame = 69888
    let tStatesPerLine = 224
    
    let tStatesLeftBorderWidth = 16
    let tStatesScreenWidth = 128
    let tStatesScreenHeight = 43008
    let tStatesRightBorderWidth = 32
    let tStatesHorizontalFlyback = 48
    
    var tStatesVerticalBlank = 1792
    var tStatesTopBorder: Int
    var tStatesBottomBorder: Int
    
    var pixelDisplayWidth: Int
    var pixelDisplayHeight: Int
    
    var pixelBeamXPos: Int = 0
    var pixelBeamYPos: Int = 0

    var borderColour: Int = (7 & 0x07) << 2
    var imageRef: CGImageRef?
    
    var frameCounter: Int = 0
    
    // MARK: Screen image details
    
    let bitsPerPixel = 32       // RGBA - bites
    let bytesPerPixel = 4       // RGBA - bytes
    let bitsPerComponent = 8	// 32bit
    var pixelDisplayBufferLength: Int
    let shouldInterpolate = true
    var emulationScreenImage: CGImageRef?
    
    private let colourSpace = CGColorSpaceCreateDeviceRGB()!
    private let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
    private var displayBuffer: [PixelData]?
    
    // MARK: Pallette
    
//    private let pallette: [UInt8] = [
//        
//        // Normal colours
//        0,   0,   0, 255,   // Blue
//        0,   0, 224, 255,   // Red
//        224,   0,   0, 255, // Magenta
//        224,   0, 224, 255, // Green
//        0, 224,   0, 255,   // Cyan
//        0, 224, 224, 255,   // Yellow
//        224, 224,   0, 255, // White
//        224, 224, 224, 255, // Black
//        
//        // Bright colours
//        0,   0,   0, 255,
//        0,   0, 255, 255,
//        255,   0,   0, 255,
//        255,   0, 255, 255,
//        0, 255,   0, 255,
//        0, 255, 255, 255,
//        255, 255,   0, 255,
//        255, 255, 255, 255
//    ]
    
    // MARK: Init
    
    var appDelegate: AppDelegate?

    init() {

        tStatesTopBorder = pixelTopBorderHeight * tStatesPerLine
        tStatesBottomBorder = pixelBottomBorderHeight * tStatesPerLine
        pixelDisplayWidth = pixelLeftBorderWidth + pixelScreenWidth + pixelRightBorderWidth
        pixelDisplayHeight = pixelTopBorderHeight + pixelScreenHeight + pixelBottomBorderHeight
        
        // Setup the buffer that will hold the emulated screen image
        pixelDisplayBufferLength = pixelDisplayWidth * pixelDisplayHeight
        let whitePixel = PixelData(r: 0xff, g: 0xff, b: 0xff, a: 0xff)
        displayBuffer = [PixelData](count: pixelDisplayBufferLength, repeatedValue: whitePixel)
        
        // Emulation timer
        emulationTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, emulationQueue)
        dispatch_source_set_timer(emulationTimer, DISPATCH_TIME_NOW, UInt64(1/50 * Double(NSEC_PER_SEC)), 0)
        dispatch_source_set_event_handler(emulationTimer) {
            self.runFrame()
        }

        core = SwiftZ80Core.init(memoryRead: readFromMemoryAddress,
                                 memoryWrite: writeToMemoryAddress,
                                 ioRead: ioReadAddress,
                                 ioWrite: ioWriteAddress,
                                 contentionReadNoMREQ: contentionReadNoMREQAddress,
                                 contentionWriteNoMREQ: contentionWriteNoMREQAddress,
                                 contentionRead: contentionReadAddress)
        reset()
    }
    
    /**
     * Core execution
     */
    
    func startExecution() {
        dispatch_resume(emulationTimer)
    }

    func stopExecution() {
        dispatch_suspend(emulationTimer)
    }
    
    func execute() -> (Int) {
        let currentTStates = core!.tStates
        core!.execute()
        return core!.tStates - currentTStates
    }
    
    func step(inout mutableDisplayBuffer:UnsafeMutableBufferPointer<PixelData>, memoryBuffer:UnsafeBufferPointer<Byte>) -> (Int) {
        
        let cpuStates = self.execute()
        
        updateScreenFromTstate(tStatesInCurrentFrame, numberOfTstates: cpuStates, mutableDisplayBuffer: &mutableDisplayBuffer, memoryBuffer: memoryBuffer)
        
        tStatesInCurrentFrame += cpuStates
        
        if tStatesInCurrentFrame >= tStatesPerFrame {
            tStatesInCurrentFrame -= tStatesPerFrame
            frameCounter += 1
        }
        return cpuStates
    }
    
    func runFrame() {
        
        var count = tStatesPerFrame
        
        displayBuffer!.withUnsafeMutableBufferPointer { mutableDisplayBuffer -> () in
            
            
            memory.withUnsafeBufferPointer { memoryBuffer -> () in
            
                while count > 0 {
                    
                    if shouldReset {
                        shouldReset = false
                        count == 0
                        core!.reset()
                        loadROM()
                    }
                    
                    count -= self.step(&mutableDisplayBuffer, memoryBuffer: memoryBuffer)
                }
            }
        }
        
        generateScreenImage()
    
    }
    
    func reset() {
        shouldReset = true
    }
    
    // MARK: ROM loading
    
    func loadROM() {
        let path = NSBundle.mainBundle().pathForResource("48", ofType: "ROM")
        let data = NSData.init(contentsOfFile: path!)
        let count = data!.length / sizeof(Byte)
        var fileBytes = [Byte](count: count, repeatedValue: 0x00)
        
        data!.getBytes(&fileBytes, length: count * sizeof(Byte))
        
        for i in 0..<data!.length {
            memory[i] = fileBytes[i]
        }
    }
    
    // MARK: Snapshot loading
    
    func loadSnapShot(path: String) {
        
        let data = NSData.init(contentsOfFile: path)
        let count = data!.length / sizeof(Byte)
        var fileBytes = [Byte](count: count, repeatedValue: 0x00)
        
        data!.getBytes(&fileBytes, length: count * sizeof(Byte))
        
        if data?.length == 49179 {
            
            var snaAddr = 27
            for i in 16384..<(48 * 1024) {
                memory[i] = fileBytes[snaAddr]
                snaAddr += 1
            }
            
        }
        
    }
    
    // MARK: Memory IO routines
    
    func readFromMemoryAddress(address: Word) -> Byte {
        return memory[Int(address)]
    }
    
    func writeToMemoryAddress(address: Word, value: Byte) {
        memory[Int(address)] = value
    }
    
    func ioReadAddress(address: Word) -> Byte {
        return 0xff
    }
    
    func ioWriteAddress(address: Word, value: Byte) {

    }
    
    func contentionReadNoMREQAddress(address: Word, tStates: Int) {

    }
    
    func contentionWriteNoMREQAddress(address: Word, tStates: Int) {

    }
    
    func contentionReadAddress(address: Word, tStates: Int) {

    }
    
    // MARK: Screen routines
    
    func updateScreenFromTstate(tState: Int, numberOfTstates: Int, inout mutableDisplayBuffer: UnsafeMutableBufferPointer<PixelData>, memoryBuffer:UnsafeBufferPointer<Byte>) {
        
        let pall : [UInt8] = [
            
            // Normal colours
            0,   0,   0, 255,   // Blue
            0,   0, 224, 255,   // Red
            224,   0,   0, 255, // Magenta
            224,   0, 224, 255, // Green
            0, 224,   0, 255,   // Cyan
            0, 224, 224, 255,   // Yellow
            224, 224,   0, 255, // White
            224, 224, 224, 255, // Black
            
            // Bright colours
            0,   0,   0, 255,
            0,   0, 255, 255,
            255,   0,   0, 255,
            255,   0, 255, 255,
            0, 255,   0, 255,
            0, 255, 255, 255,
            255, 255,   0, 255,
            255, 255, 255, 255
        ]
        
        
        
        for _ in 0 ..< (numberOfTstates << 1) {
            
            let x:Int = pixelBeamXPos
            let y:Int = pixelBeamYPos - pixelLinesVerticalBlank
            
            let c1 = x < pixelDisplayWidth
            let c2 = y < (pixelDisplayHeight + pixelBottomBorderHeight)
            let c3 = y >= 0
            
            if c3 && c2 && c1 {
                

                
                if y < pixelTopBorderHeight || y >= pixelScreenHeight + pixelTopBorderHeight {
                    
                    // Draw top or bottom border
                    let displayBufferIndex = y * pixelDisplayWidth + x
                    
                    mutableDisplayBuffer[ displayBufferIndex ].r = pall.withUnsafeBufferPointer { p -> UInt8 in return p[borderColour] }
                    mutableDisplayBuffer[ displayBufferIndex ].g = pall.withUnsafeBufferPointer { p -> UInt8 in return p[borderColour + 1] }
                    mutableDisplayBuffer[ displayBufferIndex ].b = pall.withUnsafeBufferPointer { p -> UInt8 in return p[borderColour + 2] }
                    mutableDisplayBuffer[ displayBufferIndex ].a = pall.withUnsafeBufferPointer { p -> UInt8 in return p[borderColour + 3] }
					
                } else {

                    if x < pixelLeftBorderWidth || x >= pixelScreenWidth + pixelLeftBorderWidth {
                        
                        // Draw left and right border
                        let displayBufferIndex = y * pixelDisplayWidth + x
                    
                        mutableDisplayBuffer[ displayBufferIndex ].r = pall.withUnsafeBufferPointer { p -> UInt8 in return p[borderColour] }
                        mutableDisplayBuffer[ displayBufferIndex ].g = pall.withUnsafeBufferPointer { p -> UInt8 in return p[borderColour + 1] }
                        mutableDisplayBuffer[ displayBufferIndex ].b = pall.withUnsafeBufferPointer { p -> UInt8 in return p[borderColour + 2] }
                        mutableDisplayBuffer[ displayBufferIndex ].a = pall.withUnsafeBufferPointer { p -> UInt8 in return p[borderColour + 3] }

                    
                    } else { // Must be on the screen so draw that
                        
                        let px = x - pixelLeftBorderWidth
                        let py = y - pixelTopBorderHeight
                        
                        let pixelAddress = 16384 + (px >> 3) + ((py & 0x07) << 8) + ((py & 0x38) << 2) + ((py & 0xc0) << 5)
                        let attributeAddress = 16384 + (32 * 192) + (px >> 3) + ((py >> 3) << 5)
                        
                        let pixelByte = memoryBuffer[Int(pixelAddress)]
                        let attributeByte = memoryBuffer[Int(attributeAddress)]
                        
                        var ink:Int = Int(((attributeByte & 0x07) + ((attributeByte & 0x04) >> 3)) * 4)
                        var paper:Int = Int((((attributeByte >> 3) & 0x07) + ((attributeByte & 0x40) >> 3)) * 4)
                        
                        if (frameCounter & 16) != 0 && (attributeByte & 0x80) != 0 {
                            let t = ink;
                            ink = paper;
                            paper = t;
                        }
                        
                        let displayBufferIndex = y * pixelDisplayWidth + x
                        
                        if Int(pixelByte) & (0x80 >> (px & 7)) != 0 {
                            
                            
                            mutableDisplayBuffer[ displayBufferIndex ].r = pall.withUnsafeBufferPointer { p -> UInt8 in return p[ink] }
                            mutableDisplayBuffer[ displayBufferIndex ].g = pall.withUnsafeBufferPointer { p -> UInt8 in return p[ink + 1] }
                            mutableDisplayBuffer[ displayBufferIndex ].b = pall.withUnsafeBufferPointer { p -> UInt8 in return p[ink + 2] }
                            mutableDisplayBuffer[ displayBufferIndex ].a = pall.withUnsafeBufferPointer { p -> UInt8 in return p[ink + 3] }

                            
                        } else {
                            
                            
                            
                            mutableDisplayBuffer[ displayBufferIndex ].r = pall.withUnsafeBufferPointer { p -> UInt8 in return p[paper] }
                            mutableDisplayBuffer[ displayBufferIndex ].g = pall.withUnsafeBufferPointer { p -> UInt8 in return p[paper + 1] }
                            mutableDisplayBuffer[ displayBufferIndex ].b = pall.withUnsafeBufferPointer { p -> UInt8 in return p[paper + 2] }
                            mutableDisplayBuffer[ displayBufferIndex ].a = pall.withUnsafeBufferPointer { p -> UInt8 in return p[paper + 3] }

                        }
                    }
                    
                }
                
            }
            
            pixelBeamXPos += 1
            
            if pixelBeamXPos >= (tStatesPerLine << 1) {
                
                pixelBeamXPos -= (tStatesPerLine << 1)
                pixelBeamYPos += 1
                
                if pixelBeamYPos >= pixelDisplayHeight + pixelLinesVerticalBlank  {
                    pixelBeamYPos -= pixelDisplayHeight + pixelLinesVerticalBlank
                }
            }
            
        }
            


    }
    
    func generateScreenImage() {
        
        let providerData = NSData(bytes: &displayBuffer!, length: displayBuffer!.count * sizeof(PixelData))
        let dataProviderRef = CGDataProviderCreateWithCFData(providerData)

        imageRef = CGImageCreate(
            pixelDisplayWidth,
            pixelDisplayHeight,
            bitsPerComponent,
            bitsPerPixel,
            pixelDisplayWidth * Int(sizeof(PixelData)),
            colourSpace,
            bitmapInfo,
            dataProviderRef,
            nil,
            shouldInterpolate,
            CGColorRenderingIntent.RenderingIntentDefault
        )
        
    }
    
    
    
    
    
    
    
}