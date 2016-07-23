//
//  SwiftZ80.swift
//  SwiftZ80
//
//  Created by Mike Daley on 21/07/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

import Foundation

typealias Byte = UInt8
typealias Word = UInt16

/**
* Z80 flags
*/
enum Z80Flags: Byte {
	case F_C	= 1		// Carry
	case F_N	= 2		// Sub / Add
	case F_PV	= 4		// Parity / Overflow
	case F_3	= 8		// Reserved
	case F_H	= 16	// Half Carry
	case F_5	= 32	// Reserved
	case F_Z	= 64	// Zero
	case F_S	= 128	// Signs
}

/**
* Z80 execution context
* A struct that contains all of the properties necessary to emulate a Z80 CPU. This context manages the main and shadow
* registers, program counter as well as memory read, write and contention methods. The memory read and write methods are
* responsbile for reading from and writing to the memory structure being used e.g. an Array while the ioRead and ioWrite 
* functions are responsible for dealing with reading from and writing to output ports. The contention methods are responsible
* for incrementing the tStates of the CPU based on if the memory or IO read and writes are being performed on memory locations
* between 16384 and 32767 and while the display beam is drawing the main screen of the display.
*/
struct Z80Context {
	
	var R1: Z80Registers
	var R2: Z80Registers
	var PC: Word
	var R: Byte
	var I: Byte
	var IFF1: Byte
	var IFF2: Byte
	var IM: Byte
	var IR: Word {
		get {
			return ((Word(I) << 8) | (Word(R & 0x80)) | (Word(R & 0x7f)))
		}
	}
	
	var memoryRead: (address: Word) -> (Byte)
	var memoryWrite: (address: Word, value: Byte) -> ()
	
	var ioRead: (address: Word) -> (Byte)
	var ioWrite: (address: Word, value: Byte) -> ()

	var contentionReadNoMReq: (address: Word, tStates: Int) -> ()
	var contentionWriteNoMReq: (address: Word, tStates: Int) -> ()
	var contentionRead: (address: Word, tStates: Int) -> ()
	
	var halted: Bool
	var tStates: Int
	
}

class SwiftZ80
{

	var context: Z80Context
	
	init(memoryRead: (Word) -> (Byte), memoryWrite: (Word, Byte) -> (), ioRead: (Word) -> (Byte),
	     ioWrite: (Word, Byte) -> (), contentionReadNoMReq: (Word, Int) -> (), contentionWriteNoMReq: (Word, Int) -> (),
	     contentionRead: (Word, Int) -> ()) {

		context = Z80Context(R1: Z80Registers(),
		                     R2: Z80Registers(),
		                     PC: 0x0000,
		                     R: 0x00,
		                     I: 0x00,
		                     IFF1: 0x00,
		                     IFF2: 0x00,
		                     IM: 0x00,
		                     memoryRead: memoryRead,
		                     memoryWrite: memoryWrite,
		                     ioRead: ioRead,
		                     ioWrite: ioWrite,
		                     contentionReadNoMReq: contentionReadNoMReq,
		                     contentionWriteNoMReq: contentionWriteNoMReq,
		                     contentionRead: contentionRead,
		                     halted: false,
		                     tStates: 0x00)
		
	}
	
	final func execute() {
		
		let opcode: Byte = context.memoryRead(address: context.PC)
		executeOpCode(opcode)
	}
	
	final func executeOpCode(opcode: Byte) {
		
		switch opcode {
		case 0x00:				// NOP
			break
		
		case 0x01:				// LD BC, nnnn
			context.R1.C = context.memoryRead(address: context.PC)
			context.PC += 1
			context.R1.B = context.memoryRead(address: context.PC)
			context.PC += 1
			break
			
		case 0x02:				// LD (BC), A
			context.memoryWrite(address: context.R1.BC, value: context.R1.A)
			break
			
		case 0x03:
			context.contentionReadNoMReq(address: context.IR, tStates: 1)
			context.contentionReadNoMReq(address: context.IR, tStates: 1)
			context.R1.BC += 1;
			break
		
		default:
			break
		
		}
	}
	
}