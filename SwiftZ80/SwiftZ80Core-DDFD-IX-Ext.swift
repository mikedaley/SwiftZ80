//
//  Opcodes_DDFD.swift
//  SwiftZ80
//
//  Created by Mike Daley on 02/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

extension SwiftZ80Core {
    
    func lookupDDFDIXOpcode(opcode: Byte) {
        
        switch opcode {
            
        case 0x09:		/* ADD IX,BC */
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            ADD16(&IX, value2: BC)
            break
        case 0x19:		/* ADD IX,DE */
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            ADD16(&IX,value2: DE)
            break
        case 0x21:		/* LD IX,nnnn */
            IXl = coreMemoryRead(PC, tStates: 3)
            PC = PC &+ 1
            IXh = coreMemoryRead(PC, tStates: 3)
            PC = PC &+ 1
            break
        case 0x22:		/* LD (nnnn),IX */
            LD16_NNRR(IXl,regH: IXh)
            break
        case 0x23:		/* INC IX */
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            IX += 1
            break
        case 0x24:		/* INC IXh */
            INC(&IXh)
            break
        case 0x25:		/* DEC IXh */
            DEC(&IXh)
            break
        case 0x26:		/* LD IXh,nn */
            IXh = coreMemoryRead(PC, tStates: 3)
            PC = PC &+ 1
            break
        case 0x29:		/* ADD IX,IX */
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            ADD16(&IX,value2: IX)
            break
        case 0x2a:		/* LD IX,(nnnn) */
            LD16_RRNN(&IXl,regH: &IXh)
            break
        case 0x2b:		/* DEC IX */
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            IX = IX &- 1
            break
        case 0x2c:		/* INC IXl */
            INC(&IXl)
            break
        case 0x2d:		/* DEC IXl */
            DEC(&IXl)
            break
        case 0x2e:		/* LD IXl,nn */
            IXl = coreMemoryRead(PC, tStates: 3)
            PC = PC &+ 1
            break
        case 0x34:		/* INC (IX+dd) */
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
            
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)
            
            wordTemp = Word(signedAddress)
            
            byteTemp = coreMemoryRead(wordTemp, tStates: 3)
            
            coreMemoryContention(wordTemp, tStates:1)
            
            INC(&byteTemp)
            
            coreMemoryWrite(wordTemp, value: byteTemp)
            break
        case 0x35:		/* DEC (IX+dd) */
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
			
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)

            wordTemp = Word(signedAddress)
			
