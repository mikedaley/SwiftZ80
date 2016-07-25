//
//  AppDelegate.swift
//  SwiftZ80
//
//  Created by Mike Daley on 21/07/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

import Cocoa

/**
* Array Extension
* This extension adds a Word subscript
*/
extension Array {
	subscript(i: Word) -> Element {
		get {
			return self[Int(i)]
		}
		set (newValue) {
			self[Int(i)] = newValue
		}
	}
}


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!
    @IBOutlet weak var memoryViewController: MemoryViewController!
    
	// Main memory array
	var memory = [Byte](count: 65536, repeatedValue: 0x00)

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		// Insert code here to initialize your application
        
        window.contentView = memoryViewController.view
        memoryViewController.view.wantsLayer = true
		
		memory[0] = 0x0a
		memory[1] = 0xfa
		
		let z80Core = SwiftZ80.init(memoryRead: readFromMemoryAddress,
		                            memoryWrite: writeToMemoryAddress,
		                            ioRead: ioRead,
		                            ioWrite: ioWrite,
		                            contentionReadNoMReq: contentionReadNoMReq,
		                            contentionWriteNoMReq: contentionWriteNoMReq,
		                            contentionRead: contentionRead)
		
		z80Core.context.R1.BC = 0x0a0b
		print(String(format: "0x%04X", z80Core.context.R1.BC))

		z80Core.context.R1.B = 0x0f
		print(String(format: "0x%04X", z80Core.context.R1.BC))

		z80Core.context.R1.C = 0x43
		print(String(format: "0x%04X", z80Core.context.R1.BC))
		
		z80Core.context.memoryWrite(address: 0x000a, value: 0xdd)
		print(z80Core.context.memoryRead(address: 0x000a))

	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}
	
    
    
    
	
/**
* Z80 Core context method implementations
*/
	
	func readFromMemoryAddress(address: Word) -> Byte {
		return memory[address]
	}

	func writeToMemoryAddress(address: Word, value: Byte) {
		memory[address] = value
	}

	func ioRead(address: Word) -> Byte {
		return 0xff
	}
	
	func ioWrite(address: Word, value: Byte) {
		
	}
	
	func contentionReadNoMReq(address: Word, tStates: Int) {
		
	}

	func contentionWriteNoMReq(address: Word, tStates: Int) {
		
	}
	
	func contentionRead(address: Word, tStates: Int) {
		
	}

}

