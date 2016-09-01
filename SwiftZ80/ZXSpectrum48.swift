//
//  ZXSpectrum48.swift
//  SwiftZ80
//
//  Created by Mike Daley on 13/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

import Foundation
import Cocoa

/**
* Structs
*/
public struct PixelData {
    var r: UInt8
    var g: UInt8
    var b: UInt8
    var a: UInt8
}

public struct KeyboardEntry {
	var keyCode: Int
	var mapEntry: Int
	var mapBit: Int
}

/**
* Enums
*/
enum Event {
	case None
	case Reset
	case LoadSnapShot
}

enum DisplayType: Int {
	case Border
	case Display
	case Retrace
}

/**
* Class
*/
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
    let pixelTopBorderHeight = 56
    let pixelScreenHeight = 192
    let pixelBottomBorderHeight = 56
    let pixelLinesVerticalBlank = 8
	let pixelHorizontalFlyback = 96
    
    let tStatesPerFrame = 69888
    let tStatesPerLine = 224
    
    let tStatesLeftBorderWidth = 16
    let tStatesScreenWidth = 128
    let tStatesScreenHeight = 43008
    let tStatesRightBorderWidth = 32
    let tStatesHorizontalFlyback = 48
    
    var tStatesVerticalBlank = 0
    var tStatesTopBorder = 56 * 224
    var tStatesBottomBorder = 56 * 224
    
    var pixelDisplayWidth: Int
    var pixelDisplayHeight: Int
    
    var pixelBeamXPos = 0
    var pixelBeamYPos = 0
	

    var borderColour: Int = (7 & 0x07)
    var imageRef: CGImageRef?
    
    var frameCounter: Int = 0
	
	let pall : [PixelData] = [
		
		PixelData(r: 0, g: 0, b: 0, a: 255),
		PixelData(r: 0, g: 0, b: 204, a: 255),
		PixelData(r: 204, g: 0, b: 0, a: 255),
		PixelData(r: 204, g: 0, b: 204, a: 255),
		PixelData(r: 0, g: 204, b: 0, a: 255),
		PixelData(r: 0, g: 204, b: 204, a: 255),
		PixelData(r: 204, g: 204, b: 0, a: 255),
		PixelData(r: 204, g: 204, b: 204, a: 255),
		
		PixelData(r: 0, g: 0, b: 0, a: 255),
		PixelData(r: 0, g: 0, b: 255, a: 255),
		PixelData(r: 255, g: 0, b: 0, a: 255),
		PixelData(r: 255, g: 0, b: 255, a: 255),
		PixelData(r: 0, g: 255, b: 0, a: 255),
		PixelData(r: 0, g: 255, b: 255, a: 255),
		PixelData(r: 255, g: 255, b: 0, a: 255),
		PixelData(r: 255, g: 255, b: 255, a: 255),
		]
	
    // MARK: Screen image details
	
    let bitsPerPixel = 32       // RGBA - bites
    let bytesPerPixel = 4       // RGBA - bytes
    let bitsPerComponent = 8	// 32bit
    var pixelDisplayBufferLength: Int
    let shouldInterpolate = true
    var emulationScreenImage: CGImageRef?
    
    let colourSpace = CGColorSpaceCreateDeviceRGB()!
    let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
    var displayBuffer: [PixelData]
	var emulationDisplayView: NSView!
	var displayBufferIndex = 0
	
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
		
		pixelDisplayWidth = 32 + 256 + 64
		pixelDisplayHeight = 56 + 192 + 56
		
		pixelDisplayBufferLength = (32 + 256 + 64) * (56 + 192 + 56)
		
		displayBuffer = [PixelData](count: pixelDisplayBufferLength, repeatedValue: PixelData(r: 0xfe, g: 0xfe, b: 0xfe, a: 0xff))
		
		emulationTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, emulationQueue)
		
		core = SwiftZ80Core.init(memoryRead: memoryRead,
		                         memoryWrite: memoryWrite,
		                         ioRead: ioRead,
		                         ioWrite: ioWrite,
		                         memoryContention: memoryContention)
		
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
	
		buildContentionTable()
		
		loadROM()
		
		if let path = NSBundle.mainBundle().pathForResource("shock", ofType: "sna") {
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
	* Run an entire frame which consists of 69888 tStates
	*/
	func runFrame() {
		
		var count = tStatesPerFrame
        while count > 0 {
            count -= self.step()
        }
	}

	/**
	* Execute a single instruction and signal an interrupt when the total number of tStates exceed the total number of tStates in a frame
	*/
    func step() -> (Int) {
		
		let cpuStates = core.execute()
		
		updateScreenWithTStates(cpuStates)
		updateAudioWithTStates(cpuStates)

		if core.tStates >= tStatesPerFrame {
			core.tStates = 0
			pixelBeamXPos = 32
            self.core.requestInterrupt()
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

	/**
	* Updat the screens image buffer based on the number of tStates passed in. pixelBeamXPos and pixelBeamYPos are used to 
	* track the physical location of the beam on the display so that we know where in the image we need to draw pixels
	* based on the tStates that have passed in the current frame. Two pixels are drawn for each tState.
	*/
    func updateScreenWithTStates(numberOfTstates: Int) {
		
		for _ in 0 ..< (numberOfTstates << 1) {

			var x = pixelBeamXPos + 32
			var y = pixelBeamYPos - 8
            
            if x >= 448 {
                x -= 448
                y += 1
            }

			let displayBufferIndex = y * (32 + 256 + 64) + x
			
			if y >= 0 && y < 304 && x < (32 + 256 + 64) {

				if y < 56 || y >= (192 + 56) { // Draw top or bottom border

                    let colour = pall.withUnsafeBufferPointer { p -> PixelData in return p[borderColour] }
                    displayBuffer[ displayBufferIndex ] = colour

				} else {

                    if x < 32 || x >= (32 + 256) { // Draw left and right border
                        
                        let colour = pall.withUnsafeBufferPointer { p -> PixelData in return p[borderColour] }
                        displayBuffer[ displayBufferIndex ] = colour

					} else { // Must be on the bitmap display so draw that

						let px = x - 32
						let py = y - 56

						let pixelAddress = 16384 + (px >> 3) + ((py & 0x07) << 8) + ((py & 0x38) << 2) + ((py & 0xc0) << 5)
						let attributeAddress = 16384 + (32 * 192) + (px >> 3) + ((py >> 3) << 5)

						let pixelByte = memory[pixelAddress]
						let attributeByte = memory[attributeAddress]

                        var ink = Int((attributeByte & 0x07) + ((attributeByte & 0x40) >> 3))
                        var paper = Int(((attributeByte >> 3) & 0x07) + ((attributeByte & 0x40) >> 3))

						if (frameCounter & 16) != 0 && (attributeByte & 0x80) != 0 {
							let tempInk = ink;
							ink = paper
							paper = tempInk;
						}

						if Int(pixelByte) & (0x80 >> (px & 7)) != 0 {

                            let colour = pall.withUnsafeBufferPointer { p -> PixelData in return p[ink] }
                            displayBuffer[ displayBufferIndex ] = colour

						} else {

                            let colour = pall.withUnsafeBufferPointer { p -> PixelData in return p[paper] }
                            displayBuffer[ displayBufferIndex ] = colour

						}
					}
				}
			}

			pixelBeamXPos += 1

			if pixelBeamXPos >= 448 {

				pixelBeamXPos -= 448
				pixelBeamYPos += 1

				if pixelBeamYPos >= 312  {
					pixelBeamYPos -= 312
				}
			}

		}
		
    }
	
	/**
	* Using the display buffer data, create a CGImageRef that will then be used as the content image for the emulations
	* screen view. This is called after each frame has finished which is 50 times per second.
	*/
    func generateScreenImage() {
        
        let providerData = NSData(bytes: &displayBuffer, length: displayBuffer.count * sizeof(PixelData))
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
			borderColour = Int(((fileBytes[26]) & 0x07))
			
			core.PCl = memory[Int(core.SP)]
			core.PCh = memory[Int(core.SP + 1)]
			core.SP = core.SP &+ 2
		}
		
	}
	
	// MARK: Memory & IO routines
	
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

		// Calculate the necessary contention based on the Port number being accessed and if the port belongs to the ULA.
		// All non-even port numbers below to the ULA. N:x means no contention to be added and just advance the tStates.
		// C:x means that contention should be calculated based on the current tState value and then x tStates are to be
		// added to the current tState count
		//
		// in 40 - 7F?| Low bit | Contention pattern
		//------------+---------+-------------------
		//		No    |  Reset  | N:1, C:3
		//		No    |   Set   | N:4
		//		Yes   |  Reset  | C:1, C:3
		//		Yes   |   Set   | C:1, C:1, C:1, C:1
		
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

		// Calculate the necessary contention based on the Port number being accessed and if the port belongs to the ULA.
		// All non-even port numbers below to the ULA. N:x means no contention to be added and just advance the tStates.
		// C:x means that contention should be calculated based on the current tState value and then x tStates are to be
		// added to the current tState count
		//
		// in 40 - 7F?| Low bit | Contention pattern
		//------------+---------+-------------------
		//		No    |  Reset  | N:1, C:3
		//		No    |   Set   | N:4
		//		Yes   |  Reset  | C:1, C:3
		//		Yes   |   Set   | C:1, C:1, C:1, C:1
		
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
		} else { // Port not between 0x4000 and 0x7fff
			
			if address & 1 == 0 {
				core.tStates += 1
				core.tStates += contentionTable[core.tStates % tStatesPerFrame]
				core.tStates += 3
			} else {
				core.tStates += 4
			}
		}
		
		if address & 255 == 0xfe {
			borderColour = (Int(value) & 0x07)
			beeperOn = (value & 0x10) != 0 ? true : false
		}

	}
	
	/**
	* Apply any machine specific contention to the core
	*/
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
            
            let tState = i - ((12544 + 1792) - 1)
            
            if tState >= 0 && tState < 43008 {
                let perLine = tState % tStatesPerLine
                if perLine < 128 {
                    contentionTable[i] = contentionValue[perLine & 7]
                }
            }
        }
    }
    
}