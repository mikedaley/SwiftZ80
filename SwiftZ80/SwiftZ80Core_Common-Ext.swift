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
     * AND - AND the supplied value
     */
    mutating func AND(value: Byte) {
        A &= value
        F = FLAG_H | SZ35Table[A] | parityTable[A]
    }

    /**
     * ADC - The integer byte value is added to the contents of the accumulator including the value of the carry flag replacing the
     * accumulators contents with the new value
     */
    mutating func ADC(value: Byte) {
        
        let result: Int = Int(A) + Int(value) + Int(F & FLAG_C)
        let lookup: Byte = ((A & 0x88) >> 3) | ((value & 0x88) >> 2) | ((Byte(result & 0xff) & 0x88) >> 1)
        
        A = Byte(result & 0xff)
        
        var carry = FLAG_C
        if result & 0x100 == 0x00 {
            carry = 0x00
        }
        
        F = carry | halfcarryAddTable[lookup & 0x07] | overflowAddTable[lookup >> 4] | SZ35Table[A]
        
    }

    /**
     * ADC16
     */
    mutating func ADC16(value: Word) {

        let result: Int = Int(HL) + Int(value) + Int(F & FLAG_C)
        let r1: Byte = Byte((HL & 0x0800) >> 11) & 0xff
        let r2: Byte = Byte((value & 0x0800) >> 10) & 0xff
        let r3: Byte = Byte((Word(result & 0xffff) & 0x0800) >> 9) & 0xff
        let lookup: Byte = r1 | r2 | r3
        
        HL = Word(result & 0xffff)
        
        var carry = FLAG_C
        if result & 0x10000 == 0x00 {
            carry = 0x00
        }
        
        var zero = FLAG_Z
        if HL != 0x00 {
            zero = 0x00
        }
        
        F = carry | halfcarryAddTable[lookup & 0x07] | overflowAddTable[lookup >> 4] | zero
        
    }

    /**
	* ADD - The integer byte value is added to the contents of the accumulator replacing the accumulators contents with
	* the new value
	*/
	mutating func ADD(value: Byte) {
		
		let result: Int = Int(A) + Int(value)
        
        // Make a lookup for the flag tables using bit 3 from A, value and the result
		let lookup: Byte = ((A & 0x88) >> 3) | ((value & 0x88) >> 2) | ((Byte(result & 0xff) & 0x88) >> 1)
		
		A = Byte(result & 0xff)
		
		var carry: Byte = FLAG_C
		if result & 0x100 == 0x00 {
			carry = 0x00
		}
		
        F = carry | halfcarryAddTable[lookup & 0x07] | overflowAddTable[lookup >> 4] | SZ35Table[A]
		
	}

	/**
	* ADD16 - The integer word value is added to the contents of the accumulator replacing the accumulators contents with
	* the new value
	*/
	mutating func ADD16(inout value1: Word, value2: Word) {
		
		let result: Int = Int(value1) + Int(value2)
        
        let r1: Byte = Byte((value1 & 0x0800) >> 11) & 0xff
        let r2: Byte = Byte((value2 & 0x0800) >> 10) & 0xff
        let r3: Byte = Byte((Word(result & 0xffff) & 0x0800) >> 9) & 0xff
        let lookup: Byte = r1 | r2 | r3
        
		value1 = Word(result & 0xffff)
						
        var carry: Byte = FLAG_C
        if result & 0x10000 == 0x00 {
            carry = 0x00
        }
        
        let v = Byte(value1 >> 8) & 0xff
        
        let f1 = ( F & (FLAG_V | FLAG_Z | FLAG_S))
        let f2 = carry
        let f3 = v & (FLAG_3 | FLAG_5)
        let f4 = halfcarryAddTable[lookup]
        
        F = f1 | f2 | f3 | f4

	}
	
    /**
     * BIT - Sets the flags based on the supplied bit being set or not in the supplied value
     */
    mutating func BIT(bit: Byte, value: Byte) {
        
        F = (F & FLAG_C) | FLAG_H | (value & ( FLAG_3 | FLAG_5 ))
        
        if value & (0x01 << bit) == 0x00 {
            F |= FLAG_P | FLAG_Z
        }
        
        if bit == 7 && value & 0x80 != 0x00 {
            F |= FLAG_S
        }
        
    }
    
    /**
     * BIT_I - Sets the flags based on the supplied bit being set or not in the supplied value/address!!
     */
    mutating func BIT_I(bit: Byte, value: Byte, address: Word) {
        F = ( F & FLAG_C ) | FLAG_H | ( Byte(( address >> 8 ) & 0xff) & ( FLAG_3 | FLAG_5 ) )

        if value & (0x01 << bit) != 0x00 {
            F |= FLAG_P
        } else {
            F |= FLAG_Z
        }
        
        if bit == 7 && value & 0x80 != 0x00 {
            F |= FLAG_S
        }
    }

    /**
     * CALL
     */
    mutating func CALL() {
        let tempL = internalReadAddress(PC, tStates: 3)
        PC = PC + 1
        let tempH = internalReadAddress(PC, tStates: 3)
        contend_read_no_mreq(PC, tStates: 1)
        PC = PC + 1
		PUSH16(PCl, regH: PCh)
        PCl = tempL
        PCh = tempH
    }
    
    /**
     * CP
     */
    mutating func CP(value: Byte) {
        let result: Int = Int(A) - Int(value)
        let lookup: Byte = ((A & 0x88) >> 3) | ((value & 0x88) >> 2) | ((Byte(result & 0xff) & 0x88) >> 1)

        var carry: Byte = FLAG_C
        if result & 0x100 == 0x00 {
            carry = 0x00
        }
        
        var zero: Byte = FLAG_Z
        if result != 0x00 {
            zero = 0x00
        }

        F = carry | zero | FLAG_N | halfcarrySubTable[lookup & 0x07] | overflowSubTable[lookup >> 4] | (value & (FLAG_3 | FLAG_5)) | (Byte(result & 0xff) & FLAG_S)
    }
    
    /**
     * DEC - Decrement the contents of a register
     */
    mutating func DEC(inout value: Byte) {
        
        var halfCarry: Byte = FLAG_H
        
        if value & 0x0f != 0x00 {
            halfCarry = 0x00
        }
        
        F = ( F & FLAG_C ) | halfCarry | FLAG_N
        
        value = value &- 1
        
        var overflow: Byte = FLAG_V
        if value != 0x7f {
            overflow = 0x00
        }
        
        F |= overflow | SZ35Table[value]
    }
    
    /**
     * Z80_IN
     */
    mutating func Z80_IN(inout register: Byte, port: Word) {
        
        register = ioReadAddress(port)
        F = (F & FLAG_C) | SZ35Table[register] | parityTable[register]
        
    }
    
    /**
     * INC - Increment the contents of a register
     */
    mutating func INC(inout value: Byte) {
        
        value = value &+ 1
        
        var overflow: Byte = FLAG_V
        if value != 0x80 {
            overflow = 0x00
        }
        
        var halfcarry: Byte = FLAG_H
        if value & 0x0f != 0x00 {
            halfcarry = 0x00
        }
        
        F = (F & FLAG_C) | overflow | halfcarry | SZ35Table[value]
    }
    
    /**
     * LD16_NNRR
     */
    mutating func LD16_NNRR(regL: Byte, regH: Byte) {

        var temp: Word = Word(internalReadAddress(PC, tStates: 3)) & 0xffff
        PC = PC + 1
        temp |= (Word(internalReadAddress(PC, tStates: 3)) & 0xffff) << 8
        PC = PC + 1
        internalWriteAddress(temp, value: regL)
        temp = temp + 1
        internalWriteAddress(temp, value: regH)
    }

    /**
     * LD16_RRNN
     */
    mutating func LD16_RRNN(inout regL: Byte, inout regH: Byte) {
        
        var temp: Word = Word(internalReadAddress(PC, tStates: 3)) & 0xffff
        PC = PC + 1
        temp |= (Word(internalReadAddress(PC, tStates: 3)) & 0xffff) << 8
        PC = PC + 1
        regL = internalReadAddress(temp, tStates: 3)
        temp = temp + 1
        regH = internalReadAddress(temp, tStates: 3)
    }

    /**
     * JP
     */
    mutating func JP() {
        
        var temp: Word = PC
        PCl = internalReadAddress(temp, tStates: 3)
        temp = temp + 1
        PCh = internalReadAddress(temp, tStates: 3)
    }

    /**
     * JR
     */
    mutating func JR() {
        
        let temp: Int8 = Int8(bitPattern: internalReadAddress(PC, tStates: 3))
        contend_read_no_mreq(PC, tStates: 1)
        contend_read_no_mreq(PC, tStates: 1)
        contend_read_no_mreq(PC, tStates: 1)
        contend_read_no_mreq(PC, tStates: 1)
        contend_read_no_mreq(PC, tStates: 1)
        
        var signedPC = Int16(PC)
		
		// Added 1 to PC to cater for the memory read that has occured 
		signedPC += Int16(temp) + 1
        
		if signedPC >= 0 {
			PC = Word(signedPC)
		}
    }
    
    /**
     * OR
     */
    mutating func OR(value: Byte) {
        A |= value
        F |= SZ35Table[A] | parityTable[A]
    }
    
    /**
     * POP16
     */
    mutating func POP16(inout regL: Byte, inout regH: Byte) {
        regL = internalReadAddress(SP, tStates: 3)
		SP = SP &+ 1
        regH = internalReadAddress(SP, tStates: 3)
		SP = SP &+ 1
    }

    /**
     * PUSH 16
     */
    mutating func PUSH16(regL: Byte, regH: Byte) {
		SP = SP &- 1
        internalWriteAddress(SP, value: regH)
		SP = SP &- 1
        internalWriteAddress(SP, value: regL)
    }

    /**
     * RET
     */
    mutating func RET() {
        POP16(&PCl, regH: &PCh)
    }
    
    /**
     * RL
     */
    mutating func RL(inout value: Byte) {
        let temp: Byte = value
        value = (value << 1) | (F & FLAG_C)
        F = (temp >> 7) | SZ35Table[value] | parityTable[value]
    }

    /**
     * RLC
     */
    mutating func RLC(inout value: Byte) {
        value = (value << 1) | (value >> 7)
        F = (value & FLAG_C) | SZ35Table[value] | parityTable[value]
    }
    
    /**
     * RR
     */
    mutating func RR(inout value: Byte) {
        let temp: Byte = value
        value = (value >> 1) | (F << 7)
        F = (temp & FLAG_C) | SZ35Table[value] | parityTable[value]
    }
    
    /**
     * RRC
     */
    mutating func RRC(inout value: Byte) {
        F = value & FLAG_C
        value = value >> 1 | value << 7
        F |= SZ35Table[value] | parityTable[value]
    }
    
    /**
     * RST
     */
    mutating func RST(value: Word) {
        PUSH16(PCl, regH: PCh)
        PC = value
    }
    
    /**
     * SBC
     */
    mutating func SBC(value: Byte) {
        let result: Int = Int(A) - Int(value) - Int(F & FLAG_C)
        let lookup: Byte = ((A & 0x88) >> 3) | ((value & 0x88) >> 2) | ((Byte(result & 0xff) & 0x88) >> 1)
        A = Byte(result & 0xff)

        var carry = FLAG_C
        if result & 0x100 == 0x00 {
            carry = 0x00
        }
        
        F = carry | FLAG_N | halfcarrySubTable[lookup & 0x07] | overflowSubTable[lookup >> 4] | SZ35Table[A]

    }

    /**
     * SBC16
     */
    mutating func SBC16(value: Word) {
   
        let result: Int = Int(HL) - Int(value) - Int(F & FLAG_C)
        
        let r1 = Byte((HL & 0x0800) >> 11) & 0xff
        let r2 = Byte((value & 0x0800) >> 10) & 0xff
        let r3 = Byte((Word(result & 0xffff) & 0x0800) >> 9) & 0xff
        let lookup: Byte = r1 | r2 | r3
        
        HL = Word(result & 0xffff)

        var carry: Byte = FLAG_C
        if result & 0x10000 == 0x00 {
            carry = 0x00
        }
        
        var zero: Byte = FLAG_Z
        if HL != 0x00 {
            zero = 0x00
        }
        
        F = carry | FLAG_N | halfcarrySubTable[lookup & 0x07] | overflowSubTable[lookup >> 4] | (H & (FLAG_3 | FLAG_5 | FLAG_S)) | zero
    }

    /**
     * SLA
     */
    mutating func SLA(inout value: Byte) {
        F = value >> 7
        value <<= 1
        F |= SZ35Table[value] | parityTable[value]
    }
    
    /**
     * SLL
     */
    mutating func SLL(inout value: Byte) {
        F = value >> 7
        value = (value << 1) | 0x01
        F |= SZ35Table[value] | parityTable[value]
    }
    
    /**
     * SRA
     */
    mutating func SRA(inout value: Byte) {
        F = value & FLAG_C
        value = (value & 0x80) | value >> 1
        F |= SZ35Table[value] | parityTable[value]
    }
    
    /**
     * SRL
     */
    mutating func SRL(inout value: Byte) {
        F = value & FLAG_C
        value >>= 1
        F |= SZ35Table[value] | parityTable[value]
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
		
		var carry = FLAG_C
		if result & 0x100 == 0x00 {
			carry = 0x00
		}
		
		F = carry | FLAG_N | halfcarrySubTable[lookup & 0x07] | overflowSubTable[lookup >> 4] | SZ35Table[A]
		
	}
	
    /**
     * XOR
     */
    mutating func XOR(value: Byte) {
        A ^= value
        F = SZ35Table[A] | parityTable[A]
    }
    

}
