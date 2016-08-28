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

public struct KeyboardEntry {
	var keyCode: Int
	var mapEntry: Int
	var mapBit: Int
}

enum Event {
	case None
	case Reset
	case LoadSnapShot
}

class ZXSpectrum48: ViewEventProtocol {
    
    // MARK: Emulation properties

    let emulationQueue = dispatch_queue_create("emulationQueue", nil)
    var emulationTimer: dispatch_source_t
    
    // MARK: Memory and Z80 core properties

    var memory = [Byte](count: 0x10000, repeatedValue: 0x00)
	var core: SwiftZ80Core!
	
    // MARK: General emulation properties
    
    var shouldReset: Bool = false

    //MARK : Screen details
    
    let pixelLeftBorderWidth = 32
    let pixelScreenWidth = 256
    let pixelRightBorderWidth = 64
    let pixelTopBorderHeight = 56			//56
    let pixelScreenHeight = 192
    let pixelBottomBorderHeight:Int = 56	//56
    let pixelLinesVerticalBlank = 8
	let pixelHorizontalFlyback = 96
    
    let tStatesPerFrame = 69888
    let tStatesPerLine = 224
    
    let tStatesLeftBorderWidth = 16
    let tStatesScreenWidth = 128
    let tStatesScreenHeight = 192 * 224
    let tStatesRightBorderWidth = 32
    let tStatesHorizontalFlyback = 48
    
    var tStatesVerticalBlank = 0
    var tStatesTopBorder: Int
    var tStatesBottomBorder: Int
    
    var pixelDisplayWidth: Int
    var pixelDisplayHeight: Int
    
    var pixelBeamXPos: Int = 32
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
    
    let colourSpace = CGColorSpaceCreateDeviceRGB()!
    let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
    var displayBuffer: [PixelData]!
	var emulationDisplayView: NSView!
	var displayBufferIndex = 32
	
	// MARK: Sound
	
	var beeperOn: Bool = false
	
	// MARK: Contention
	var contentionTable = [Int](count:69888, repeatedValue: 0)
	
	// MARK: Keyboard
	
	var keyboardLookup: [KeyboardEntry] = [
		
		KeyboardEntry(keyCode: 6, mapEntry: 0, mapBit: 1),
		KeyboardEntry(keyCode: 7, mapEntry: 0, mapBit: 2),
		KeyboardEntry(keyCode: 8, mapEntry: 0, mapBit: 3),
		KeyboardEntry(keyCode: 9, mapEntry: 0, mapBit: 4),
		
		KeyboardEntry(keyCode: 0, mapEntry: 1, mapBit: 0),
		KeyboardEntry(keyCode: 1, mapEntry: 1, mapBit: 1),
		KeyboardEntry(keyCode: 2, mapEntry: 1, mapBit: 2),
		KeyboardEntry(keyCode: 3, mapEntry: 1, mapBit: 3),
		KeyboardEntry(keyCode: 5, mapEntry: 1, mapBit: 4),
		
		KeyboardEntry(keyCode: 12, mapEntry: 2, mapBit: 0),
		KeyboardEntry(keyCode: 13, mapEntry: 2, mapBit: 1),
		KeyboardEntry(keyCode: 14, mapEntry: 2, mapBit: 2),
		KeyboardEntry(keyCode: 15, mapEntry: 2, mapBit: 3),
		KeyboardEntry(keyCode: 17, mapEntry: 2, mapBit: 4),
		
		KeyboardEntry(keyCode: 18, mapEntry: 3, mapBit: 0),
		KeyboardEntry(keyCode: 19, mapEntry: 3, mapBit: 1),
		KeyboardEntry(keyCode: 20, mapEntry: 3, mapBit: 2),
		KeyboardEntry(keyCode: 21, mapEntry: 3, mapBit: 3),
		KeyboardEntry(keyCode: 23, mapEntry: 3, mapBit: 4),
		
		KeyboardEntry(keyCode: 29, mapEntry: 4, mapBit: 0),
		KeyboardEntry(keyCode: 25, mapEntry: 4, mapBit: 1),
		KeyboardEntry(keyCode: 28, mapEntry: 4, mapBit: 2),
		KeyboardEntry(keyCode: 26, mapEntry: 4, mapBit: 3),
		KeyboardEntry(keyCode: 22, mapEntry: 4, mapBit: 4),
		
		KeyboardEntry(keyCode: 35, mapEntry: 5, mapBit: 0),
		KeyboardEntry(keyCode: 31, mapEntry: 5, mapBit: 1),
		KeyboardEntry(keyCode: 34, mapEntry: 5, mapBit: 2),
		KeyboardEntry(keyCode: 32, mapEntry: 5, mapBit: 3),
		KeyboardEntry(keyCode: 16, mapEntry: 5, mapBit: 4),
		
		KeyboardEntry(keyCode: 36, mapEntry: 6, mapBit: 0),
		KeyboardEntry(keyCode: 37, mapEntry: 6, mapBit: 1),
		KeyboardEntry(keyCode: 40, mapEntry: 6, mapBit: 2),
		KeyboardEntry(keyCode: 38, mapEntry: 6, mapBit: 3),
		KeyboardEntry(keyCode: 4, mapEntry: 6, mapBit: 4),

		KeyboardEntry(keyCode: 49, mapEntry: 7, mapBit: 0),
		KeyboardEntry(keyCode: 46, mapEntry: 7, mapBit: 2),
		KeyboardEntry(keyCode: 45, mapEntry: 7, mapBit: 3),
		KeyboardEntry(keyCode: 11, mapEntry: 7, mapBit: 4)
		
	]
	