            byteTemp = coreMemoryRead(wordTemp, tStates: 3)
            coreMemoryContention(wordTemp, tStates:1)
            DEC(&byteTemp)
            coreMemoryWrite(wordTemp,value: byteTemp)
            break
        case 0x36:		/* LD (IX+dd),nn */
            var offset: Int8
            var value: Byte
			offset = Int8(bitPattern: coreMemoryRead(PC, tStates: 3))
            PC = PC &+ 1
            value = coreMemoryRead(PC, tStates: 3)
            coreMemoryContention(PC, tStates: 1)
            coreMemoryContention(PC, tStates: 1)
            PC = PC &+ 1
			
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)
			
            coreMemoryWrite(Word(signedAddress), value: value)
            break
        case 0x39:		/* ADD IX,SP */
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            coreMemoryContention(IR, tStates:1)
            ADD16(&IX,value2: SP)
            break
        case 0x44:		/* LD B,IXh */
            B = IXh
            break
        case 0x45:		/* LD B,IXl */
            B = IXl
            break
        case 0x46:		/* LD B,(IX+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            PC = PC &+ 1
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)
            B = coreMemoryRead(Word(signedAddress) & 0xffff, tStates: 3)
            break
        case 0x4c:		/* LD C,IXh */
            C = IXh
            break
        case 0x4d:		/* LD C,IXl */
            C = IXl
            break
        case 0x4e:		/* LD C,(IX+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            PC = PC &+ 1
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)
            C = coreMemoryRead(Word(signedAddress), tStates: 3)
            break
        case 0x54:		/* LD D,IXh */
            D = IXh
            break
        case 0x55:		/* LD D,IXl */
            D = IXl
            break
        case 0x56:		/* LD D,(IX+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            PC = PC &+ 1
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)
            D = coreMemoryRead(Word(signedAddress), tStates: 3)
            break
        case 0x5c:		/* LD E,IXh */
            E = IXh
            break
        case 0x5d:		/* LD E,IXl */
            E = IXl
            break
        case 0x5e:		/* LD E,(IX+dd) */
            let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            PC = PC &+ 1
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)
            E = coreMemoryRead(Word(signedAddress), tStates: 3)
            break
        case 0x60:		/* LD IXh,B */
            IXh = B
            break
        case 0x61:		/* LD IXh,C */
            IXh = C
            break
        case 0x62:		/* LD IXh,D */
            IXh = D
            break
        case 0x63:		/* LD IXh,E */
            IXh = E
            break
        case 0x64:		/* LD IXh,IXh */
            break
        case 0x65:		/* LD IXh,IXl */
            IXh = IXl
            break
        case 0x66:		/* LD H,(IX+dd) */
            let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            PC = PC &+ 1
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)
            H = coreMemoryRead(Word(signedAddress), tStates: 3)
            break
        case 0x67:		/* LD IXh,A */
            IXh = A
            break
        case 0x68:		/* LD IXl,B */
            IXl = B
            break
        case 0x69:		/* LD IXl,C */
            IXl = C
            break
        case 0x6a:		/* LD IXl,D */
            IXl = D
            break
        case 0x6b:		/* LD IXl,E */
            IXl = E
            break
        case 0x6c:		/* LD IXl,IXh */
            IXl = IXh
            break
        case 0x6d:		/* LD IXl,IXl */
            break
        case 0x6e:		/* LD L,(IX+dd) */
            let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            PC = PC &+ 1
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)
			L = coreMemoryRead(Word(signedAddress), tStates: 3)
            break
        case 0x6f:		/* LD IXl,A */
            IXl = A
            break
        case 0x70:		/* LD (IX+dd),B */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            coreMemoryContention(PC, tStates:1)
            PC = PC &+ 1
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)
            coreMemoryWrite(Word(signedAddress), value: B)
            break
        case 0x71:		/* LD (IX+dd),C */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)
			coreMemoryWrite(Word(signedAddress), value: C)
            break
        case 0x72:		/* LD (IX+dd),D */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)
			coreMemoryWrite(Word(signedAddress), value: D)
            break
        case 0x73:		/* LD (IX+dd),E */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)
			coreMemoryWrite(Word(signedAddress), value: E)
            break
        case 0x74:		/* LD (IX+dd),H */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)
			coreMemoryWrite(Word(signedAddress), value: H)
            break
        case 0x75:		/* LD (IX+dd),L */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)
			coreMemoryWrite(Word(signedAddress), value: L)
            break
        case 0x77:		/* LD (IX+dd),A */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)
			coreMemoryWrite(Word(signedAddress), value: A)
            break
        case 0x7c:		/* LD A,IXh */
            A = IXh
            break
        case 0x7d:		/* LD A,IXl */
            A = IXl
            break
        case 0x7e:		/* LD A,(IX+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)
			A = coreMemoryRead(Word(signedAddress), tStates: 3)
            break
        case 0x84:		/* ADD A,IXh */
            ADD(IXh)
            break
        case 0x85:		/* ADD A,IXl */
            ADD(IXl)
            break
        case 0x86:		/* ADD A,(IX+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)
			let byteTemp = coreMemoryRead(Word(signedAddress), tStates: 3)
            ADD(byteTemp)
            break
        case 0x8c:		/* ADC A,IXh */
            ADC(IXh)
            break
        case 0x8d:		/* ADC A,IXl */
            ADC(IXl)
            break
        case 0x8e:		/* ADC A,(IX+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)
			let byteTemp = coreMemoryRead(Word(signedAddress), tStates: 3)
            ADC(byteTemp)
            break
        case 0x94:		/* SUB A,IXh */
            SUB(IXh)
            break
        case 0x95:		/* SUB A,IXl */
            SUB(IXl)
            break
        case 0x96:		/* SUB A,(IX+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)
			let byteTemp = coreMemoryRead(Word(signedAddress), tStates: 3)
            SUB(byteTemp)
            break
        case 0x9c:		/* SBC A,IXh */
            SBC(IXh)
            break
        case 0x9d:		/* SBC A,IXl */
            SBC(IXl)
            break
        case 0x9e:		/* SBC A,(IX+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)
			let byteTemp = coreMemoryRead(Word(signedAddress), tStates: 3)
            SBC(byteTemp)
            break
        case 0xa4:		/* AND A,IXh */
            AND(IXh)
            break
        case 0xa5:		/* AND A,IXl */
            AND(IXl)
            break
        case 0xa6:		/* AND A,(IX+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)
			let byteTemp = coreMemoryRead(Word(signedAddress), tStates: 3)
            AND(byteTemp)
            break
        case 0xac:		/* XOR A,IXh */
            XOR(IXh)
            break
        case 0xad:		/* XOR A,IXl */
            XOR(IXl)
            break
        case 0xae:		/* XOR A,(IX+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)
			let byteTemp = coreMemoryRead(Word(signedAddress), tStates: 3)
            XOR(byteTemp)
            break
        case 0xb4:		/* OR A,IXh */
            OR(IXh)
            break
        case 0xb5:		/* OR A,IXl */
            OR(IXl)
            break
        case 0xb6:		/* OR A,(IX+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)
			let byteTemp = coreMemoryRead(Word(signedAddress), tStates: 3)
            OR(byteTemp)
            break
        case 0xbc:		/* CP A,IXh */
            CP(IXh)
            break
        case 0xbd:		/* CP A,IXl */
            CP(IXl)
            break
        case 0xbe:		/* CP A,(IX+dd) */
			let offset: Int8 = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			coreMemoryContention(PC, tStates:1)
			PC = PC &+ 1
			let signedIX = Int(IX)
			let signedAddress: Int = Int(signedIX) + Int(offset)
			let byteTemp = coreMemoryRead(Word(signedAddress), tStates: 3)
            CP(byteTemp)
            break
        case 0xcb:		/* shift DDFDCB */
            var opcode3: Byte
			let offset = Int8(bitPattern:coreMemoryRead(PC, tStates: 3))
			let signedIX = Int(IX)
			let tempAddr = Word(Int(signedIX) + Int(offset))
            PC = PC &+ 1
            opcode3 = coreMemoryRead(PC, tStates: 3)
            coreMemoryContention(PC, tStates: 1)
            coreMemoryContention(PC, tStates: 1)
            PC = PC &+ 1
            lookupDDFDCBOpcode(opcode3, address: tempAddr)
            break
        case 0xe1:		/* POP IX */
            POP16(&IXl,regH: &IXh)
            break
        case 0xe3:		/* EX (SP),IX */
            var byteTempL: Byte
            var byteTempH: Byte
            byteTempL = coreMemoryRead(SP, tStates: 3)
            byteTempH = coreMemoryRead(SP + 1, tStates: 3)
            coreMemoryContention(SP + 1, tStates: 1)
            coreMemoryWrite(SP + 1, value: IXh)
            coreMemoryWrite(SP, value: IXl)
            coreMemoryContention(SP, tStates: 1)
            coreMemoryContention(SP, tStates: 1)
            IXl = byteTempL
            IXh = byteTempH
            break
        case 0xe5:		/* PUSH IX */
            coreMemoryContention(IR, tStates: 1)
            PUSH16(IXl,regH: IXh)
            break
        case 0xe9:		/* JP IX */
            PC=IX		/* NB: NOT INDIRECT! */
            break
        case 0xf9:		/* LD SP,IX */
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            SP = IX
            break
        default:		/* Instruction did not involve H or L, so backtrack
             one instruction and parse again */
//                        PC = PC &- 1
//                        R -= 1
//                        let opcode2: Byte = opcode
//                        lookupBaseOpcode(opcode2)
            //            #ifdef HAVE_ENOUGH_MEMORY
            //            goto end_opcode
            //            #else			/* #ifdef HAVE_ENOUGH_MEMORY */
            //            return 1
            //            #endif			/* #ifdef HAVE_ENOUGH_MEMORY */
//			print("IX")
			print("ID \(opcode)")

            break
        }
        
    }
    
}
