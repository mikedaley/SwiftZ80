//
//  Opcodes_DDFD.swift
//  SwiftZ80
//
//  Created by Mike Daley on 02/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

extension SwiftZ80Core {
	
	mutating func lookupDDFDOpcode(opcode: Byte, inout REGISTER: Word, inout REGISTERL: Byte, inout REGISTERH: Byte) {
        
        switch opcode {

        case 0x09:		/* ADD REGISTER,BC */
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            ADD16(&REGISTER,value2: BC)
            break
        case 0x19:		/* ADD REGISTER,DE */
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            ADD16(&REGISTER,value2: DE)
            break
        case 0x21:		/* LD REGISTER,nnnn */
            REGISTERL = internalReadAddress(PC, tStates: 3)
            PC += 1
            REGISTERH = internalReadAddress(PC, tStates: 3)
            PC += 1
            break
        case 0x22:		/* LD (nnnn),REGISTER */
            LD16_NNRR(REGISTERL,regH: REGISTERH)
            break
        case 0x23:		/* INC REGISTER */
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            REGISTER += 1
            break
        case 0x24:		/* INC REGISTERH */
            INC(&REGISTERH)
            break
        case 0x25:		/* DEC REGISTERH */
            DEC(&REGISTERH)
            break
        case 0x26:		/* LD REGISTERH,nn */
            REGISTERH = internalReadAddress(PC, tStates: 3)
            PC += 1
            break
        case 0x29:		/* ADD REGISTER,REGISTER */
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            ADD16(&REGISTER,value2: REGISTER)
            break
        case 0x2a:		/* LD REGISTER,(nnnn) */
            LD16_RRNN(&REGISTERL,regH: &REGISTERH)
            break
        case 0x2b:		/* DEC REGISTER */
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            REGISTER += 1
            break
        case 0x2c:		/* INC REGISTERL */
            INC(&REGISTERL)
            break
        case 0x2d:		/* DEC REGISTERL */
            DEC(&REGISTERL)
            break
        case 0x2e:		/* LD REGISTERL,nn */
            REGISTERL = internalReadAddress(PC, tStates: 3)
            PC += 1
            break
        case 0x34:		/* INC (REGISTER+dd) */
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
            wordTemp = REGISTER + Word(offset) & 0xffff
            byteTemp = internalReadAddress(wordTemp, tStates: 3)
            contend_read_no_mreq(wordTemp, tStates:1)
            INC(&byteTemp)
            internalWriteAddress(wordTemp,value: byteTemp)
            break
        case 0x35:		/* DEC (REGISTER+dd) */
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
            wordTemp = REGISTER + Word(offset) & 0xffff
            byteTemp = internalReadAddress(wordTemp, tStates: 3)
            contend_read_no_mreq(wordTemp, tStates:1)
            DEC(&byteTemp)
            internalWriteAddress(wordTemp,value: byteTemp)
            break
        case 0x36:		/* LD (REGISTER+dd),nn */
            var offset: Byte
            var value: Byte
            offset = internalReadAddress(PC, tStates: 3)
            PC += 1
            value = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates: 1)
            contend_read_no_mreq(PC, tStates: 1)
            PC += 1
            internalWriteAddress(REGISTER + Word(offset) & 0xffff, value: value)
            break
        case 0x39:		/* ADD REGISTER,SP */
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            ADD16(&REGISTER,value2: SP)
            break
        case 0x44:		/* LD B,REGISTERH */
            B = REGISTERH
            break
        case 0x45:		/* LD B,REGISTERL */
            B = REGISTERL
            break
        case 0x46:		/* LD B,(REGISTER+dd) */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            B = internalReadAddress(REGISTER + Word(offset) & 0xffff, tStates: 3)
            break
        case 0x4c:		/* LD C,REGISTERH */
            C = REGISTERH
            break
        case 0x4d:		/* LD C,REGISTERL */
            C = REGISTERL
            break
        case 0x4e:		/* LD C,(REGISTER+dd) */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            C = internalReadAddress(REGISTER + Word(offset) & 0xffff, tStates: 3)
            break
        case 0x54:		/* LD D,REGISTERH */
            D = REGISTERH
            break
        case 0x55:		/* LD D,REGISTERL */
            D = REGISTERL
            break
        case 0x56:		/* LD D,(REGISTER+dd) */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            D = internalReadAddress(REGISTER + Word(offset) & 0xffff, tStates: 3)
            break
        case 0x5c:		/* LD E,REGISTERH */
            E = REGISTERH
            break
        case 0x5d:		/* LD E,REGISTERL */
            E = REGISTERL
            break
        case 0x5e:		/* LD E,(REGISTER+dd) */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            E = internalReadAddress(REGISTER + Word(offset) & 0xffff, tStates: 3)
            break
        case 0x60:		/* LD REGISTERH,B */
            REGISTERH = B
            break
        case 0x61:		/* LD REGISTERH,C */
            REGISTERH = C
            break
        case 0x62:		/* LD REGISTERH,D */
            REGISTERH = D
            break
        case 0x63:		/* LD REGISTERH,E */
            REGISTERH = E
            break
        case 0x64:		/* LD REGISTERH,REGISTERH */
            break
        case 0x65:		/* LD REGISTERH,REGISTERL */
            REGISTERH = REGISTERL
            break
        case 0x66:		/* LD H,(REGISTER+dd) */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            H = internalReadAddress(REGISTER + Word(offset) & 0xffff, tStates: 3)
            break
        case 0x67:		/* LD REGISTERH,A */
            REGISTERH = A
            break
        case 0x68:		/* LD REGISTERL,B */
            REGISTERL = B
            break
        case 0x69:		/* LD REGISTERL,C */
            REGISTERL = C
            break
        case 0x6a:		/* LD REGISTERL,D */
            REGISTERL = D
            break
        case 0x6b:		/* LD REGISTERL,E */
            REGISTERL = E
            break
        case 0x6c:		/* LD REGISTERL,REGISTERH */
            REGISTERL = REGISTERH
            break
        case 0x6d:		/* LD REGISTERL,REGISTERL */
            break
        case 0x6e:		/* LD L,(REGISTER+dd) */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            L = internalReadAddress(REGISTER + Word(offset) & 0xffff, tStates: 3)
            break
        case 0x6f:		/* LD REGISTERL,A */
            REGISTERL = A
            break
        case 0x70:		/* LD (REGISTER+dd),B */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            internalWriteAddress(REGISTER + Word(offset) & 0xffff, value: B)
            break
        case 0x71:		/* LD (REGISTER+dd),C */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            internalWriteAddress(REGISTER + Word(offset) & 0xffff, value: C)
            break
        case 0x72:		/* LD (REGISTER+dd),D */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            internalWriteAddress(REGISTER + Word(offset) & 0xffff, value: D)
            break
        case 0x73:		/* LD (REGISTER+dd),E */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            internalWriteAddress(REGISTER + Word(offset) & 0xffff, value: E)
            break
        case 0x74:		/* LD (REGISTER+dd),H */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            internalWriteAddress(REGISTER + Word(offset) & 0xffff, value: H)
            break
        case 0x75:		/* LD (REGISTER+dd),L */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            internalWriteAddress(REGISTER + Word(offset) & 0xffff, value: L)
            break
        case 0x77:		/* LD (REGISTER+dd),A */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            internalWriteAddress(REGISTER + Word(offset) & 0xffff, value: A)
            break
        case 0x7c:		/* LD A,REGISTERH */
            A = REGISTERH
            break
        case 0x7d:		/* LD A,REGISTERL */
            A = REGISTERL
            break
        case 0x7e:		/* LD A,(REGISTER+dd) */
            var offset: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            A = internalReadAddress(REGISTER + Word(offset) & 0xffff, tStates: 3)
            break
        case 0x84:		/* ADD A,REGISTERH */
            ADD(REGISTERH)
            break
        case 0x85:		/* ADD A,REGISTERL */
            ADD(REGISTERL)
            break
        case 0x86:		/* ADD A,(REGISTER+dd) */
            var offset: Byte
            var byteTemp: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            byteTemp = internalReadAddress(REGISTER + Word(offset) & 0xffff, tStates: 3)
            ADD(byteTemp)
            break
        case 0x8c:		/* ADC A,REGISTERH */
            ADC(REGISTERH)
            break
        case 0x8d:		/* ADC A,REGISTERL */
            ADC(REGISTERL)
            break
        case 0x8e:		/* ADC A,(REGISTER+dd) */
            var offset: Byte
            var byteTemp: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            byteTemp = internalReadAddress(REGISTER + Word(offset) & 0xffff, tStates: 3)
            ADC(byteTemp)
            break
        case 0x94:		/* SUB A,REGISTERH */
            SUB(REGISTERH)
            break
        case 0x95:		/* SUB A,REGISTERL */
            SUB(REGISTERL)
            break
        case 0x96:		/* SUB A,(REGISTER+dd) */
            var offset: Byte
            var byteTemp: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            byteTemp = internalReadAddress(REGISTER + Word(offset) & 0xffff, tStates: 3)
            SUB(byteTemp)
            break
        case 0x9c:		/* SBC A,REGISTERH */
            SBC(REGISTERH)
            break
        case 0x9d:		/* SBC A,REGISTERL */
            SBC(REGISTERL)
            break
        case 0x9e:		/* SBC A,(REGISTER+dd) */
            var offset: Byte
            var byteTemp: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            byteTemp = internalReadAddress(REGISTER + Word(offset) & 0xffff, tStates: 3)
            SBC(byteTemp)
            break
        case 0xa4:		/* AND A,REGISTERH */
            AND(REGISTERH)
            break
        case 0xa5:		/* AND A,REGISTERL */
            AND(REGISTERL)
            break
        case 0xa6:		/* AND A,(REGISTER+dd) */
            var offset: Byte
            var byteTemp: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            byteTemp = internalReadAddress(REGISTER + Word(offset) & 0xffff, tStates: 3)
            AND(byteTemp)
            break
        case 0xac:		/* XOR A,REGISTERH */
            XOR(REGISTERH)
            break
        case 0xad:		/* XOR A,REGISTERL */
            XOR(REGISTERL)
            break
        case 0xae:		/* XOR A,(REGISTER+dd) */
            var offset: Byte
            var byteTemp: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            byteTemp = internalReadAddress(REGISTER + Word(offset) & 0xffff, tStates: 3)
            XOR(byteTemp)
            break
        case 0xb4:		/* OR A,REGISTERH */
            OR(REGISTERH)
            break
        case 0xb5:		/* OR A,REGISTERL */
            OR(REGISTERL)
            break
        case 0xb6:		/* OR A,(REGISTER+dd) */
            var offset: Byte
            var byteTemp: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            byteTemp = internalReadAddress(REGISTER + Word(offset) & 0xffff, tStates: 3)
            OR(byteTemp)
            break
        case 0xbc:		/* CP A,REGISTERH */
            CP(REGISTERH)
            break
        case 0xbd:		/* CP A,REGISTERL */
            CP(REGISTERL)
            break
        case 0xbe:		/* CP A,(REGISTER+dd) */
            var offset: Byte
            var byteTemp: Byte
            offset = internalReadAddress(PC, tStates: 3)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            byteTemp = internalReadAddress(REGISTER + Word(offset) & 0xffff, tStates: 3)
            CP(byteTemp)
            break
        case 0xcb:		/* shift DDFDCB */
            var opcode3: Byte
            contend_read(PC, tStates: 3)
            let tempAddr: Word = REGISTER + (Word(internalReadAddress(PC, tStates: 3)) & 0xffff)
            PC += 1
            opcode3 = internalReadAddress(PC, tStates: 4)
            contend_read_no_mreq(PC, tStates: 1)
            contend_read_no_mreq(PC, tStates: 1)
            PC += 1
            lookupDDFDCBOpcode(opcode3, address: tempAddr)
            break
        case 0xe1:		/* POP REGISTER */
            POP16(&REGISTERL,regH: &REGISTERH)
            break
        case 0xe3:		/* EX (SP),REGISTER */
            var byteTempL: Byte
            var byteTempH: Byte
            byteTempL = internalReadAddress(SP, tStates: 3)
            byteTempH = internalReadAddress(SP + 1, tStates: 3)
            contend_read_no_mreq(SP + 1, tStates: 1)
            internalWriteAddress(SP + 1, value: REGISTERH)
            internalWriteAddress(SP, value: REGISTERL)
            contend_read_no_mreq(SP, tStates: 1)
            contend_read_no_mreq(SP, tStates: 1)
            REGISTERL = byteTempL
            REGISTERH = byteTempH
            break
        case 0xe5:		/* PUSH REGISTER */
            contend_read_no_mreq(IR, tStates: 1)
            PUSH16(&REGISTERL,regH: &REGISTERH)
            break
        case 0xe9:		/* JP REGISTER */
            PC=REGISTER		/* NB: NOT INDIRECT! */
            break
        case 0xf9:		/* LD SP,REGISTER */
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            SP = REGISTER
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