	var keyboardMap: [Int] = [Int](count: 8, repeatedValue: 0xff)
	
	// MARK: Audio
	
	let audioCore = AudioCore(sampleRate: 44100, framesPerSecond: 50)
	var audioStepTStates: Int = (69888 * 50) / 44100
	var audioTStates = 0
	var audioValue = 0

	var event: Event = Event.None
	var snapshotPath: String = ""
	
	var displayTStateTable = [Int](count:69888, repeatedValue: 0)
	
    // MARK: Init

    var appDelegate: AppDelegate

	/**
	* Initialisation
	*/
	init(emulationScreenView: NSView) {
		
		emulationDisplayView = emulationScreenView
		appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
		
		tStatesVerticalBlank = pixelLinesVerticalBlank * tStatesPerLine
		tStatesTopBorder = pixelTopBorderHeight * tStatesPerLine
		tStatesBottomBorder = pixelBottomBorderHeight * tStatesPerLine
		
		pixelDisplayWidth = pixelLeftBorderWidth + pixelScreenWidth + pixelRightBorderWidth + pixelHorizontalFlyback
		pixelDisplayHeight = pixelTopBorderHeight + pixelScreenHeight + pixelBottomBorderHeight + pixelLinesVerticalBlank
		
		pixelDisplayBufferLength = pixelDisplayWidth * pixelDisplayHeight
		displayBuffer = [PixelData](count: pixelDisplayBufferLength, repeatedValue: PixelData(r: 0xfe, g: 0xfe, b: 0xfe, a: 0xff))
		
		emulationTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, emulationQueue)
		
		let FPS = 50.0
		
		dispatch_source_set_timer(emulationTimer, DISPATCH_TIME_NOW, UInt64(1.0 / FPS * Double(NSEC_PER_SEC)), 0)
		dispatch_source_set_event_handler(emulationTimer) {
			
			switch self.event {
			case .None:
				break;
			case .Reset:
				self.event = .None
				self.core.reset()
				self.loadROM()
				break;
			case .LoadSnapShot:
				self.event = .None
				self.loadSnapShot(self.snapshotPath)
				break;
			}
			
			self.runFrame()
			
			self.generateScreenImage()
			
			dispatch_async(dispatch_get_main_queue()) {
				self.emulationDisplayView.layer?.contents = self.imageRef
			}
		}
		
		core = SwiftZ80Core.init(memoryRead: memoryRead,
		                         memoryWrite: memoryWrite,
		                         ioRead: ioRead,
		                         ioWrite: ioWrite,
		                         memoryContention: memoryContention)
		
		buildContentionTable()
		buildtStateDisplayTable()
		
		displayBufferIndex = 32
		
		loadROM()
		
