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
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            ADD16(&IY,value2: BC)
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
            IYl = memoryReadAddress(PC)
            PC += 1
            IYh = memoryReadAddress(PC)
            PC += 1
            break
        case 0x22:		/* LD (nnnn),IX */
            LD16_NNRR(IYl,regH: IYh)
            break
        case 0x23:		/* INC IX */
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            IX += 1
            break
        case 0x24:		/* INC IYh */
            INC(&IYh)
            break
        case 0x25:		/* DEC IYh */
            DEC(&IYh)
            break
        case 0x26:		/* LD IYh,nn */
            IYh = memoryReadAddress(PC)
            PC += 1
            break
        case 0x29:		/* ADD IY,IX */
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            ADD16(&IY,value2: IX)
            break
        case 0x2a:		/* LD IY,(nnnn) */
            LD16_RRNN(&IYl,regH: &IYh)
            break
        case 0x2b:		/* DEC IX */
            contend_read_no_mreq(IR, tStates:1)
            contend_read_no_mreq(IR, tStates:1)
            IX += 1
            break
        case 0x2c:		/* INC IYl */
            INC(&IYl)
            break
        case 0x2d:		/* DEC IYl */
            DEC(&IYl)
            break
        case 0x2e:		/* LD IYl,nn */
            IYl = memoryReadAddress(PC)
            PC += 1
            break
        case 0x34:		/* INC (IX+dd) */
            var offset: Byte
            var byteTemp: Byte
            var wordTemp: Word
            
            offset = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            wordTemp = IX + Word(offset) & 0xffff
            byteTemp = memoryReadAddress(wordTemp)
            contend_read_no_mreq(wordTemp, tStates:1)
            INC(&byteTemp)
            memoryWriteAddress(wordTemp,value: byteTemp)
            break
        case 0x35:		/* DEC (IX+dd) */
            var offset: Byte
            var byteTemp: Byte
            var wordTemp: Word
            
            offset = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            wordTemp = IX + Word(offset) & 0xffff
            byteTemp = memoryReadAddress(wordTemp)
            contend_read_no_mreq(wordTemp, tStates:1)
            DEC(&byteTemp)
            memoryWriteAddress(wordTemp,value: byteTemp)
            break
        case 0x36:		/* LD (IX+dd),nn */
            var offset: Byte
            var value: Byte
            offset = memoryReadAddress(PC)
            PC += 1
            value = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates: 1)
            contend_read_no_mreq(PC, tStates: 1)
            PC += 1
            memoryWriteAddress(IX + Word(offset) & 0xffff, value: value)
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
        case 0x46:		/* LD B,(IX+dd) */
            var offset: Byte
            offset = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            B = memoryReadAddress(IX + Word(offset) & 0xffff)
            break
        case 0x4c:		/* LD C,IYh */
            C = IYh
            break
        case 0x4d:		/* LD C,IYl */
            C = IYl
            break
        case 0x4e:		/* LD C,(IX+dd) */
            var offset: Byte
            offset = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            C = memoryReadAddress(IX + Word(offset) & 0xffff)
            break
        case 0x54:		/* LD D,IYh */
            D = IYh
            break
        case 0x55:		/* LD D,IYl */
            D = IYl
            break
        case 0x56:		/* LD D,(IX+dd) */
            var offset: Byte
            offset = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            D = memoryReadAddress(IX + Word(offset) & 0xffff)
            break
        case 0x5c:		/* LD E,IYh */
            E = IYh
            break
        case 0x5d:		/* LD E,IYl */
            E = IYl
            break
        case 0x5e:		/* LD E,(IX+dd) */
            var offset: Byte
            offset = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            E = memoryReadAddress(IX + Word(offset) & 0xffff)
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
        case 0x66:		/* LD H,(IX+dd) */
            var offset: Byte
            offset = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            H = memoryReadAddress(IX + Word(offset) & 0xffff)
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
        case 0x6e:		/* LD L,(IX+dd) */
            var offset: Byte
            offset = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            L = memoryReadAddress(IX + Word(offset) & 0xffff)
            break
        case 0x6f:		/* LD IYl,A */
            IYl = A
            break
        case 0x70:		/* LD (IX+dd),B */
            var offset: Byte
            offset = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            memoryWriteAddress(IX + Word(offset) & 0xffff, value: B)
            break
        case 0x71:		/* LD (IX+dd),C */
            var offset: Byte
            offset = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            memoryWriteAddress(IX + Word(offset) & 0xffff, value: C)
            break
        case 0x72:		/* LD (IX+dd),D */
            var offset: Byte
            offset = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            memoryWriteAddress(IX + Word(offset) & 0xffff, value: D)
            break
        case 0x73:		/* LD (IX+dd),E */
            var offset: Byte
            offset = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            memoryWriteAddress(IX + Word(offset) & 0xffff, value: E)
            break
        case 0x74:		/* LD (IX+dd),H */
            var offset: Byte
            offset = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            memoryWriteAddress(IX + Word(offset) & 0xffff, value: H)
            break
        case 0x75:		/* LD (IX+dd),L */
            var offset: Byte
            offset = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            memoryWriteAddress(IX + Word(offset) & 0xffff, value: L)
            break
        case 0x77:		/* LD (IX+dd),A */
            var offset: Byte
            offset = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            memoryWriteAddress(IX + Word(offset) & 0xffff, value: A)
            break
        case 0x7c:		/* LD A,IYh */
            A = IYh
            break
        case 0x7d:		/* LD A,IYl */
            A = IYl
            break
        case 0x7e:		/* LD A,(IX+dd) */
            var offset: Byte
            offset = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            A = memoryReadAddress(IX + Word(offset) & 0xffff)
            break
        case 0x84:		/* ADD A,IYh */
            ADD(IYh)
            break
        case 0x85:		/* ADD A,IYl */
            ADD(IYl)
            break
        case 0x86:		/* ADD A,(IX+dd) */
            var offset: Byte
            var byteTemp: Byte
            offset = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            byteTemp = memoryReadAddress(IX + Word(offset) & 0xffff)
            ADD(byteTemp)
            break
        case 0x8c:		/* ADC A,IYh */
            ADC(IYh)
            break
        case 0x8d:		/* ADC A,IYl */
            ADC(IYl)
            break
        case 0x8e:		/* ADC A,(IX+dd) */
            var offset: Byte
            var byteTemp: Byte
            offset = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            byteTemp = memoryReadAddress(IX + Word(offset) & 0xffff)
            ADC(byteTemp)
            break
        case 0x94:		/* SUB A,IYh */
            SUB(IYh)
            break
        case 0x95:		/* SUB A,IYl */
            SUB(IYl)
            break
        case 0x96:		/* SUB A,(IX+dd) */
            var offset: Byte
            var byteTemp: Byte
            offset = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            byteTemp = memoryReadAddress(IX + Word(offset) & 0xffff)
            SUB(byteTemp)
            break
        case 0x9c:		/* SBC A,IYh */
            SBC(IYh)
            break
        case 0x9d:		/* SBC A,IYl */
            SBC(IYl)
            break
        case 0x9e:		/* SBC A,(IX+dd) */
            var offset: Byte
            var byteTemp: Byte
            offset = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            byteTemp = memoryReadAddress(IX + Word(offset) & 0xffff)
            SBC(byteTemp)
            break
        case 0xa4:		/* AND A,IYh */
            AND(IYh)
            break
        case 0xa5:		/* AND A,IYl */
            AND(IYl)
            break
        case 0xa6:		/* AND A,(IX+dd) */
            var offset: Byte
            var byteTemp: Byte
            offset = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            byteTemp = memoryReadAddress(IX + Word(offset) & 0xffff)
            AND(byteTemp)
            break
        case 0xac:		/* XOR A,IYh */
            XOR(IYh)
            break
        case 0xad:		/* XOR A,IYl */
            XOR(IYl)
            break
        case 0xae:		/* XOR A,(IX+dd) */
            var offset: Byte
            var byteTemp: Byte
            offset = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            byteTemp = memoryReadAddress(IX + Word(offset) & 0xffff)
            XOR(byteTemp)
            break
        case 0xb4:		/* OR A,IYh */
            OR(IYh)
            break
        case 0xb5:		/* OR A,IYl */
            OR(IYl)
            break
        case 0xb6:		/* OR A,(IX+dd) */
            var offset: Byte
            var byteTemp: Byte
            offset = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            byteTemp = memoryReadAddress(IX + Word(offset) & 0xffff)
            OR(byteTemp)
            break
        case 0xbc:		/* CP A,IYh */
            CP(IYh)
            break
        case 0xbd:		/* CP A,IYl */
            CP(IYl)
            break
        case 0xbe:		/* CP A,(IX+dd) */
            var offset: Byte
            var byteTemp: Byte
            offset = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            contend_read_no_mreq(PC, tStates:1)
            PC += 1
            byteTemp = memoryReadAddress(IX + Word(offset) & 0xffff)
            CP(byteTemp)
            break
        case 0xcb:		/* shift DDFDCB */
            var opcode3: Byte
            contend_read(PC, tStates: 3)
            let tempAddr: Word = IX + (Word(memoryReadAddress(PC)) & 0xffff)
            PC += 1
            contend_read(PC, tStates: 3)
            opcode3 = memoryReadAddress(PC)
            contend_read_no_mreq(PC, tStates: 1)
            contend_read_no_mreq(PC, tStates: 1)
            PC += 1
            lookupDDFDCBOpcode(opcode3, address: tempAddr)
            break
        case 0xe1:		/* POP IX */
            POP16(&IYl,regH: &IYh)
            break
        case 0xe3:		/* EX (SP),IX */
            var byteTempL: Byte
            var byteTempH: Byte
            byteTempL = memoryReadAddress(SP)
            byteTempH = memoryReadAddress(SP + 1)
            contend_read_no_mreq(SP + 1, tStates: 1)
            memoryWriteAddress(SP + 1, value: IYh)
            memoryWriteAddress(SP, value: IYl)
            contend_read_no_mreq(SP, tStates: 1)
            contend_read_no_mreq(SP, tStates: 1)
            IYl = byteTempL
            IYh = byteTempH
            break
        case 0xe5:		/* PUSH IX */
            contend_read_no_mreq(IR, tStates: 1)
            PUSH16(&IYl,regH: &IYh)
            break
        case 0xe9:		/* JP IX */
            PC=IX		/* NB: NOT INDIRECT! */
            break
        case 0xf9:		/* LD SP,IX */
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            SP = IX
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
