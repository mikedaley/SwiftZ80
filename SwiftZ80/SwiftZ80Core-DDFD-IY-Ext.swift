//
//  Opcodes_DDFD.swift
//  SwiftZ80
//
//  Created by Mike Daley on 02/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

extension SwiftZ80Core {
	
	func lookupDDFDIYOpcode(opcode: Byte) {
        
        switch opcode {

		case 0x09:		/* ADD IY,BC */
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			ADD16(&IY, value2: BC)
			break
		case 0x19:		/* ADD IY,DE */
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			ADD16(&IY,value2: DE)
			break
		case 0x21:		/* LD IY,nnnn */
			IYl = coreMemoryRead(PC, tStates: 3)
			PC = PC &+ 1
			IYh = coreMemoryRead(PC, tStates: 3)
			PC = PC &+ 1
			break
		case 0x22:		/* LD (nnnn),IY */
			LD16_NNRR(IYl,regH: IYh)
			break
		case 0x23:		/* INC IY */
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			IY += 1
			break
		case 0x24:		/* INC IYh */
			INC(&IYh)
			break
		case 0x25:		/* DEC IYh */
			DEC(&IYh)
			break
		case 0x26:		/* LD IYh,nn */
			IYh = coreMemoryRead(PC, tStates: 3)
			PC = PC &+ 1
			break
		case 0x29:		/* ADD IY,IY */
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			ADD16(&IY,value2: IY)
			break
		case 0x2a:		/* LD IY,(nnnn) */
			LD16_RRNN(&IYl,regH: &IYh)
			break
		case 0x2b:		/* DEC IY */
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			IY = IY &- 1
			break
		case 0x2c:		/* INC IYl */
			INC(&IYl)
			break
		case 0x2d:		/* DEC IYl */
			DEC(&IYl)
			break
		case 0x2e:		/* LD IYl,nn */
			IYl = coreMemoryRead(PC, tStates: 3)
			PC = PC &+ 1
			break
		case 0x34:		/* INC (IY+dd) */
			var offset: Int8
			var byteTemp: Byte
			var wordTemp: Word
			
			offset = Int8(bitPattern: coreMemoryRead(PC, tStates: 3))
			
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			
			wordTemp = Word(signedAddress)
			
			byteTemp = coreMemoryRead(wordTemp, tStates: 3)
			
			coreMemoryContention(wordTemp, tStates:1)
			
			INC(&byteTemp)
			
			coreMemoryWrite(wordTemp, value: byteTemp)
			break
		case 0x35:		/* DEC (IY+dd) */
			var offset: Int8
			var byteTemp: Byte
			var wordTemp: Word
			
			offset = Int8(bitPattern: coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			
			wordTemp = Word(signedAddress)
			
			byteTemp = coreMemoryRead(wordTemp, tStates: 3)
			coreMemoryContention(wordTemp, tStates:1)
			DEC(&byteTemp)
			coreMemoryWrite(wordTemp,value: byteTemp)
			break
		case 0x36:		/* LD (IY+dd),nn */
			var offset: Int8
			var value: Byte
			offset = Int8(bitPattern: coreMemoryRead(PC, tStates: 3))
			PC = PC &+ 1
			value = coreMemoryRead(PC, tStates: 3)
			coreMemoryContention(PC, tStates: 1)
			coreMemoryContention(PC, tStates: 1)
			PC = PC &+ 1
			
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			
			coreMemoryWrite(Word(signedAddress), value: value)
			break
		case 0x39:		/* ADD IY,SP */
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			coreMemoryContention(IR, tStates:1)
			ADD16(&IY,value2: SP)
			break
		case 0x44:		/* LD B,IYh */
			B = IYh
			break
		case 0x45:		/* LD B,IYl */
			B = IYl
			break
		case 0x46:		/* LD B,(IY+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			B = coreMemoryRead(Word(signedAddress) & 0xffff, tStates: 3)
			break
		case 0x4c:		/* LD C,IYh */
			C = IYh
			break
		case 0x4d:		/* LD C,IYl */
			C = IYl
			break
		case 0x4e:		/* LD C,(IY+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			C = coreMemoryRead(Word(signedAddress), tStates: 3)
			break
		case 0x54:		/* LD D,IYh */
			D = IYh
			break
		case 0x55:		/* LD D,IYl */
			D = IYl
			break
		case 0x56:		/* LD D,(IY+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			D = coreMemoryRead(Word(signedAddress), tStates: 3)
			break
		case 0x5c:		/* LD E,IYh */
			E = IYh
			break
		case 0x5d:		/* LD E,IYl */
			E = IYl
			break
		case 0x5e:		/* LD E,(IY+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			E = coreMemoryRead(Word(signedAddress), tStates: 3)
			break
		case 0x60:		/* LD IYh,B */
			IYh = B
			break
		case 0x61:		/* LD IYh,C */
			IYh = C
			break
		case 0x62:		/* LD IYh,D */
			IYh = D
			break
		case 0x63:		/* LD IYh,E */
			IYh = E
			break
		case 0x64:		/* LD IYh,IYh */
			break
		case 0x65:		/* LD IYh,IYl */
			IYh = IYl
			break
		case 0x66:		/* LD H,(IY+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			H = coreMemoryRead(Word(signedAddress), tStates: 3)
			break
		case 0x67:		/* LD IYh,A */
			IYh = A
			break
		case 0x68:		/* LD IYl,B */
			IYl = B
			break
		case 0x69:		/* LD IYl,C */
			IYl = C
			break
		case 0x6a:		/* LD IYl,D */
			IYl = D
			break
		case 0x6b:		/* LD IYl,E */
			IYl = E
			break
		case 0x6c:		/* LD IYl,IYh */
			IYl = IYh
			break
		case 0x6d:		/* LD IYl,IYl */
			break
		case 0x6e:		/* LD L,(IY+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			L = coreMemoryRead(Word(signedAddress), tStates: 3)
			break
		case 0x6f:		/* LD IYl,A */
			IYl = A
			break
		case 0x70:		/* LD (IY+dd),B */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			coreMemoryWrite(Word(signedAddress), value: B)
			break
		case 0x71:		/* LD (IY+dd),C */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			coreMemoryWrite(Word(signedAddress), value: C)
			break
		case 0x72:		/* LD (IY+dd),D */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			coreMemoryWrite(Word(signedAddress), value: D)
			break
		case 0x73:		/* LD (IY+dd),E */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			coreMemoryWrite(Word(signedAddress), value: E)
			break
		case 0x74:		/* LD (IY+dd),H */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			coreMemoryWrite(Word(signedAddress), value: H)
			break
		case 0x75:		/* LD (IY+dd),L */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			coreMemoryWrite(Word(signedAddress), value: L)
			break
		case 0x77:		/* LD (IY+dd),A */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			coreMemoryWrite(Word(signedAddress), value: A)
			break
		case 0x7c:		/* LD A,IYh */
			A = IYh
			break
		case 0x7d:		/* LD A,IYl */
			A = IYl
			break
		case 0x7e:		/* LD A,(IY+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			A = coreMemoryRead(Word(signedAddress), tStates: 3)
			break
		case 0x84:		/* ADD A,IYh */
			ADD(IYh)
			break
		case 0x85:		/* ADD A,IYl */
			ADD(IYl)
			break
		case 0x86:		/* ADD A,(IY+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			let byteTemp = coreMemoryRead(Word(signedAddress), tStates: 3)
			ADD(byteTemp)
			break
		case 0x8c:		/* ADC A,IYh */
			ADC(IYh)
			break
		case 0x8d:		/* ADC A,IYl */
			ADC(IYl)
			break
		case 0x8e:		/* ADC A,(IY+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			let byteTemp = coreMemoryRead(Word(signedAddress), tStates: 3)
			ADC(byteTemp)
			break
		case 0x94:		/* SUB A,IYh */
			SUB(IYh)
			break
		case 0x95:		/* SUB A,IYl */
			SUB(IYl)
			break
		case 0x96:		/* SUB A,(IY+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			let byteTemp = coreMemoryRead(Word(signedAddress), tStates: 3)
			SUB(byteTemp)
			break
		case 0x9c:		/* SBC A,IYh */
			SBC(IYh)
			break
		case 0x9d:		/* SBC A,IYl */
			SBC(IYl)
			break
		case 0x9e:		/* SBC A,(IY+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			let byteTemp = coreMemoryRead(Word(signedAddress), tStates: 3)
			SBC(byteTemp)
			break
		case 0xa4:		/* AND A,IYh */
			AND(IYh)
			break
		case 0xa5:		/* AND A,IYl */
			AND(IYl)
			break
		case 0xa6:		/* AND A,(IY+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			let byteTemp = coreMemoryRead(Word(signedAddress), tStates: 3)
			AND(byteTemp)
			break
		case 0xac:		/* XOR A,IYh */
			XOR(IYh)
			break
		case 0xad:		/* XOR A,IYl */
			XOR(IYl)
			break
		case 0xae:		/* XOR A,(IY+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			let byteTemp = coreMemoryRead(Word(signedAddress), tStates: 3)
			XOR(byteTemp)
			break
		case 0xb4:		/* OR A,IYh */
			OR(IYh)
			break
		case 0xb5:		/* OR A,IYl */
			OR(IYl)
			break
		case 0xb6:		/* OR A,(IY+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			let byteTemp = coreMemoryRead(Word(signedAddress), tStates: 3)
			OR(byteTemp)
			break
		case 0xbc:		/* CP A,IYh */
			CP(IYh)
			break
		case 0xbd:		/* CP A,IYl */
			CP(IYl)
			break
		case 0xbe:		/* CP A,(IY+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIY = Int(IY)
			let signedAddress: Int = Int(signedIY) + Int(offset)
			let byteTemp = coreMemoryRead(Word(signedAddress), tStates: 3)
			CP(byteTemp)
			break
		case 0xcb:		/* shift DDFDCB */
			var opcode3: Byte
			let offset = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			let signedIY = Int(IY)
			let tempAddr = Word(Int(signedIY) + Int(offset))
			PC = PC &+ 1
			opcode3 = coreMemoryRead(PC, tStates: 3)
			coreMemoryContention(PC, tStates: 1)
			coreMemoryContention(PC, tStates: 1)
			PC = PC &+ 1
			lookupDDFDCBOpcode(opcode3, address: tempAddr)
			break
		case 0xe1:		/* POP IY */
			POP16(&IYl,regH: &IYh)
			break
		case 0xe3:		/* EX (SP),IY */
			var byteTempL: Byte
			var byteTempH: Byte
			byteTempL = coreMemoryRead(SP, tStates: 3)
			byteTempH = coreMemoryRead(SP + 1, tStates: 3)
			coreMemoryContention(SP + 1, tStates: 1)
			coreMemoryWrite(SP + 1, value: IYh)
			coreMemoryWrite(SP, value: IYl)
			coreMemoryContention(SP, tStates: 1)
			coreMemoryContention(SP, tStates: 1)
			IYl = byteTempL
			IYh = byteTempH
			break
		case 0xe5:		/* PUSH IY */
			coreMemoryContention(IR, tStates: 1)
			PUSH16(IYl,regH: IYh)
			break
		case 0xe9:		/* JP IY */
			PC=IY		/* NB: NOT INDIRECT! */
			break
		case 0xf9:		/* LD SP,IY */
			coreMemoryContention(IR, tStates: 1)
			coreMemoryContention(IR, tStates: 1)
			SP = IY
			break
		default:		/* Instruction did not involve H or L, so backtrack
			one instruction and parse again */
//			            PC = PC &- 1
//			            R -= 1
//			            let opcode2: Byte = opcode
//			            lookupBaseOpcode(opcode2)
			//            #ifdef HAVE_ENOUGH_MEMORY
			//            goto end_opcode
			//            #else			/* #ifdef HAVE_ENOUGH_MEMORY */
			//            return 1
			//            #endif			/* #ifdef HAVE_ENOUGH_MEMORY */
			print("DDFDIY \(opcode)")

			break
		}
		
	}
	
}
