//
//  OpcodesBase.swift
//  SwiftZ80
//
//  Created by Mike Daley on 02/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

extension SwiftZ80Core {

	mutating func lookupBaseOpcode(opcode: Byte) {
		
		switch opcode {
			
			case 0x00:				// NOP
				break
				
			case 0x01:				// LD BC, nnnn
				C = memoryReadAddress(PC)
				PC += 1
				B = memoryReadAddress(PC)
				PC += 1
				break
				
			case 0x02:				// LD (BC), A
				memoryWriteAddress(BC, value: A)
				break
				
			case 0x03:              // INC BC
				contend_read_no_mreq(IR, tStates: 1)
				contend_read_no_mreq(IR, tStates: 1)
				BC += 1
				break
				
			case 0x04:				// INC B
				B += 1
				F = (F & F_C) | (B == 0x80 ? F_P : 0)
				//		core.R1.F |= core.R1.B & 0x0f ? 0 : F_H
				break;
				
			case 0x05:				// DEC B
				B -= 1
				break;
				
			case 0x06:
				B = memoryReadAddress(PC)
				PC += 1
				break;
				
			case 0xce:
				let temp = memoryReadAddress(PC)
				ADC(temp)
				PC += 1
				break
				
			default:
				break
		}
	}
	
}

