//
//  SwiftZ80CoreTest.swift
//  SwiftZ80
//
//  Created by Mike Daley on 15/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

import Cocoa

class SwiftZ80CoreTest {
	
	var memory = [Byte](count: 64 * 1024, repeatedValue: 0x00)
	var initialMemory = [Byte](count: 64 * 1024, repeatedValue: 0x00)
	var core: SwiftZ80Core?
	var scanner: StreamScanner?
	var outputString: String = ""
	
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
		print(String.localizedStringWithFormat("%5d MR %04x %02x", core!.tStates, address, memory[address]))
		return memory[address]
	}
	
	func writeToMemoryAddress(address: Word, value: Byte) {
		print(String.localizedStringWithFormat("%5d MW %04x %02x", core!.tStates, address, value))
		memory[address] = value
	}
	
	func ioReadAddress(address: Word) -> Byte {
		
		if address & 0xc000 == 0x4000 {
			print(String.localizedStringWithFormat("%5d PC %04x", core!.tStates, address))
		}
		core!.tStates += 1
		
		print(String.localizedStringWithFormat("%5d PR %04x %02x", core!.tStates, address, address >> 8))
		
		if address & 0x0001 != 0 {
			
			if address & 0xc000 == 0x4000 {
				print(String.localizedStringWithFormat("%5d PC %04x", core!.tStates, address))
				core!.tStates += 1
				print(String.localizedStringWithFormat("%5d PC %04x", core!.tStates, address))
				core!.tStates += 1
				print(String.localizedStringWithFormat("%5d PC %04x", core!.tStates, address))
				core!.tStates += 1
			} else {
				core!.tStates += 3
			}
			
		} else {
			print(String.localizedStringWithFormat("%5d PC %04x\n", core!.tStates, address))
			core!.tStates += 3
		}
		
		return Byte(address >> 8)
	}
	
	func ioWriteAddress(address: Word, value: Byte) {
		
		if address & 0xc000 == 0x4000 {
			print(String.localizedStringWithFormat("%5d PC %04x", core!.tStates, address))
		}
		core!.tStates += 1
		
		print(String.localizedStringWithFormat("%5d PW %04x %02x", core!.tStates, address, address >> 8))
		
		if address & 0x0001 != 0 {
			
			if address & 0xc000 == 0x4000 {
				print(String.localizedStringWithFormat("%5d PC %04x", core!.tStates, address))
				core!.tStates += 1
				print(String.localizedStringWithFormat("%5d PC %04x", core!.tStates, address))
				core!.tStates += 1
				print(String.localizedStringWithFormat("%5d PC %04x", core!.tStates, address))
				core!.tStates += 1
			} else {
				core!.tStates += 3
			}
			
		} else {
			print(String.localizedStringWithFormat("%5d PC %04x", core!.tStates, address))
			core!.tStates += 3
		}
	}
	
	func contentionReadNoMREQAddress(address: Word, tStates: Int) {
		print(String.localizedStringWithFormat("%5d MC %04x", core!.tStates, address))
	}
	
	func contentionWriteNoMREQAddress(address: Word, tStates: Int) {
		print(String.localizedStringWithFormat("%5d MC %04x", core!.tStates, address))
	}
	
	func contentionReadAddress(address: Word, tStates: Int) {
		print(String.localizedStringWithFormat("%5d MC %04x", core!.tStates, address))
	}
	
	//MARK: Core test functions
	
	func reset() {
		core!.reset()
	}
	
	func runTests() {
		
		let path = NSBundle.mainBundle().pathForResource("tests", ofType: "in")
		let handle = NSFileHandle.init(forReadingAtPath: path!)
		
		scanner = StreamScanner(source: handle!, delimiters: NSCharacterSet(charactersInString: " \n"))

		while runTest() {
			
		}
		
	}
	
	func runTest() -> (Bool) {
	
		core!.reset()
		
		// Reset memory
		for i in 0.stride(to: 0xffff, by: 4) {
			memory[i + 0] = 0xde
			memory[i + 1] = 0xad
			memory[i + 2] = 0xbe
			memory[i + 3] = 0xef
		}
		
		let test = readTest()
		var end_tstates = test.tStates
		if test.available == false {
			return false
		}
		
		// Take a copy of memory
		initialMemory = memory
		
		while end_tstates > 0 {
			let tStatesBefore = Int(core!.tStates)
			core!.execute()
			end_tstates -= core!.tStates - tStatesBefore
		}
		
		dumpZ80()
		dumpMemory()
		print("")

		return true
		
	}
	
	func readTest() -> (available: Bool, tStates: Int) {
		
		if !scanner!.ready() {
			return (false, 0)
		}
		
		let testName: String = scanner!.read()!

		let af: String = scanner!.read()!
		core!.AF = Word(Int(strtoul(af, nil, 16)))
		let bc: String = scanner!.read()!
		core!.BC = Word(Int(strtoul(bc, nil, 16)))
		let de: String = scanner!.read()!
		core!.DE = Word(Int(strtoul(de, nil, 16)))
		let hl: String = scanner!.read()!
		core!.HL = Word(Int(strtoul(hl, nil, 16)))
		
		let af_: String = scanner!.read()!
		core!.AF_ = Word(Int(strtoul(af_, nil, 16)))
		let bc_: String = scanner!.read()!
		core!.BC_ = Word(Int(strtoul(bc_, nil, 16)))
		let de_: String = scanner!.read()!
		core!.DE_ = Word(Int(strtoul(de_, nil, 16)))
		let hl_: String = scanner!.read()!
		core!.HL_ = Word(Int(strtoul(hl_, nil, 16)))
		
		let ix: String = scanner!.read()!
		core!.IX = Word(Int(strtoul(ix, nil, 16)))
		let iy: String = scanner!.read()!
		core!.IY = Word(Int(strtoul(iy, nil, 16)))
		let sp: String = scanner!.read()!
		core!.SP = Word(Int(strtoul(sp, nil, 16)))
		let pc: String = scanner!.read()!
		core!.PC = Word(Int(strtoul(pc, nil, 16)))

		let i: String = scanner!.read()!
		core!.I = Byte(Int(strtoul(i, nil, 16)))
		let r: String = scanner!.read()!
		core!.R = Byte(Int(strtoul(r, nil, 16)))
		let iff1: String = scanner!.read()!
		core!.IFF1 = Byte(Int(strtoul(iff1, nil, 16)))
		let iff2: String = scanner!.read()!
		core!.IFF2 = Byte(Int(strtoul(iff2, nil, 16)))
		let im: String = scanner!.read()!
		core!.IM = Byte(Int(strtoul(im, nil, 16)))
		let halted: String = scanner!.read()!
		core!.halted = Byte(Int(strtoul(halted, nil, 16)))

		let tstates: String = scanner!.read()!
		let end_tstates = Int(tstates)!
		
		while true {
			
			let addr: String = scanner!.read()!
			if addr == "-1" {
				break
			}

			let readAddress: Int = Int(strtoul(addr, nil, 16))
			

			var address = Word(readAddress)
			
			while true {
			
				let b: String = scanner!.read()!
				if b == "-1" {
					break
				}
				let readByte: Int = Int(strtoul(b, nil, 16))
				let byte = Byte(readByte)
				memory[address] = byte
				address += 1
				
			}
		}

		print("\(testName)")
		
		return (true, end_tstates)
		
	}
	
	func dumpZ80() {
		print(String.localizedStringWithFormat("%04x %04x %04x %04x %04x %04x %04x %04x %04x %04x %04x %04x",core!.AF, core!.BC, core!.DE, core!.HL, core!.AF_, core!.BC_, core!.DE_, core!.HL_, core!.IX, core!.IY, core!.SP, core!.PC))
		print(String.localizedStringWithFormat("%02x %02x %d %d %d %d %d",core!.I, core!.R, core!.IFF1, core!.IFF2, core!.IM, core!.halted, core!.tStates))
	}
	
	func dumpMemory() {
		
		for var i in 0 ..< 0x10000 {
			
			var output = ""
			
			if memory[i] == initialMemory[i] {
				continue
			}
			
			output = output.stringByAppendingFormat("%04x ", UInt(i))
			
			while i < 0x10000 && memory[i] != initialMemory[i] {
				output = output.stringByAppendingFormat("%02x ", memory[i])
				i += 1
			}
			
			output = output.stringByAppendingString("-1")
			print(output)
			
		}
		
		
	}
	
}