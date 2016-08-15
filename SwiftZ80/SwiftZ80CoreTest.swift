//
//  SwiftZ80CoreTest.swift
//  SwiftZ80
//
//  Created by Mike Daley on 15/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

import Foundation


class SwiftZ80CoreTest {
	
	var memory = [Byte](count: 64 * 1024, repeatedValue: 0x00)
	var initialMemroy = [Byte](count: 64 * 1024, repeatedValue: 0x00)
	var core: SwiftZ80Core?
	
	init() {
		
		core = SwiftZ80Core.init(memoryRead: readFromMemoryAddress,
		                         memoryWrite: writeToMemoryAddress,
		                         ioRead: ioReadAddress,
		                         ioWrite: ioWriteAddress,
		                         contentionReadNoMREQ: contentionReadNoMREQAddress,
		                         contentionWriteNoMREQ: contentionWriteNoMREQAddress,
		                         contentionRead: contentionReadAddress)
		
		
	}
	
	
	/**
	* Memory and IO routines
	*/
	
	func readFromMemoryAddress(address: Word) -> Byte {
		core!.tStates += 3
		return memory[address]
	}
	
	func writeToMemoryAddress(address: Word, value: Byte) {
		core!.tStates += 3
		memory[address] = value
	}
	
	func ioReadAddress(address: Word) -> Byte {
		return 0xff
	}
	
	func ioWriteAddress(address: Word, value: Byte) {
		
	}
	
	func contentionReadNoMREQAddress(address: Word, tStates: Int) {
		core!.tStates += tStates
	}
	
	func contentionWriteNoMREQAddress(address: Word, tStates: Int) {
		core!.tStates += tStates
	}
	
	func contentionReadAddress(address: Word, tStates: Int) {
		core!.tStates += tStates
	}
	
}