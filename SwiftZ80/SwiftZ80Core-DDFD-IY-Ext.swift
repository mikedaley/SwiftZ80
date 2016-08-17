//
//  Opcodes_DDFD.swift
//  SwiftZ80
//
//  Created by Mike Daley on 02/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

extension SwiftZ80Core {
	
	mutating func lookupDDFDIYOpcode(opcode: Byte) {
        
        switch opcode {

        case 0x09:		/* ADD IY,BC */
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            ADD16(&IY, value2: BC)
            break
        case 0x19:		/* ADD IY,DE */
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            ADD16(&IY,value2: DE)
            break
        case 0x21:		/* LD IY,nnnn */
            IYl = internalReadAddress(PC, tStates: 3)
            PC += 1
            IYh = internalReadAddress(PC, tStates: 3)
            PC += 1
            break
        case 0x22:		/* LD (nnnn),IY */
            LD16_NNRR(IYl,regH: IYh)
            break
        case 0x23:		/* INC IY */
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            IY += 1
            break
        case 0x24:		/* INC IYh */
            INC(&IYh)
            break
        case 0x25:		/* DEC IYh */
            DEC(&IYh)
            break
        case 0x26:		/* LD IYh,nn */
            IYh = internalReadAddress(PC, tStates: 3)
            PC += 1
            break
        case 0x29:		/* ADD IY,IY */
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            ADD16(&IY,value2: IY)
            break
        case 0x2a:		/* LD IY,(nnnn) */
            LD16_RRNN(&IYl,regH: &IYh)
            break
        case 0x2b:		/* DEC IY */
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            IY = IY &- 1
            break
        case 0x2c:		/* INC IYl */
            INC(&IYl)
            break
        case 0x2d:		/* DEC IYl */
            DEC(&IYl)
            break
        case 0x2e:		/* LD IYl,nn */
            IYl = internalReadAddress(PC, tStates: 3)
            PC += 1
            break
        case 0x34:		/* INC (IY+dd) */
            var offset: Byte
            var byteTemp: Byte
            var wordTemp: Word

            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            wordTemp = IY + Word(offset) & 0xffff
            byteTemp = internalReadAddress(wordTemp, tStates: 3)
            contend_read_no_mreq(wordTemp, tStates:1)
            INC(&byteTemp)
            internalWriteAddress(wordTemp,value: byteTemp)
            break
        case 0x35:		/* DEC (IY+dd) */
            var offset: Byte
            var byteTemp: Byte
            var wordTemp: Word
            
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            wordTemp = IY + Word(offset) & 0xffff
            byteTemp = internalReadAddress(wordTemp, tStates: 3)
            contend_read_no_mreq(wordTemp, tStates:1)
            DEC(&byteTemp)
            internalWriteAddress(wordTemp,value: byteTemp)
            break
        case 0x36:		/* LD (IY+dd),nn */
            var offset: Byte
            var value: Byte
            offset = internalReadAddress(PC, tStates: 3)
            PC += 1
            value = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates: 1)
            contend_read_no_mreq(PC, tStates: 1)
            PC += 1
            internalWriteAddress(IY + Word(offset) & 0xffff, value: value)
            break
        case 0x39:		/* ADD IY,SP */
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            ADD16(&IY,value2: SP)
            break
        case 0x44:		/* LD B,IYh */
            B = IYh
            break
        case 0x45:		/* LD B,IYl */
            B = IYl
            break
        case 0x46:		/* LD B,(IY+dd) */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            B = internalReadAddress(IY + Word(offset) & 0xffff, tStates: 3)
            break
        case 0x4c:		/* LD C,IYh */
            C = IYh
            break
        case 0x4d:		/* LD C,IYl */
            C = IYl
            break
        case 0x4e:		/* LD C,(IY+dd) */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            C = internalReadAddress(IY + Word(offset) & 0xffff, tStates: 3)
            break
        case 0x54:		/* LD D,IYh */
            D = IYh
            break
        case 0x55:		/* LD D,IYl */
            D = IYl
            break
        case 0x56:		/* LD D,(IY+dd) */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            D = internalReadAddress(IY + Word(offset) & 0xffff, tStates: 3)
            break
        case 0x5c:		/* LD E,IYh */
            E = IYh
            break
        case 0x5d:		/* LD E,IYl */
            E = IYl
            break
        case 0x5e:		/* LD E,(IY+dd) */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            E = internalReadAddress(IY + Word(offset) & 0xffff, tStates: 3)
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
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            H = internalReadAddress(IY + Word(offset) & 0xffff, tStates: 3)
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
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            L = internalReadAddress(IY + Word(offset) & 0xffff, tStates: 3)
            break
        case 0x6f:		/* LD IYl,A */
            IYl = A
            break
        case 0x70:		/* LD (IY+dd),B */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            internalWriteAddress(IY + Word(offset) & 0xffff, value: B)
            break
        case 0x71:		/* LD (IY+dd),C */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            internalWriteAddress(IY + Word(offset) & 0xffff, value: C)
            break
        case 0x72:		/* LD (IY+dd),D */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            internalWriteAddress(IY + Word(offset) & 0xffff, value: D)
            break
        case 0x73:		/* LD (IY+dd),E */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            internalWriteAddress(IY + Word(offset) & 0xffff, value: E)
            break
        case 0x74:		/* LD (IY+dd),H */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            internalWriteAddress(IY + Word(offset) & 0xffff, value: H)
            break
        case 0x75:		/* LD (IY+dd),L */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            internalWriteAddress(IY + Word(offset) & 0xffff, value: L)
            break
        case 0x77:		/* LD (IY+dd),A */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            internalWriteAddress(IY + Word(offset) & 0xffff, value: A)
            break
        case 0x7c:		/* LD A,IYh */
            A = IYh
            break
        case 0x7d:		/* LD A,IYl */
            A = IYl
            break
        case 0x7e:		/* LD A,(IY+dd) */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            A = internalReadAddress(IY + Word(offset) & 0xffff, tStates: 3)
            break
        case 0x84:		/* ADD A,IYh */
            ADD(IYh)
            break
        case 0x85:		/* ADD A,IYl */
            ADD(IYl)
            break
        case 0x86:		/* ADD A,(IY+dd) */
            var offset: Byte
            var byteTemp: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            byteTemp = internalReadAddress(IY + Word(offset) & 0xffff, tStates: 3)
            ADD(byteTemp)
            break
        case 0x8c:		/* ADC A,IYh */
            ADC(IYh)
            break
        case 0x8d:		/* ADC A,IYl */
            ADC(IYl)
            break
        case 0x8e:		/* ADC A,(IY+dd) */
            var offset: Byte
            var byteTemp: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            byteTemp = internalReadAddress(IY + Word(offset) & 0xffff, tStates: 3)
            ADC(byteTemp)
            break
        case 0x94:		/* SUB A,IYh */
            SUB(IYh)
            break
        case 0x95:		/* SUB A,IYl */
            SUB(IYl)
            break
        case 0x96:		/* SUB A,(IY+dd) */
            var offset: Byte
            var byteTemp: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            byteTemp = internalReadAddress(IY + Word(offset) & 0xffff, tStates: 3)
            SUB(byteTemp)
            break
        case 0x9c:		/* SBC A,IYh */
            SBC(IYh)
            break
        case 0x9d:		/* SBC A,IYl */
            SBC(IYl)
            break
        case 0x9e:		/* SBC A,(IY+dd) */
            var offset: Byte
            var byteTemp: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            byteTemp = internalReadAddress(IY + Word(offset) & 0xffff, tStates: 3)
            SBC(byteTemp)
            break
        case 0xa4:		/* AND A,IYh */
            AND(IYh)
            break
        case 0xa5:		/* AND A,IYl */
            AND(IYl)
            break
        case 0xa6:		/* AND A,(IY+dd) */
            var offset: Byte
            var byteTemp: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            byteTemp = internalReadAddress(IY + Word(offset) & 0xffff, tStates: 3)
            AND(byteTemp)
            break
        case 0xac:		/* XOR A,IYh */
            XOR(IYh)
            break
        case 0xad:		/* XOR A,IYl */
            XOR(IYl)
            break
        case 0xae:		/* XOR A,(IY+dd) */
            var offset: Byte
            var byteTemp: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            byteTemp = internalReadAddress(IY + Word(offset) & 0xffff, tStates: 3)
            XOR(byteTemp)
            break
        case 0xb4:		/* OR A,IYh */
            OR(IYh)
            break
        case 0xb5:		/* OR A,IYl */
            OR(IYl)
            break
        case 0xb6:		/* OR A,(IY+dd) */
            var offset: Byte
            var byteTemp: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            byteTemp = internalReadAddress(IY + Word(offset) & 0xffff, tStates: 3)
            OR(byteTemp)
            break
        case 0xbc:		/* CP A,IYh */
            CP(IYh)
            break
        case 0xbd:		/* CP A,IYl */
            CP(IYl)
            break
        case 0xbe:		/* CP A,(IY+dd) */
            var offset: Byte
            var byteTemp: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            byteTemp = internalReadAddress(IY + Word(offset) & 0xffff, tStates: 3)
            CP(byteTemp)
            break
        case 0xcb:		/* shift DDFDCB */
            var opcode3: Byte
            contend_read(PC, tStates: 3)
            let tempAddr: Word = IY + (Word(internalReadAddress(PC, tStates: 3)) & 0xffff)
            PC += 1
            opcode3 = internalReadAddress(PC, tStates: 4)
            contend_read_no_mreq(PC, tStates: 1)
            contend_read_no_mreq(PC, tStates: 1)
            PC += 1
            lookupDDFDCBOpcode(opcode3, address: tempAddr)
            break
        case 0xe1:		/* POP IY */
            POP16(&IYl,regH: &IYh)
            break
        case 0xe3:		/* EX (SP),IY */
            var byteTempL: Byte
            var byteTempH: Byte
            byteTempL = internalReadAddress(SP, tStates: 3)
            byteTempH = internalReadAddress(SP + 1, tStates: 3)
            contend_read_no_mreq(SP + 1, tStates: 1)
            internalWriteAddress(SP + 1, value: IYh)
            internalWriteAddress(SP, value: IYl)
            contend_read_no_mreq(SP, tStates: 1)
            contend_read_no_mreq(SP, tStates: 1)
            IYl = byteTempL
            IYh = byteTempH
            break
        case 0xe5:		/* PUSH IY */
            contend_read_no_mreq(IR, tStates: 1)
            PUSH16(IYl,regH: IYh)
            break
        case 0xe9:		/* JP IY */
            PC=IY		/* NB: NOT INDIRECT! */
            break
        case 0xf9:		/* LD SP,IY */
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            SP = IY
            break
        default:		/* Instruction did not involve H or L, so backtrack
             one instruction and parse again */
//            PC -= 1
//            R -= 1
//            var opcode: Byte = opcode2
//            lookupBaseOpcode(opcode)
//            #ifdef HAVE_ENOUGH_MEMORY
//            goto end_opcode
//            #else			/* #ifdef HAVE_ENOUGH_MEMORY */
//            return 1
//            #endif			/* #ifdef HAVE_ENOUGH_MEMORY */
            break
        }
        
	}
	
}