		if let path = NSBundle.mainBundle().pathForResource("Overscan", ofType: "sna") {
			loadSnapShot(path)
		} else {
			print("Could not find snapshot!!")
		}
	
	}
	
    func startExecution() {
        dispatch_resume(emulationTimer)
    }

    func stopExecution() {
        dispatch_suspend(emulationTimer)
    }

	/**
	* Run an entire frame of tStates
	*/
	func runFrame() {
		
		var count = tStatesPerFrame
		displayBuffer!.withUnsafeMutableBufferPointer { mutableDisplayBuffer -> () in
			memory.withUnsafeBufferPointer { memoryBuffer -> () in
				while count > 0 {
					count -= self.step(&mutableDisplayBuffer, memoryBuffer: memoryBuffer)
				}
			}
		}
	}

	/**
	* Execute a single instruction and signal an interrupt when the total number of tStates exceed the total number of tStates in a frame
	*/
    func step(inout mutableDisplayBuffer:UnsafeMutableBufferPointer<PixelData>, memoryBuffer:UnsafeBufferPointer<Byte>) -> (Int) {
		
		let tStatesBeforeExecute = core.tStates
		let cpuStates = core.execute()
		
		updateScreenFromTstate(tStatesBeforeExecute, numberOfTstates: cpuStates, mutableDisplayBuffer: &mutableDisplayBuffer, memoryBuffer: memoryBuffer)
		updateAudioWithTStates(cpuStates)

		if core.tStates >= tStatesPerFrame {
//			print("New Frame")
			self.core.requestInterrupt()
			core.tStates = 32
			displayBufferIndex = 0
			pixelBeamXPos = 0
//			print(core.tStates)
			frameCounter += 1
        }
		
        return cpuStates
    }
	
	/**
	* A reset has been requested through the UI
	*/
    func reset() {
		keyboardMap = [Int](count: 8, repeatedValue: 0xff)
        event = .Reset
    }
	
	// MARK: Audio routines
	
	/**
	* Update the beeper audio tStates and pass the data over to the beeper audio engine
	*/
	func updateAudioWithTStates(numberOfTstates: Int) {
		
		var numTStates = numberOfTstates
		
		while audioTStates + numTStates > audioStepTStates {
			let tStates = audioStepTStates - audioTStates
			audioValue += beeperOn ? (8192 * tStates) : 0
			audioCore.updateBeeperWithValue(Float(audioValue) / Float(audioStepTStates))
			numTStates = (audioTStates + numTStates) - audioStepTStates
			audioValue = 0
			audioTStates = 0
		}
		
		audioValue += beeperOn ? (8192 * numTStates) : 0
		audioTStates += numTStates
		
	}
	
    // MARK: Screen routines
	
	func incBufferIndex() {
		displayBufferIndex += 1
		if displayBufferIndex >= pixelDisplayBufferLength {
			displayBufferIndex = 0
		}
	}
	
    func updateScreenFromTstate(tState: Int, numberOfTstates: Int, inout mutableDisplayBuffer: UnsafeMutableBufferPointer<PixelData>, memoryBuffer:UnsafeBufferPointer<Byte>) {
		
		// Having the palette here and using unsafe mutable pointers reduces CPU usage by around 7%!!!
		let pall : [UInt8] = [
            
            // Normal colours
            0x00, 0x00, 0x00, 0xff, // Black
            0x00, 0x00, 0xc0, 0xff, // Blue
			0xc0, 0x00, 0x00, 0xff,	// Red
            0xc0, 0x00, 0xc0, 0xff, // Magenta
            0x00, 0xc0, 0x00, 0xff, // Green
            0x00, 0xc0, 0xc0, 0xff, // Cyan
			0xc0, 0xc0, 0x00, 0xff, // Yellow
            0xc0, 0xc0, 0xc0, 0xff, // White
            
            // Bright colours
			0x00, 0x00, 0x00, 0xff, // Black
			0x00, 0x00, 0xff, 0xff, // Blue
			0xff, 0x00, 0x00, 0xff,	// Red
			0xff, 0x00, 0xff, 0xff, // Magenta
			0x00, 0xff, 0x00, 0xff, // Green
			0x00, 0xff, 0xff, 0xff, // Cyan
			0xff, 0xff, 0x00, 0xff, // Yellow
			0xff, 0xff, 0xff, 0xff, // White
        ]
		

		for i in 0 ..< numberOfTstates {
			
			var dispTState = tState + i
			
			if dispTState >= 69888 {
				dispTState = i
			}
			
			let retraceColour = 2 * 4
			
			if displayTStateTable[ dispTState ] == DisplayType.Retrace.rawValue {
//				print("Retrace: \(dispTState)")
				mutableDisplayBuffer[ displayBufferIndex ].r = pall.withUnsafeBufferPointer { p -> UInt8 in return p[retraceColour] }
				mutableDisplayBuffer[ displayBufferIndex ].g = pall.withUnsafeBufferPointer { p -> UInt8 in return p[retraceColour + 1] }
				mutableDisplayBuffer[ displayBufferIndex ].b = pall.withUnsafeBufferPointer { p -> UInt8 in return p[retraceColour + 2] }
				mutableDisplayBuffer[ displayBufferIndex ].a = pall.withUnsafeBufferPointer { p -> UInt8 in return p[retraceColour + 3] }
				incBufferIndex()

				mutableDisplayBuffer[ displayBufferIndex ].r = pall.withUnsafeBufferPointer { p -> UInt8 in return p[retraceColour] }
				mutableDisplayBuffer[ displayBufferIndex ].g = pall.withUnsafeBufferPointer { p -> UInt8 in return p[retraceColour + 1] }
				mutableDisplayBuffer[ displayBufferIndex ].b = pall.withUnsafeBufferPointer { p -> UInt8 in return p[retraceColour + 2] }
				mutableDisplayBuffer[ displayBufferIndex ].a = pall.withUnsafeBufferPointer { p -> UInt8 in return p[retraceColour + 3] }
				incBufferIndex()
			}
			
			if displayTStateTable[ dispTState ] == DisplayType.Border.rawValue {
//				print("Border: \(dispTState)")
				mutableDisplayBuffer[ displayBufferIndex ].r = pall.withUnsafeBufferPointer { p -> UInt8 in return p[borderColour] }
				mutableDisplayBuffer[ displayBufferIndex ].g = pall.withUnsafeBufferPointer { p -> UInt8 in return p[borderColour + 1] }
				mutableDisplayBuffer[ displayBufferIndex ].b = pall.withUnsafeBufferPointer { p -> UInt8 in return p[borderColour + 2] }
				mutableDisplayBuffer[ displayBufferIndex ].a = pall.withUnsafeBufferPointer { p -> UInt8 in return p[borderColour + 3] }
				incBufferIndex()
				
				mutableDisplayBuffer[ displayBufferIndex ].r = pall.withUnsafeBufferPointer { p -> UInt8 in return p[borderColour] }
				mutableDisplayBuffer[ displayBufferIndex ].g = pall.withUnsafeBufferPointer { p -> UInt8 in return p[borderColour + 1] }
				mutableDisplayBuffer[ displayBufferIndex ].b = pall.withUnsafeBufferPointer { p -> UInt8 in return p[borderColour + 2] }
				mutableDisplayBuffer[ displayBufferIndex ].a = pall.withUnsafeBufferPointer { p -> UInt8 in return p[borderColour + 3] }
				incBufferIndex()
			}

			if displayTStateTable[ dispTState ] == DisplayType.Display.rawValue {
//				print("Display: \(dispTState)")
				mutableDisplayBuffer[ displayBufferIndex ].r = pall.withUnsafeBufferPointer { p -> UInt8 in return p[28] }
				mutableDisplayBuffer[ displayBufferIndex ].g = pall.withUnsafeBufferPointer { p -> UInt8 in return p[28 + 1] }
				mutableDisplayBuffer[ displayBufferIndex ].b = pall.withUnsafeBufferPointer { p -> UInt8 in return p[28 + 2] }
				mutableDisplayBuffer[ displayBufferIndex ].a = pall.withUnsafeBufferPointer { p -> UInt8 in return p[28 + 3] }
				incBufferIndex()
				
				mutableDisplayBuffer[ displayBufferIndex ].r = pall.withUnsafeBufferPointer { p -> UInt8 in return p[28] }
				mutableDisplayBuffer[ displayBufferIndex ].g = pall.withUnsafeBufferPointer { p -> UInt8 in return p[28 + 1] }
				mutableDisplayBuffer[ displayBufferIndex ].b = pall.withUnsafeBufferPointer { p -> UInt8 in return p[28 + 2] }
				mutableDisplayBuffer[ displayBufferIndex ].a = pall.withUnsafeBufferPointer { p -> UInt8 in return p[28 + 3] }
				incBufferIndex()
			}

		}
		
		
		
//		for i in 0 ..< (numberOfTstates << 1) {
//				
//			let x: Int = pixelBeamXPos
//			let y: Int = pixelBeamYPos - pixelLinesVerticalBlank
//			
//			let displayBufferIndex = (y * pixelDisplayWidth) + x
//			
//			let c1 = x < pixelDisplayWidth
//			let c2 = y < pixelDisplayHeight + pixelBottomBorderHeight
//			let c3 = y >= 0
//			
//			if c3 && c2 && c1 {
//
//				if y < pixelTopBorderHeight || y >= pixelScreenHeight + pixelTopBorderHeight {
////						print("Top/Bottom Border: \(tState + i)")
//					
//					// Draw top or bottom border
//					mutableDisplayBuffer[ displayBufferIndex ].r = pall.withUnsafeBufferPointer { p -> UInt8 in return p[borderColour] }
//					mutableDisplayBuffer[ displayBufferIndex ].g = pall.withUnsafeBufferPointer { p -> UInt8 in return p[borderColour + 1] }
//					mutableDisplayBuffer[ displayBufferIndex ].b = pall.withUnsafeBufferPointer { p -> UInt8 in return p[borderColour + 2] }
//					mutableDisplayBuffer[ displayBufferIndex ].a = pall.withUnsafeBufferPointer { p -> UInt8 in return p[borderColour + 3] }
//					
//				} else {
//
//					if x < pixelLeftBorderWidth || x >= pixelScreenWidth + pixelLeftBorderWidth {
////							print("Left/Right Border: \(tState + i)")
//						
//						// Draw left and right border
//						mutableDisplayBuffer[ displayBufferIndex ].r = pall.withUnsafeBufferPointer { p -> UInt8 in return p[borderColour] }
//						mutableDisplayBuffer[ displayBufferIndex ].g = pall.withUnsafeBufferPointer { p -> UInt8 in return p[borderColour + 1] }
//						mutableDisplayBuffer[ displayBufferIndex ].b = pall.withUnsafeBufferPointer { p -> UInt8 in return p[borderColour + 2] }
//						mutableDisplayBuffer[ displayBufferIndex ].a = pall.withUnsafeBufferPointer { p -> UInt8 in return p[borderColour + 3] }
//						
//					} else { // Must be on the screen so draw that
////							print("Display: \(tState + i)")
//						
//						let px = x - pixelLeftBorderWidth
//						let py = y - pixelTopBorderHeight
//						
//						let pixelAddress = 16384 + (px >> 3) + ((py & 0x07) << 8) + ((py & 0x38) << 2) + ((py & 0xc0) << 5)
//						let attributeAddress = 16384 + (32 * 192) + (px >> 3) + ((py >> 3) << 5)
//						
//						let pixelByte = memoryBuffer[Int(pixelAddress)]
//						let attributeByte = memoryBuffer[Int(attributeAddress)]
//						
//						var paper: Int = ((Int(attributeByte) & 0x78) >> 1)
//						var ink: Int = ((Int(attributeByte) & 0x07) << 2) | ((Int(attributeByte) & 0x40) >> 1)
//						
//						if frameCounter & 16 != 0 && attributeByte & 0x80 != 0 {
//							let t = ink;
//							ink = paper;
//							paper = t;
//						}
//						
//						if Int(pixelByte) & (0x80 >> (px & 7)) != 0 {
//							
//							mutableDisplayBuffer[ displayBufferIndex ].r = pall.withUnsafeBufferPointer { p -> UInt8 in return p[ink] }
//							mutableDisplayBuffer[ displayBufferIndex ].g = pall.withUnsafeBufferPointer { p -> UInt8 in return p[ink + 1] }
//							mutableDisplayBuffer[ displayBufferIndex ].b = pall.withUnsafeBufferPointer { p -> UInt8 in return p[ink + 2] }
//							mutableDisplayBuffer[ displayBufferIndex ].a = pall.withUnsafeBufferPointer { p -> UInt8 in return p[ink + 3] }
//
//						} else {
//							
//							mutableDisplayBuffer[ displayBufferIndex ].r = pall.withUnsafeBufferPointer { p -> UInt8 in return p[paper] }
//							mutableDisplayBuffer[ displayBufferIndex ].g = pall.withUnsafeBufferPointer { p -> UInt8 in return p[paper + 1] }
//							mutableDisplayBuffer[ displayBufferIndex ].b = pall.withUnsafeBufferPointer { p -> UInt8 in return p[paper + 2] }
//							mutableDisplayBuffer[ displayBufferIndex ].a = pall.withUnsafeBufferPointer { p -> UInt8 in return p[paper + 3] }
//
//						}
//					}
//					
//				}
//				
//			} else {
////					print("Retrace: \(tState + i)")
//			}
//				
//			pixelBeamXPos += 1
//			
//			if pixelBeamXPos >= (tStatesPerLine << 1) {
//				
//				pixelBeamXPos -= (tStatesPerLine << 1)
//				pixelBeamYPos += 1
//				
//				if pixelBeamYPos >= pixelDisplayHeight + pixelLinesVerticalBlank  {
//					pixelBeamYPos -= pixelDisplayHeight + pixelLinesVerticalBlank
//				}
//			}
//			
//		}
    }
	
	enum DisplayType: Int {
		case Border
		case Display
		case Retrace
	}
	
	func buildtStateDisplayTable() {
		
		var tState = 0

		for _ in 0 ..< 1 {
			for _ in 0 ..< tStatesPerLine - tStatesLeftBorderWidth {
				displayTStateTable[tState] = DisplayType.Retrace.rawValue
				tState += 1
			}
		}

		for _ in 0 ..< 7 {
			for _ in 0 ..< tStatesPerLine {
				displayTStateTable[tState] = DisplayType.Retrace.rawValue
				tState += 1
			}
		}

		// Top Border
		for _ in 0 ..< pixelTopBorderHeight {
			for _ in 0 ..< tStatesPerLine - tStatesHorizontalFlyback {
				displayTStateTable[tState] = DisplayType.Border.rawValue
				tState += 1
			}

			// Flyback
			for _ in 0 ..< tStatesHorizontalFlyback {
				displayTStateTable[tState] = DisplayType.Retrace.rawValue
				tState += 1
			}
		}
		
		// Left border, pixel display, right border
		for _ in 0 ..< pixelScreenHeight {
			
			// Left Border (2 pixels per tState)
			for _ in 0 ..< tStatesLeftBorderWidth {
				displayTStateTable[tState] = DisplayType.Border.rawValue
				tState += 1
			}

			// Pixel display
			for _ in 0 ..< tStatesScreenWidth {
				displayTStateTable[tState] = DisplayType.Display.rawValue
				tState += 1
			}

			// Right Border
			for _ in 0 ..< tStatesRightBorderWidth {
				displayTStateTable[tState] = DisplayType.Border.rawValue
				tState += 1
			}

			// Flyback
			for _ in 0 ..< tStatesHorizontalFlyback {
				displayTStateTable[tState] = DisplayType.Retrace.rawValue
				tState += 1
			}

		}
		
		// Bottom border
		for _ in 0 ..< pixelBottomBorderHeight {
			for _ in 0 ..< tStatesPerLine - tStatesHorizontalFlyback {
				displayTStateTable[tState] = DisplayType.Border.rawValue
				tState += 1
			}

			// Flyback
			for _ in 0 ..< tStatesHorizontalFlyback {
				displayTStateTable[tState] = DisplayType.Retrace.rawValue
				tState += 1
			}
		}

		for _ in 0 ..< tStatesLeftBorderWidth {
			displayTStateTable[tState] = DisplayType.Retrace.rawValue
			tState += 1
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
    
    // MARK - ViewEventProtocol functions
	
	func keyDown(theEvent: NSEvent) {

		switch theEvent.keyCode {

		case 51: // Backspace
			keyboardMap[0] &= ~0x01; // Shift
			keyboardMap[4] &= ~0x01; // 0
		break;
		
		case 126: // Arrow up
			keyboardMap[0] &= ~0x01; // Shift
			keyboardMap[4] &= ~0x08; // 7
		break;
		
		case 125: // Arrow down
			keyboardMap[0] &= ~0x01; // Shift
			keyboardMap[4] &= ~0x10; // 6
		break;
		
		case 123: // Arrow left
			keyboardMap[0] &= ~0x01; // Shift
			keyboardMap[3] &= ~0x10; // 5
		break;
		
		case 124: // Arrow right
			keyboardMap[0] &= ~0x01; // Shift
			keyboardMap[4] &= ~0x04; // 8
		break;
		
		default:
			
			for i in 0 ..< keyboardLookup.count {
				if keyboardLookup[i].keyCode == Int(theEvent.keyCode) {
					let newValue: Int = ~(1 << keyboardLookup[i].mapBit)
					let entry: Int = keyboardLookup[i].mapEntry
					var val: Int = keyboardMap[entry]
					val = val & newValue
					keyboardMap[keyboardLookup[i].mapEntry] = val
					break;
				}
			}
			
		}

	}

	func keyUp(theEvent: NSEvent) {
		
		switch theEvent.keyCode {
			
		case 51: // Backspace
			keyboardMap[0] |= 0x01; // Shift
			keyboardMap[4] |= 0x01; // 0
			break;
			
		case 126: // Arrow up
			keyboardMap[0] |= 0x01; // Shift
			keyboardMap[4] |= 0x08; // 7
			break;
			
		case 125: // Arrow down
			keyboardMap[0] |= 0x01; // Shift
			keyboardMap[4] |= 0x10; // 6
			break;
			
		case 123: // Arrow left
			keyboardMap[0] |= 0x01; // Shift
			keyboardMap[3] |= 0x10; // 5
			break;
			
		case 124: // Arrow right
			keyboardMap[0] |= 0x01; // Shift
			keyboardMap[4] |= 0x04; // 8
			break;
			
		default:
			
			for i in 0 ..< keyboardLookup.count {
				if keyboardLookup[i].keyCode == Int(theEvent.keyCode) {
					let newValue: Int = (1 << keyboardLookup[i].mapBit)
					let entry: Int = keyboardLookup[i].mapEntry
					var val: Int = keyboardMap[Int(entry)]
					val = val | newValue
					keyboardMap[keyboardLookup[i].mapEntry] = val
					break;
				}
			}
			
		}
	}
	
	func flagsChanged(theEvent: NSEvent) {
		
        switch (theEvent.keyCode) {
			
        case 56: fallthrough// Left Shift (CAPS SHIFT on the Spectrum)
        case 60: // Right Shift (CAPS SHIFT on the Spectrum)
            if theEvent.modifierFlags.contains(.ShiftKeyMask) {
                keyboardMap[0] &= ~0x01;
            } else {
                keyboardMap[0] |= 0x01;
            }
            break;
        
        case 59: // Control (SYMBOL SHIFT on the Spectrum)
            if theEvent.modifierFlags.contains(.ControlKeyMask) {
                keyboardMap[7] &= ~0x02;
            } else {
                keyboardMap[7] |= 0x02;
            }
            
        default:
            break;
        }
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
	
	func loadSnapShotWithPath(path: String) {
		snapshotPath = path
		event = .LoadSnapShot
	}
	
	private func loadSnapShot(path: String) {
		
		let data = NSData.init(contentsOfFile: path)
		let count = data!.length / sizeof(Byte)
		var fileBytes = [Byte](count: count, repeatedValue: 0x00)
		
		data!.getBytes(&fileBytes, length: count * sizeof(Byte))
		
		if data?.length == 49179 {
			
			var snaAddr = 27
			for i in 16384 ..< (48 * 1024) + 16384 {
				memory[i] = fileBytes[snaAddr]
				snaAddr += 1
			}
			
			core.I = fileBytes[0]
			core.L_ = fileBytes[1]
			core.H_ = fileBytes[2]
			core.E_ = fileBytes[3]
			core.D_ = fileBytes[4]
			core.C_ = fileBytes[5]
			core.B_ = fileBytes[6]
			core.F_ = fileBytes[7]
			core.A_ = fileBytes[8]
			core.L = fileBytes[9]
			core.H = fileBytes[10]
			core.E = fileBytes[11]
			core.D = fileBytes[12]
			core.C = fileBytes[13]
			core.B = fileBytes[14]
			core.IYl = fileBytes[15]
			core.IYh = fileBytes[16]
			core.IXl = fileBytes[17]
			core.IXh = fileBytes[18]
			core.IFF2 = (fileBytes[19] >> 2) & 0x01
			core.IFF1 = (fileBytes[19] >> 2) & 0x01
			core.R = fileBytes[20]
			core.F = fileBytes[21]
			core.A = fileBytes[22]
			core.SPl = fileBytes[23]
			core.SPh = fileBytes[24]
			core.IM = fileBytes[25]
			borderColour = Int(((fileBytes[26]) & 0x07) << 2)
			
			core.PCl = memory[Int(core.SP)]
			core.PCh = memory[Int(core.SP + 1)]
			core.SP = core.SP &+ 2
		}
		
	}
	
	// MARK: Memory IO routines
	
	/**
	* Read a byte from the address provided in main memory
	*/
	func memoryRead(address: Word) -> Byte {
		
		return memory.withUnsafeBufferPointer { memoryBuffer -> (Byte) in
			return memoryBuffer[Int(address)]
		}
	}
	
	/**
	* Write the supplied byte into the supplied address in main memory, but only if the address is not within the ROM space
	*/
	func memoryWrite(address: Word, value: Byte) {
		
		if address >= 16384 {
			
			memory.withUnsafeMutableBufferPointer { mutableMemoryBuffer -> () in
				mutableMemoryBuffer[Int(address)] = value
			}
		}
	}
	
	/**
	* Read a byte from the port (address) provided. This deals with contention added when reading IO ports as well
	*/
	func ioRead(address: Word) -> Byte {
		
		if address >= 16384 && address <= 32767 {
			
			if address & 1 == 0 {
				core.tStates += contentionTable[core.tStates % tStatesPerFrame]
				core.tStates += 1
				core.tStates += contentionTable[core.tStates % tStatesPerFrame]
				core.tStates += 3
			} else {
				core.tStates += contentionTable[core.tStates % tStatesPerFrame]
				core.tStates += 1
				core.tStates += contentionTable[core.tStates % tStatesPerFrame]
				core.tStates += 1
				core.tStates += contentionTable[core.tStates % tStatesPerFrame]
				core.tStates += 1
				core.tStates += contentionTable[core.tStates % tStatesPerFrame]
				core.tStates += 1
			}
		} else {
			
			if address & 1 == 0 {
				core.tStates += 1
				core.tStates += contentionTable[core.tStates % tStatesPerFrame]
				core.tStates += 3
			} else {
				core.tStates += 4
			}
		}
		
		// Read the keyboard matrix
		if address & 0xff == 0xfe {
			for i in 0 ..< 8 {
				let addr: Word = Word(address) & Word(0x100 << i)
				if addr == 0 {
					return Byte(keyboardMap[i] & 0xff)
				}
			}
		}
		
		return 0xff
	}
	
	/**
	* Write the supplied byte to the supplied port (address). This deals with contention when writing to an IO port
	*/
	func ioWrite(address: Word, value: Byte) {
		
		if address >= 16384 && address <= 32767 {
			
			if address & 1 == 0 {
				core.tStates += contentionTable[core.tStates % tStatesPerFrame]
				core.tStates += 1
				core.tStates += contentionTable[core.tStates % tStatesPerFrame]
				core.tStates += 3
			} else {
				core.tStates += contentionTable[core.tStates % tStatesPerFrame]
				core.tStates += 1
				core.tStates += contentionTable[core.tStates % tStatesPerFrame]
				core.tStates += 1
				core.tStates += contentionTable[core.tStates % tStatesPerFrame]
				core.tStates += 1
				core.tStates += contentionTable[core.tStates % tStatesPerFrame]
				core.tStates += 1
			}
		} else {
			
			if address & 1 == 0 {
				core.tStates += 1
				core.tStates += contentionTable[core.tStates % tStatesPerFrame]
				core.tStates += 3
			} else {
				core.tStates += 4
			}
		}
		
		if address & 255 == 0xfe {
			borderColour = (Int(value) & 0x07) << 2
			beeperOn = (value & 0x10) != 0 ? true : false
		}
	}
	
	func memoryContention(address: Word, tStates: Int) {
		
		if address >= 16384 && address <= 32767 {
			core.tStates += contentionTable[core.tStates % tStatesPerFrame]
		}
		
	}
	
	// MARK: Contention table
	
	/**
	* Build a table of that holds the number of tStates the CPU should be delayed based on specific tState values. This is
	* used to then add contention to memory and IO access
	*/
	func buildContentionTable() {
		
		let contentionValue = [6, 5, 4, 3, 2, 1, 0, 0]
		
		for i in 0 ..< tStatesPerFrame {
			
			let tState = i - ((tStatesTopBorder + tStatesVerticalBlank) - 1)
			
			if tState >= 0 && tState < tStatesScreenHeight {
				let perLine = tState % tStatesPerLine
				if perLine < tStatesScreenWidth {
					contentionTable[i] = contentionValue[perLine & 7]
				}
			}
		}
	}
	

	
	
	
	
}