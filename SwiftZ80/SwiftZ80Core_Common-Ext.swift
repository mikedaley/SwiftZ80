//
//  SwiftZ80Core_Common-Ext.swift
//  SwiftZ80
//
//  Created by Mike Daley on 04/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

/**
* This extension provides the functions used within many of the opcode implementations for actions such as
* ADD, SUB, CP, SLA, SRA, ADC, SBC etc.
*/
extension SwiftZ80Core {
	
	/**
	* ADD - The integer byte value is added to the contents of the accumulator replacing the accumulators contents with
	* the new value
	*/
	mutating func ADD(value: Byte) {
		
		let result: Int = Int(A) + Int(value)
		let lookup: Byte = ((A & 0x88) >> 3) | ((value & 0x88) >> 2) | ((Byte(result & 0xff) & 0x88) >> 1)
		
		A = Byte(result & 0xff)
		
		var carry: Byte = F_C
		if result & 0x100 == 0x00 {
			carry = 0x00
		}
		
		var sign: Byte = F_S
		if A & 0x80 == 0x00 {
			sign = 0x00
		}
		
		var zero: Byte = F_Z
		if A != 0 {
			zero = 0x00
		}

		F = zero | sign | carry | halfcarry_add_table[lookup & 0x07] | overflow_add_table[lookup >> 4]
		
	}

	/**
	* ADD16 - The integer word value is added to the contents of the accumulator replacing the accumulators contents with
	* the new value
	*/
	mutating func ADD16(value1: Word, value2: Word) {
		
		let result: Int = Int(value1) + Int(value2)
		let lookup: Byte = (Byte(value1 & 0xff) & 0x0800) >> 11 | (Byte(value2 & 0xff) & 0x0800) >> 10 | (Byte(result & 0xff) & 0x0800) >> 9
		
		A = Byte(result & 0xff)
		
		var carry: Byte = F_C
		if result & 0x100 == 0x00 {
			carry = 0x00
		}
		
		var sign: Byte = F_S
		if A & 0x80 == 0x00 {
			sign = 0x00
		}
		
		var zero: Byte = F_Z
		if A != 0 {
			zero = 0x00
		}
		
		F = zero | sign | carry | halfcarry_add_table[lookup & 0x07] | overflow_add_table[lookup >> 4]
		
	}
	
	/**
	* SUB - The integer in byte is subtracted from the contents of the accumulator replacing the accumulators contents with
	* the new value
	*/
	mutating func SUB(value: Byte) {
		
		// Use Int for the result as it needs to handle negative numbers. Word and Byte are unsigned so cannot
		// be used
		let result: Int = Int(A) - Int(value)
		let lookup = ((A & 0x88) >> 3) | ((value & 0x88) >> 2) | ((Byte(result & 0xff) & 0x88) >> 1)
		
		A = Byte(result & 0xff)
		
		var carry = F_C
		if result & 0x100 == 0x00 {
			carry = 0x00
		}
		
		var sign: Byte = F_S
		if A & 0x80 == 0x00 {
			sign = 0x00
		}
		
		var zero: Byte = F_Z
		if A != 0 {
			zero = 0x00
		}
		
		F = zero | sign | carry | F_N | halfcarry_sub_table[lookup & 0x07] | overflow_sub_table[lookup >> 4]
		
	}
	
	mutating func ADC(value: Byte) {
		
		var result: Int = 0
		
		ResetFlag(F_N)
		ValFlag(F_H, value: (((A & 0x0f) + (value & 0x0f)) & 0x10))
		
		result = Int(A) + Int(value)
		
		if getFlag(F_C) != 0 {
			result += 1
		}
		
		ValFlag(F_S, value: (Byte(result & 0x80)))
		
		if result & 0x100 == 0 {
			ResetFlag(F_C)
		} else {
			SetFlag(F_C)
		}
		
		if result & 0xff > 0 {
			ResetFlag(F_Z)
		} else {
			SetFlag(F_Z)
		}
		
		A = Byte(result & 0xff)
	}
	
	mutating func DAA() {
		
		var add: Byte = 0
		var carry: Byte = getFlag(F_C)
		
		if (getFlag(F_C) != 0x00 || A & 0x0f > 9) {
			add = 0x06
		}
		
		if (carry != 0x00 || A > 0x99) {
			add |= 0x60
		}
		
		if (A > 0x99) {
			carry = F_C
		}
		
		// Sub if N flag is set
		if (F & F_N != 0x00) {
			SUB(add)
		} else {
			ADD(add)
		}
		
		F = (F & ~(F_C | F_P)) | carry | parity_table[A]
		
	}
	

}
