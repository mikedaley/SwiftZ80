//
//  SwiftZ80.swift
//  SwiftZ80
//
//  Created by Mike Daley on 21/07/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

public typealias Byte = UInt8
public typealias Word = UInt16

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
* SwiftZ80Core
* Structure that defines the properties, functions and opcode implementations needed to emulate the Z80 CPU
*/
struct SwiftZ80Core
{

	// Z80 registers
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
	
	// General core properties
	var halted: Bool = false
	var tStates: Int = 0
	
	// Maps to functions that manage memory access
	var memoryReadAddress: (Word) -> (Byte)
	var memoryWriteAddress: (Word, value: Byte) -> ()
	
	// Map to functions that manage io access
	var ioReadAddress: (Word) -> (Byte)
	var ioWriteAddress: (Word, value: Byte) -> ()
	
	// Map to functions that manage any contention rules
	var contentionReadNoMREQAddress: (Word, tStates: Int) -> (Byte)
	var contentionWriteNoMREQAddress: (Word, tStates: Int, value: Byte) -> ()
	var contentionReadAddress: (Word, tStates: Int) -> (Byte)

	/**
	* Initializer
	* Takes references to the functions that the core is to use when accessing memory, io and contention.
	* This allows how memory is mapped and stored to be managed outside of the core making the core more
	* general purpose.
	*/
	init(memoryRead: (address: Word) -> (Byte),
	     memoryWrite: (address: Word, value: Byte) -> (),
	     ioRead: (address: Word) -> (Byte),
	     ioWrite: (address: Word, value: Byte) -> (),
	     contentionReadNoMREQ: (address: Word, tStates: Int) -> (Byte),
	     contentionWriteNoMREQ: (address: Word, tStates: Int, value: Byte) -> (),
	     contentionRead: (address: Word, tStates: Int) -> (Byte)) {
		
		R1 = Z80Registers()
		R2 = Z80Registers()
		PC = 0x00
		R = 0x00
		I = 0x00
		IFF1 = 0x00
		IFF2 = 0x00
		IM = 0x00
		halted = false
		tStates = 0
		self.memoryReadAddress = memoryRead
		self.memoryWriteAddress = memoryWrite
		self.ioReadAddress = ioRead
		self.ioWriteAddress = ioWrite
		self.contentionReadNoMREQAddress = contentionReadNoMREQ
		self.contentionWriteNoMREQAddress = contentionWriteNoMREQ
		self.contentionReadAddress = contentionRead
	}
	
    /**
     * Execute a single opcode based on the current PC
     */
    mutating func execute() {
		
		let opcode: Byte = memoryReadAddress(PC)
		executeOpCode(opcode)
	}
	
    /**
    * Executes the implementation of the opcode passed in
    */
	mutating func executeOpCode(opcode: Byte) {
		
		switch opcode {

		case 0x00:				// NOP
			break
		
		case 0x01:				// LD BC, nnnn
			R1.C = memoryReadAddress(PC)
			PC += 1
			R1.B = memoryReadAddress(PC)
			PC += 1
			break
			
		case 0x02:				// LD (BC), A
			memoryWriteAddress(R1.BC, value: R1.A)
			break
			
		case 0x03:              // INC BC
			contentionReadNoMREQAddress(IR, tStates: 1)
			contentionReadNoMREQAddress(IR, tStates: 1)
			R1.BC += 1;
			break
			
		case 0x04:				// INC B
			R1.B = R1.B &+ R1.B
			break;
			
		case 0x05:				// DEC B
			R1.B = R1.B &- R1.B
			break;
			
		case 0x06:
			R1.B = memoryReadAddress(PC)
			PC += 1
			break;
			
			
			
			default:
				break
		}
	}
	
}