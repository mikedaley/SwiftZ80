//
//  Opcodes_ED.swift
//  SwiftZ80
//
//  Created by Mike Daley on 02/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

extension SwiftZ80Core {
    
    func lookupEDOpcode(opcode: Byte) {
        
        switch opcode {
        case 0x40:		/* IN B,(C) */
            Z80_IN(&B, port: BC)
            break
        case 0x41:		/* OUT (C),B */
            externalIOWrite(BC, value: B)
            break
        case 0x42:		/* SBC HL,BC */
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            SBC16(BC)
            break
        case 0x43:		/* LD (nnnn),BC */
            LD16_NNRR(C,regH: B)
            break
        case 0x44: fallthrough
        case 0x4c: fallthrough
        case 0x54: fallthrough
        case 0x5c: fallthrough
        case 0x64: fallthrough
        case 0x6c: fallthrough
        case 0x74: fallthrough
        case 0x7c:		/* NEG */
            let temp: Byte = A
            A = 0
            SUB(temp)
            break
        case 0x45: fallthrough
        case 0x4d: fallthrough
        case 0x55: fallthrough
        case 0x5d: fallthrough
        case 0x65: fallthrough
        case 0x6d: fallthrough
        case 0x75: fallthrough
        case 0x7d:		/* RETN */
            IFF1 = IFF2
            RET()
            break
        case 0x46: fallthrough
        case 0x4e: fallthrough
        case 0x66: fallthrough
        case 0x6e:		/* IM 0 */
            IM = 0
            break
        case 0x47:		/* LD I,A */
            coreMemoryContention(IR, tStates: 1)
            I = A
            break
        case 0x48:		/* IN C,(C) */
            Z80_IN(&C, port: BC)
            break
        case 0x49:		/* OUT (C),C */
            externalIOWrite(BC, value: C)
            break
        case 0x4a:		/* ADC HL,BC */
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            ADC16(BC)
            break
        case 0x4b:		/* LD BC,(nnnn) */
            LD16_RRNN(&C,regH: &B)
            break
        case 0x4f:		/* LD R,A */
            coreMemoryContention(IR, tStates: 1)
            R = A
            break
        case 0x50:		/* IN D,(C) */
            Z80_IN(&D, port: BC)
            break
        case 0x51:		/* OUT (C),D */
            externalIOWrite(BC, value: D)
            break
        case 0x52:		/* SBC HL,DE */
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            SBC16(DE)
            break
        case 0x53:		/* LD (nnnn),DE */
            LD16_NNRR(E,regH: D)
            break
        case 0x56: fallthrough
        case 0x76:		/* IM 1 */
            IM = 1
            break
        case 0x57:		/* LD A,I */
            coreMemoryContention(IR, tStates: 1)
            A = I
            F = (F & FLAG_C) | SZ35Table[A] | (IFF2 != 0x00 ? FLAG_V : 0)
            break
        case 0x58:		/* IN E,(C) */
            Z80_IN(&E, port: BC)
            break
        case 0x59:		/* OUT (C),E */
            externalIOWrite(BC, value: E)
            break
        case 0x5a:		/* ADC HL,DE */
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            ADC16(DE)
            break
        case 0x5b:		/* LD DE,(nnnn) */
            LD16_RRNN(&E,regH: &D)
            break
        case 0x5e: fallthrough
        case 0x7e:		/* IM 2 */
            IM = 2
            break
        case 0x5f:		/* LD A,R */
            coreMemoryContention(IR, tStates: 1)
            A = (R & 0x7f)
            F = (F & FLAG_C) | SZ35Table[A] | (IFF2 != 0x00 ? FLAG_V : 0)
            break
        case 0x60:		/* IN H,(C) */
            Z80_IN(&H, port: BC)
            break
        case 0x61:		/* OUT (C),H */
            externalIOWrite(BC, value: H)
            break
        case 0x62:		/* SBC HL,HL */
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            SBC16(HL)
            break
        case 0x63:		/* LD (nnnn),HL */
            LD16_NNRR(L,regH: H)
            break
        case 0x67:		/* RRD */
            let temp: Byte = coreMemoryRead(HL, tStates: 3)
            coreMemoryContention(HL, tStates: 1)
            coreMemoryContention(HL, tStates: 1)
            coreMemoryContention(HL, tStates: 1)
            coreMemoryContention(HL, tStates: 1)
            coreMemoryWrite(HL,  value: (A << 4) | (temp >> 4))
            A = (A & 0xf0) | (temp & 0x0f)
            F = (F & FLAG_C) | SZ35Table[A] | parityTable[A]
            break
        case 0x68:		/* IN L,(C) */
            Z80_IN(&L, port: BC)
            break
        case 0x69:		/* OUT (C),L */
            externalIOWrite(BC, value: L)
            break
        case 0x6a:		/* ADC HL,HL */
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            ADC16(HL)
            break
        case 0x6b:		/* LD HL,(nnnn) */
            LD16_RRNN(&L,regH: &H)
            break
        case 0x6f:		/* RLD */
            let temp: Byte = coreMemoryRead(HL, tStates: 3)
            coreMemoryContention(HL, tStates: 1)
            coreMemoryContention(HL, tStates: 1)
            coreMemoryContention(HL, tStates: 1)
            coreMemoryContention(HL, tStates: 1)
            coreMemoryWrite(HL, value: (temp << 4) | (A & 0x0f))
            A = (A & 0xf0) | (temp >> 4)
            F = (F & FLAG_C) | SZ35Table[A] | parityTable[A]
            break
        case 0x70:		/* IN F,(C) */
			var temp: Byte = 0
			Z80_IN(&temp, port: BC)
			break
        case 0x71:		/* OUT (C),0 */
            externalIOWrite(BC, value: 0)
            break
        case 0x72:		/* SBC HL,SP */
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            SBC16(SP)
            break
        case 0x73:		/* LD (nnnn),SP */
            LD16_NNRR(SPl,regH: SPh)
            break
        case 0x78:		/* IN A,(C) */
            Z80_IN(&A, port: BC)
            break
        case 0x79:		/* OUT (C),A */
            externalIOWrite(BC, value: A)
            break
        case 0x7a:		/* ADC HL,SP */
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            coreMemoryContention(IR, tStates: 1)
            ADC16(SP)
            break
        case 0x7b:		/* LD SP,(nnnn) */
            LD16_RRNN(&SPl,regH: &SPh)
            break
        case 0xa0:		/* LDI */
            var temp = coreMemoryRead(HL, tStates: 3)
            BC = BC &- 1
            coreMemoryWrite(DE,value: temp)
            coreMemoryContention(DE, tStates: 1)
            coreMemoryContention(DE, tStates: 1)
            DE = DE &+ 1
            HL = HL &+ 1
			temp = temp &+ A
            F = (F & (FLAG_C | FLAG_Z | FLAG_S)) | (BC != 0x00 ? FLAG_V : 0) |
                (temp & FLAG_3) | ((temp & 0x02) != 0x00 ? FLAG_5 : 0)
            break
        case 0xa1:		/* CPI */
            let value: Byte = coreMemoryRead(HL, tStates: 3)
            var temp: Byte = A &- value
            let lookup: Byte = ((A & 0x08) >> 3) | ((value & 0x08) >> 2) | ((Byte(temp & 0xff) & 0x08) >> 1)
            
            coreMemoryContention(HL, tStates: 1)
            coreMemoryContention(HL, tStates: 1)
            coreMemoryContention(HL, tStates: 1)
            coreMemoryContention(HL, tStates: 1)
            coreMemoryContention(HL, tStates: 1)
            HL = HL &+ 1
            BC = BC &- 1
            F = (F & FLAG_C) | (BC != 0x00 ? (FLAG_V | FLAG_N) : FLAG_N) | halfcarrySubTable[lookup] | (temp != 0x00 ? 0 : FLAG_Z) | (temp & FLAG_S)
            if F & FLAG_H == FLAG_H {
                temp = temp &- 1
            }
            F |= (temp & FLAG_3) | ((temp & 0x02) != 0x00 ? FLAG_5 : 0)
            break
        case 0xa2:		/* INI */
            var temp1: Byte
			
            coreMemoryContention(IR, tStates: 1)
            temp1 = externalIORead(BC)
            coreMemoryWrite(HL, value: temp1)
            
            B = B &- 1
            HL = HL &+ 1
			let temp2: Byte = temp1 &+ C &+ 1
			
            let t = Byte((temp2 & 0x07) ^ B)
			
            F = (temp1 & 0x80 != 0x00 ? FLAG_N : 0) | (temp2 < temp1 ? FLAG_H | FLAG_C : 0) | (parityTable[ t ] != 0x00 ? FLAG_P : 0) | SZ35Table[B]
			
            break
        case 0xa3:		/* OUTI */
            var temp1: Byte

			coreMemoryContention(IR, tStates: 1)
            temp1 = coreMemoryRead(HL, tStates: 3)
            B = B &- 1	/* This does happen first, despite what the specs say */
            externalIOWrite(BC, value: temp1)
            
            HL = HL &+ 1

			let temp2: Byte = temp1 &+ L
			
			let t = Byte((temp2 & 0x07) ^ B)
			
			F = (temp1 & 0x80 != 0x00 ? FLAG_N : 0) | (temp2 < temp1 ? FLAG_H | FLAG_C : 0) | (parityTable[ t ] != 0x00 ? FLAG_P : 0) | SZ35Table[B]
			
			break
        case 0xa8:		/* LDD */
            var temp = coreMemoryRead(HL, tStates: 3)
            BC = BC &- 1
            coreMemoryWrite(DE, value: temp)
            coreMemoryContention(DE, tStates: 1)
            coreMemoryContention(DE, tStates: 1)
            DE = DE &- 1
            HL = HL &- 1
            temp = temp &+ A
            F = (F & (FLAG_C | FLAG_Z | FLAG_S)) | (BC != 0x00 ? FLAG_V : 0) |
                (temp & FLAG_3) | ((temp & 0x02) != 0x00 ? FLAG_5 : 0)
            break
        case 0xa9:		/* CPD */
            let value: Byte = coreMemoryRead(HL, tStates: 3)
            var temp: Byte = A &- value
            let lookup: Byte = ((A & 0x08) >> 3) | ((value & 0x08) >> 2) | ((Byte(temp & 0xff) & 0x08) >> 1)
            coreMemoryContention(HL, tStates: 1)
            coreMemoryContention(HL, tStates: 1)
            coreMemoryContention(HL, tStates: 1)
            coreMemoryContention(HL, tStates: 1)
            coreMemoryContention(HL, tStates: 1)
            HL = HL &- 1
            BC = BC &- 1
            F = (F & FLAG_C) | (BC != 0x00 ? (FLAG_V | FLAG_N) : FLAG_N) | halfcarrySubTable[lookup] | (temp != 0x00 ? 0 : FLAG_Z) | (temp & FLAG_S)
            if F & FLAG_H == FLAG_H {
                temp = temp &- 1
            }
            F |= (temp & FLAG_3) | ((temp & 0x02) != 0x00 ? FLAG_5 : 0)
            break
        case 0xaa:		/* IND */
            var temp1: Byte

			coreMemoryContention(IR, tStates: 1)
            temp1 = externalIORead(BC)
            coreMemoryWrite(HL, value: temp1)
            
            B = B &- 1
            HL = HL &- 1
			
			let temp2: Byte = temp1 &+ C &- 1

			let t = Byte((temp2 & 0x07) ^ B)
			
			F = (temp1 & 0x80 != 0x00 ? FLAG_N : 0) | (temp2 < temp1 ? FLAG_H | FLAG_C : 0) | (parityTable[ t ] != 0x00 ? FLAG_P : 0) | SZ35Table[B]
			
            break
        case 0xab:		/* OUTD */
            var temp1: Byte
			
            coreMemoryContention(IR, tStates: 1)
            temp1 = coreMemoryRead(HL, tStates: 3)
            B = B &- 1	/* This does happen first, despite what the specs say */
            externalIOWrite(BC, value: temp1)
            
            HL = HL &- 1
			
			let temp2 = temp1 &+ L
			
			let t = Byte((temp2 & 0x07) ^ B)
			
			F = (temp1 & 0x80 != 0x00 ? FLAG_N : 0) | (temp2 < temp1 ? FLAG_H | FLAG_C : 0) | (parityTable[ t ] != 0x00 ? FLAG_P : 0) | SZ35Table[B]
			
            break
        case 0xb0:		/* LDIR */
            var temp: Byte = coreMemoryRead(HL, tStates: 3)
            coreMemoryWrite(DE, value: temp)
            coreMemoryContention(DE, tStates: 1)
            coreMemoryContention(DE, tStates: 1)
            BC = BC &- 1
            temp = temp &+ A
            F = (F & (FLAG_C | FLAG_Z | FLAG_S)) | (BC != 0x00 ? FLAG_V : 0) |
                (temp & FLAG_3) | ((temp & 0x02) != 0x00 ? FLAG_5 : 0)
            if BC != 0x00 {
                coreMemoryContention(DE, tStates: 1)
                coreMemoryContention(DE, tStates: 1)
                coreMemoryContention(DE, tStates: 1)
                coreMemoryContention(DE, tStates: 1)
                coreMemoryContention(DE, tStates: 1)
                PC = PC &- 2
            }
            HL = HL &+ 1
            DE = DE &+ 1
            break
        case 0xb1:		/* CPIR */
            let value: Byte = coreMemoryRead(HL, tStates: 3)
            var temp: Byte = A &- value
            let lookup: Byte = ((A & 0x08) >> 3) | ((value & 0x08) >> 2) | ((Byte(temp & 0xff) & 0x08) >> 1)

            coreMemoryContention(HL, tStates: 1)
            coreMemoryContention(HL, tStates: 1)
            coreMemoryContention(HL, tStates: 1)
            coreMemoryContention(HL, tStates: 1)
            coreMemoryContention(HL, tStates: 1)
            
            BC = BC &- 1
            
            F = (F & FLAG_C) | (BC != 0x00 ? (FLAG_V | FLAG_N) : FLAG_N) | halfcarrySubTable[lookup] | (temp != 0x00 ? 0 : FLAG_Z) | (temp & FLAG_S)
            
            if F & FLAG_H == FLAG_H {
                temp = temp &- 1
            }
            
            F |= (temp & FLAG_3) | ((temp & 0x02) != 0x00 ? FLAG_5 : 0)
            
            if((F & (FLAG_V | FLAG_Z)) == FLAG_V) {
                coreMemoryContention(HL, tStates: 1)
                coreMemoryContention(HL, tStates: 1)
                coreMemoryContention(HL, tStates: 1)
                coreMemoryContention(HL, tStates: 1)
                coreMemoryContention(HL, tStates: 1)
                PC = PC &- 2
            }
            HL = HL &+ 1
            break
        case 0xb2:		/* INIR */
            var temp1: Byte
            var temp2: Byte
            
            coreMemoryContention(IR, tStates: 1)
            temp1 = externalIORead(BC)
            coreMemoryWrite(HL, value: temp1)
            
            B = B &- 1
            temp2 = temp1 + C + 1
            F = (temp1 & 0x80 != 0x00 ? FLAG_N : 0) | ((temp2 < temp1) ? FLAG_H | FLAG_C : 0) | (parityTable[ (temp2 & 0x07) ^ B ] != 0x00 ? FLAG_P : 0) | SZ35Table[B]
            
            if B != 0x00 {
                coreMemoryContention(HL, tStates: 1)
                coreMemoryContention(HL, tStates: 1)
                coreMemoryContention(HL, tStates: 1)
                coreMemoryContention(HL, tStates: 1)
                coreMemoryContention(HL, tStates: 1)
                PC = PC &- 2
            }
            HL = HL &+ 1
            break
        case 0xb3:		/* OTIR */
            var temp1: Byte
            var temp2: Byte
            
            coreMemoryContention(IR, tStates: 1)
            temp1 = coreMemoryRead(HL, tStates: 3)
            B = B &- 1	/* This does happen first, despite what the specs say */
            externalIOWrite(BC, value: temp1)
            
            HL = HL &+ 1
            temp2 = temp1 &+ L
            F = (temp1 & 0x80 != 0x00 ? FLAG_N : 0) | ((temp2 < temp1) ? FLAG_H | FLAG_C : 0) | (parityTable[ (temp2 & 0x07) ^ B ] != 0x00 ? FLAG_P : 0) | SZ35Table[B]
            
            if B != 0x00 {
                coreMemoryContention(BC, tStates: 1)
                coreMemoryContention(BC, tStates: 1)
                coreMemoryContention(BC, tStates: 1)
                coreMemoryContention(BC, tStates: 1)
                coreMemoryContention(BC, tStates: 1)
                PC = PC &- 2
            }
            break
        case 0xb8:		/* LDDR */
            var temp: Byte = coreMemoryRead(HL, tStates: 3)
            coreMemoryWrite(DE,value: temp)
            coreMemoryContention(DE, tStates: 1)
            coreMemoryContention(DE, tStates: 1)
            BC = BC &- 1
            temp = temp &+ A
            F = (F & (FLAG_C | FLAG_Z | FLAG_S)) | (BC != 0x00 ? FLAG_V : 0) |
                (temp & FLAG_3) | ((temp & 0x02) != 0x00 ? FLAG_5 : 0)
            if BC != 0x00 {
                coreMemoryContention(DE, tStates: 1)
                coreMemoryContention(DE, tStates: 1)
                coreMemoryContention(DE, tStates: 1)
                coreMemoryContention(DE, tStates: 1)
                coreMemoryContention(DE, tStates: 1)
                PC = PC &- 2
            }
            HL = HL &- 1
            DE = DE &- 1
            break
        case 0xb9:		/* CPDR */
            let value: Byte = coreMemoryRead(HL, tStates: 3)
            var temp = A &- value
            let lookup: Byte = ((A & 0x08) >> 3) | ((value & 0x08) >> 2) | ((Byte(temp & 0xff) & 0x08) >> 1)

            coreMemoryContention(HL, tStates: 1)
            coreMemoryContention(HL, tStates: 1)
            coreMemoryContention(HL, tStates: 1)
            coreMemoryContention(HL, tStates: 1)
            coreMemoryContention(HL, tStates: 1)
            BC = BC &- 1
            F = (F & FLAG_C) | (BC != 0x00 ? (FLAG_V | FLAG_N) : FLAG_N) | halfcarrySubTable[lookup] | (temp != 0x00 ? 0 : FLAG_Z) | (temp & FLAG_S)
            
            if F & FLAG_H == FLAG_H {
                temp = temp &- 1
            
            }
            F |= (temp & FLAG_3) | ((temp & 0x02) != 0x00 ? FLAG_5 : 0)
            
            if((F & (FLAG_V | FLAG_Z)) == FLAG_V) {
                coreMemoryContention(HL, tStates: 1)
                coreMemoryContention(HL, tStates: 1)
                coreMemoryContention(HL, tStates: 1)
                coreMemoryContention(HL, tStates: 1)
                coreMemoryContention(HL, tStates: 1)
                PC = PC &- 2
            }
            HL = HL &- 1
            break
        case 0xba:		/* INDR */
            var temp1: Byte
            var temp2: Byte
            
            coreMemoryContention(IR, tStates: 1)
            temp1 = externalIORead(BC)
            coreMemoryWrite(HL, value: temp1)
            
            B = B &- 1
            temp2 = temp1 &+ C &- 1
            F = (temp1 & 0x80 != 0x00 ? FLAG_N : 0) | ((temp2 < temp1) ? FLAG_H | FLAG_C : 0) | (parityTable[ (temp2 & 0x07) ^ B ] != 0x00 ? FLAG_P : 0) | SZ35Table[B]
            
            if B != 0x00 {
                coreMemoryContention(HL, tStates: 1)
                coreMemoryContention(HL, tStates: 1)
                coreMemoryContention(HL, tStates: 1)
                coreMemoryContention(HL, tStates: 1)
                coreMemoryContention(HL, tStates: 1)
                PC = PC &- 2
            }
            HL = HL &- 1

            break
        case 0xbb:		/* OTDR */
            var temp1: Byte
            var temp2: Byte
            
            coreMemoryContention(IR, tStates: 1)
            temp1 = coreMemoryRead(HL, tStates: 3)
            B  = B &- 1	/* This does happen first, despite what the specs say */
            externalIOWrite(BC, value : temp1)
            
            HL = HL &- 1
            temp2 = temp1 &+ L
            F = (temp1 & 0x80 != 0x00 ? FLAG_N : 0) | ((temp2 < temp1) ? FLAG_H | FLAG_C : 0) | (parityTable[ (temp2 & 0x07) ^ B ] != 0x00 ? FLAG_P : 0) | SZ35Table[B]
            
            if B != 0x00 {
                coreMemoryContention(BC, tStates: 1)
                coreMemoryContention(BC, tStates: 1)
                coreMemoryContention(BC, tStates: 1)
                coreMemoryContention(BC, tStates: 1)
                coreMemoryContention(BC, tStates: 1)
                PC = PC &- 2
            }
            break
        case 0xfb:		/* slttrap */
//            slt_trap(HL, A)
            break
        default:		/* All other opcodes are NOPD */
            break
        }
        
    }
    
}
