//
//  Opcodes_ED.swift
//  SwiftZ80
//
//  Created by Mike Daley on 02/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

extension SwiftZ80Core {
    
    mutating func lookupEDOpcode(opcode: Byte) {
        
        switch opcode {
        case 0x40:		/* IN B,(C) */
            Z80_IN(&B, port: BC)
            break
        case 0x41:		/* OUT (C),B */
            ioWriteAddress(BC, value: B)
            break
        case 0x42:		/* SBC HL,BC */
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
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
//            z80_retn()
            break
        case 0x46: fallthrough
        case 0x4e: fallthrough
        case 0x66: fallthrough
        case 0x6e:		/* IM 0 */
            IM = 0
            break
        case 0x47:		/* LD I,A */
            contend_read_no_mreq(IR, tStates: 1)
            I = A
            break
        case 0x48:		/* IN C,(C) */
            Z80_IN(&C, port: BC)
            break
        case 0x49:		/* OUT (C),C */
            ioWriteAddress(BC, value: C)
            break
        case 0x4a:		/* ADC HL,BC */
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            ADC16(BC)
            break
        case 0x4b:		/* LD BC,(nnnn) */
            LD16_RRNN(&C,regH: &B)
            break
        case 0x4f:		/* LD R,A */
            contend_read_no_mreq(IR, tStates: 1)
            /* Keep the RZX instruction counter right */
//            rzx_instructions_offset += (R - A)
            R = A
//            R7 = A
            break
        case 0x50:		/* IN D,(C) */
            Z80_IN(&D, port: BC)
            break
        case 0x51:		/* OUT (C),D */
            ioWriteAddress(BC, value: D)
            break
        case 0x52:		/* SBC HL,DE */
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
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
            contend_read_no_mreq(IR, tStates: 1)
            A = I
            F = (F & FLAG_C) | SZ35Table[A] | (IFF2 != 0x00 ? FLAG_V : 0)
            break
        case 0x58:		/* IN E,(C) */
            Z80_IN(&E, port: BC)
            break
        case 0x59:		/* OUT (C),E */
            ioWriteAddress(BC, value: E)
            break
        case 0x5a:		/* ADC HL,DE */
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
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
            contend_read_no_mreq(IR, tStates: 1)
            A = (R & 0x7f) | (R7 & 0x80)
            F = (F & FLAG_C) | SZ35Table[A] | (IFF2 != 0x00 ? FLAG_V : 0)
            break
        case 0x60:		/* IN H,(C) */
            Z80_IN(&H, port: BC)
            break
        case 0x61:		/* OUT (C),H */
            ioWriteAddress(BC, value: H)
            break
        case 0x62:		/* SBC HL,HL */
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            SBC16(HL)
            break
        case 0x63:		/* LD (nnnn),HL */
            LD16_NNRR(L,regH: H)
            break
        case 0x67:		/* RRD */
            let temp: Byte = internalReadAddress(HL, tStates: 3)
            contend_read_no_mreq(HL, tStates: 1)
            contend_read_no_mreq(HL, tStates: 1)
            contend_read_no_mreq(HL, tStates: 1)
            contend_read_no_mreq(HL, tStates: 1)
            internalWriteAddress(HL,  value: (A << 4) | (temp >> 4))
            A = (A & 0xf0) | (temp & 0x0f)
            F = (F & FLAG_C) | SZ35Table[A]
            break
        case 0x68:		/* IN L,(C) */
            Z80_IN(&L, port: BC)
            break
        case 0x69:		/* OUT (C),L */
            ioWriteAddress(BC, value: L)
            break
        case 0x6a:		/* ADC HL,HL */
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            ADC16(HL)
            break
        case 0x6b:		/* LD HL,(nnnn) */
            LD16_RRNN(&L,regH: &H)
            break
        case 0x6f:		/* RLD */
            let temp: Byte = internalReadAddress(HL, tStates: 3)
            contend_read_no_mreq(HL, tStates: 1)
            contend_read_no_mreq(HL, tStates: 1)
            contend_read_no_mreq(HL, tStates: 1)
            contend_read_no_mreq(HL, tStates: 1)
            ioWriteAddress(HL, value: (temp << 4) | (A & 0x0f))
            A = (A & 0xf0) | (temp >> 4)
            F = (F & FLAG_C) | SZ35Table[A]
            break
        case 0x70:		/* IN F,(C) */
//            {
//                libspectrum_byte bytetemp
//                Z80_IN(bytetemp, BC)
//            }
            break
        case 0x71:		/* OUT (C),0 */
            ioWriteAddress(BC, value: 0)
            break
        case 0x72:		/* SBC HL,SP */
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            SBC16(SP)
            break
        case 0x73:		/* LD (nnnn),SP */
            LD16_NNRR(SPl,regH: SPh)
            break
        case 0x78:		/* IN A,(C) */
            Z80_IN(&A, port: BC)
            break
        case 0x79:		/* OUT (C),A */
            ioWriteAddress(BC, value: A)
            break
        case 0x7a:		/* ADC HL,SP */
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            contend_read_no_mreq(IR, tStates: 1)
            ADC16(SP)
            break
        case 0x7b:		/* LD SP,(nnnn) */
            LD16_RRNN(&SPl,regH: &SPh)
            break
        case 0xa0:		/* LDI */
            var temp = internalReadAddress(HL, tStates: 3)
            BC = BC &- 1
            internalWriteAddress(DE,value: temp)
            contend_write_no_mreq(DE, tStates: 1)
            contend_write_no_mreq(DE, tStates: 1)
            DE = DE &+ 1
            HL = HL &+ 1
            temp += A
            F = (F & (FLAG_C | FLAG_Z | FLAG_S)) | (BC != 0x00 ? FLAG_V : 0) |
                (temp & FLAG_3) | ((temp & 0x02) != 0x00 ? FLAG_5 : 0)
            break
        case 0xa1:		/* CPI */
            let value: Byte = internalReadAddress(HL, tStates: 3)
            var temp: Byte = A - value
            let lookup: Byte = ((A & 0x08) >> 3) | ((value & 0x08) >> 2) | ((Byte(temp & 0xff) & 0x08) >> 1)
            
            contend_read_no_mreq(HL, tStates: 1)
            contend_read_no_mreq(HL, tStates: 1)
            contend_read_no_mreq(HL, tStates: 1)
            contend_read_no_mreq(HL, tStates: 1)
            contend_read_no_mreq(HL, tStates: 1)
            HL = HL &+ 1
            BC = BC &- 1
            F = (F & FLAG_C) | (BC != 0x00 ? (FLAG_V | FLAG_N) : FLAG_N) | halfcarrySubTable[lookup] | (temp != 0x00 ? 0 : FLAG_Z) | (temp & FLAG_S)
            if F & FLAG_H == FLAG_H {
                temp -= 1
            }
            F |= (temp & FLAG_3) | ((temp & 0x02) != 0x00 ? FLAG_5 : 0)
            break
        case 0xa2:		/* INI */
            var temp1: Byte
//            var temp2: Byte
			
            contend_read_no_mreq(IR, tStates: 1)
            temp1 = ioReadAddress(BC)
            ioWriteAddress(HL, value: temp1)
            
            B = B &- 1
            HL = HL &+ 1
			
			let signedC = Int16(bitPattern: Word(C) & 0xffff)
			let signedTemp1 = Int16(bitPattern: Word(temp1) & 0xffff)
			let signedTemp2 = signedTemp1 + signedC + 1
			
//            temp2 = temp1 + C + 1
			
            let t = Byte(signedTemp2 & 0x07 ^ Int16(B))
            F = (temp1 & 0x80 != 0x00 ? FLAG_N : 0) | (signedTemp2 < Int16(temp1) ? FLAG_H | FLAG_C : 0) | (parityTable[ t ] != 0x00 ? FLAG_P : 0) | SZ35Table[B]
            break
        case 0xa3:		/* OUTI */
            var temp1: Byte
//            var temp2: Byte
			
            contend_read_no_mreq(IR, tStates: 1)
            temp1 = internalReadAddress(HL, tStates: 3)
            B = B &- 1	/* This does happen first, despite what the specs say */
            ioWriteAddress(BC, value: temp1)
            
            HL = HL &+ 1

			let signedL = Int16(bitPattern: Word(L) & 0xffff)
			let signedTemp1 = Int16(bitPattern: Word(temp1) & 0xffff)
			let signedTemp2 = signedTemp1 + signedL + 1
			
			
//			temp2 = temp1 + L
			let t = Byte(signedTemp2 & 0x07 ^ Int16(B))
            F = (temp1 & 0x80 != 0x00 ? FLAG_N : 0) | (signedTemp2 < Int16(temp1) ? FLAG_H | FLAG_C : 0) | (parityTable[ t ] != 0x00 ? FLAG_P : 0) | SZ35Table[B]
            break
        case 0xa8:		/* LDD */
            var temp = internalReadAddress(HL, tStates: 3)
            BC = BC &- 1
            internalWriteAddress(DE, value: temp)
            contend_write_no_mreq(DE, tStates: 1)
            contend_write_no_mreq(DE, tStates: 1)
            DE = DE &- 1
            HL = HL &- 1
            temp = temp &+ A
            F = (F & (FLAG_C | FLAG_Z | FLAG_S)) | (BC != 0x00 ? FLAG_V : 0) |
                (temp & FLAG_3) | ((temp & 0x02) != 0x00 ? FLAG_5 : 0)
            break
        case 0xa9:		/* CPD */
            let value: Byte = internalReadAddress(HL, tStates: 3)
            var temp: Byte = A &- value
            let lookup: Byte = ((A & 0x08) >> 3) | ((value & 0x08) >> 2) | ((Byte(temp & 0xff) & 0x08) >> 1)
            contend_read_no_mreq(HL, tStates: 1)
            contend_read_no_mreq(HL, tStates: 1)
            contend_read_no_mreq(HL, tStates: 1)
            contend_read_no_mreq(HL, tStates: 1)
            contend_read_no_mreq(HL, tStates: 1)
            HL = HL &- 1
            BC = BC &- 1
            F = (F & FLAG_C) | (BC != 0x00 ? (FLAG_V | FLAG_N) : FLAG_N) | halfcarrySubTable[lookup] | (temp != 0x00 ? 0 : FLAG_Z) | (temp & FLAG_S)
            if F & FLAG_H == FLAG_H {
                temp -= 1
            }
            F |= (temp & FLAG_3) | ((temp & 0x02) != 0x00 ? FLAG_5 : 0)
            break
        case 0xaa:		/* IND */
            var temp1: Byte
//            var temp2: Byte
			
            contend_read_no_mreq(IR, tStates: 1)
            temp1 = ioReadAddress(BC)
            internalWriteAddress(HL, value: temp1)
            
            B = B &- 1
            HL = HL &- 1
			
			let signedC = Int16(bitPattern: Word(C) & 0xffff)
			let signedTemp1 = Int16(bitPattern: Word(temp1) & 0xffff)
			let signedTemp2 = signedTemp1 + signedC + 1

//            temp2 = temp1 + C - 1
			
			let t = Byte(signedTemp2 & 0x07 ^ Int16(B))
			F = (temp1 & 0x80 != 0x00 ? FLAG_N : 0) | (signedTemp2 < Int16(temp1) ? FLAG_H | FLAG_C : 0) | (parityTable[ t ] != 0x00 ? FLAG_P : 0) | SZ35Table[B]
			
            break
        case 0xab:		/* OUTD */
            var temp1: Byte
//            var temp2: Byte
			
            contend_read_no_mreq(IR, tStates: 1)
            temp1 = internalReadAddress(HL, tStates: 3)
            B = B &- 1	/* This does happen first, despite what the specs say */
            ioWriteAddress(BC, value: temp1)
            
            HL = HL &- 1
			let signedL = Int16(bitPattern: Word(L) & 0xffff)
			let signedTemp1 = Int16(bitPattern: Word(temp1) & 0xffff)
			let signedTemp2 = signedTemp1 + signedL + 1
			let t = Byte(signedTemp2 & 0x07 ^ Int16(B))
			F = (temp1 & 0x80 != 0x00 ? FLAG_N : 0) | (signedTemp2 < Int16(temp1) ? FLAG_H | FLAG_C : 0) | (parityTable[ t ] != 0x00 ? FLAG_P : 0) | SZ35Table[B]
			
            break
        case 0xb0:		/* LDIR */
            var temp: Byte = internalReadAddress(HL, tStates: 3)
            internalWriteAddress(DE, value: temp)
            contend_write_no_mreq(DE, tStates: 1)
            contend_write_no_mreq(DE, tStates: 1)
            BC = BC &- 1
            temp = temp &+ A
            F = (F & (FLAG_C | FLAG_Z | FLAG_S)) | (BC != 0x00 ? FLAG_V : 0) |
                (temp & FLAG_3) | ((temp & 0x02) != 0x00 ? FLAG_5 : 0)
            if BC != 0x00 {
                contend_write_no_mreq(DE, tStates: 1)
                contend_write_no_mreq(DE, tStates: 1)
                contend_write_no_mreq(DE, tStates: 1)
                contend_write_no_mreq(DE, tStates: 1)
                contend_write_no_mreq(DE, tStates: 1)
                PC -= 2
            }
            HL = HL &+ 1
            DE = DE &+ 1
            break
        case 0xb1:		/* CPIR */
            let value: Byte = internalReadAddress(HL, tStates: 3)
            var temp: Byte = A - value
            let lookup: Byte = ((A & 0x08) >> 3) | ((value & 0x08) >> 2) | ((Byte(temp & 0xff) & 0x08) >> 1)

            contend_read_no_mreq(HL, tStates: 1)
            contend_read_no_mreq(HL, tStates: 1)
            contend_read_no_mreq(HL, tStates: 1)
            contend_read_no_mreq(HL, tStates: 1)
            contend_read_no_mreq(HL, tStates: 1)
            
            BC = BC &- 1
            
            F = (F & FLAG_C) | (BC != 0x00 ? (FLAG_V | FLAG_N) : FLAG_N) | halfcarrySubTable[lookup] | (temp != 0x00 ? 0 : FLAG_Z) | (temp & FLAG_S)
            
            if F & FLAG_H == FLAG_H {
                temp -= 1
            }
            
            F |= (temp & FLAG_3) | ((temp & 0x02) != 0x00 ? FLAG_5 : 0)
            
            if((F & (FLAG_V | FLAG_Z)) == FLAG_V) {
                contend_read_no_mreq(HL, tStates: 1)
                contend_read_no_mreq(HL, tStates: 1)
                contend_read_no_mreq(HL, tStates: 1)
                contend_read_no_mreq(HL, tStates: 1)
                contend_read_no_mreq(HL, tStates: 1)
                PC -= 2
            }
            HL = HL &+ 1
            break
        case 0xb2:		/* INIR */
            var temp1: Byte
            var temp2: Byte
            
            contend_read_no_mreq(IR, tStates: 1)
            temp1 = ioReadAddress(BC)
            internalWriteAddress(HL, value: temp1)
            
            B = B &- 1
            temp2 = temp1 + C + 1
            F = (temp1 & 0x80 != 0x00 ? FLAG_N : 0) | ((temp2 < temp1) ? FLAG_H | FLAG_C : 0) | (parityTable[ (temp2 & 0x07) ^ B ] != 0x00 ? FLAG_P : 0) | SZ35Table[B]
            
            if B != 0x00 {
                contend_write_no_mreq(HL, tStates: 1)
                contend_write_no_mreq(HL, tStates: 1)
                contend_write_no_mreq(HL, tStates: 1)
                contend_write_no_mreq(HL, tStates: 1)
                contend_write_no_mreq(HL, tStates: 1)
                PC -= 2
            }
            HL = HL &+ 1
            break
        case 0xb3:		/* OTIR */
            var temp1: Byte
            var temp2: Byte
            
            contend_read_no_mreq(IR, tStates: 1)
            temp1 = internalReadAddress(HL, tStates: 3)
            B = B &- 1	/* This does happen first, despite what the specs say */
            ioWriteAddress(BC, value: temp1)
            
            HL = HL &+ 1
            temp2 = temp1 &+ L
            F = (temp1 & 0x80 != 0x00 ? FLAG_N : 0) | ((temp2 < temp1) ? FLAG_H | FLAG_C : 0) | (parityTable[ (temp2 & 0x07) ^ B ] != 0x00 ? FLAG_P : 0) | SZ35Table[B]
            
            if B != 0x00 {
                contend_read_no_mreq(BC, tStates: 1)
                contend_read_no_mreq(BC, tStates: 1)
                contend_read_no_mreq(BC, tStates: 1)
                contend_read_no_mreq(BC, tStates: 1)
                contend_read_no_mreq(BC, tStates: 1)
                PC -= 2
            }
            break
        case 0xb8:		/* LDDR */
            var temp: Byte = internalReadAddress(HL, tStates: 3)
            internalWriteAddress(DE,value: temp)
            contend_write_no_mreq(DE, tStates: 1)
            contend_write_no_mreq(DE, tStates: 1)
            BC = BC &- 1
            temp = temp &+ A
            F = (F & (FLAG_C | FLAG_Z | FLAG_S)) | (BC != 0x00 ? FLAG_V : 0) |
                (temp & FLAG_3) | ((temp & 0x02) != 0x00 ? FLAG_5 : 0)
            if BC != 0x00 {
                contend_write_no_mreq(DE, tStates: 1)
                contend_write_no_mreq(DE, tStates: 1)
                contend_write_no_mreq(DE, tStates: 1)
                contend_write_no_mreq(DE, tStates: 1)
                contend_write_no_mreq(DE, tStates: 1)
                PC -= 2
            }
            HL = HL &- 1
            DE = DE &- 1
            break
        case 0xb9:		/* CPDR */
            let value: Byte = internalReadAddress(HL, tStates: 3)
            var temp = A - value
            let lookup: Byte = ((A & 0x08) >> 3) | ((value & 0x08) >> 2) | ((Byte(temp & 0xff) & 0x08) >> 1)

            contend_read_no_mreq(HL, tStates: 1)
            contend_read_no_mreq(HL, tStates: 1)
            contend_read_no_mreq(HL, tStates: 1)
            contend_read_no_mreq(HL, tStates: 1)
            contend_read_no_mreq(HL, tStates: 1)
            BC = BC &- 1
            F = (F & FLAG_C) | (BC != 0x00 ? (FLAG_V | FLAG_N) : FLAG_N) | halfcarrySubTable[lookup] | (temp != 0x00 ? 0 : FLAG_Z) | (temp & FLAG_S)
            
            if F & FLAG_H == FLAG_H {
                temp -= 1
            
            }
            F |= (temp & FLAG_3) | ((temp & 0x02) != 0x00 ? FLAG_5 : 0)
            
            if((F & (FLAG_V | FLAG_Z)) == FLAG_V) {
                contend_read_no_mreq(HL, tStates: 1)
                contend_read_no_mreq(HL, tStates: 1)
                contend_read_no_mreq(HL, tStates: 1)
                contend_read_no_mreq(HL, tStates: 1)
                contend_read_no_mreq(HL, tStates: 1)
                PC -= 2
            }
            HL = HL &- 1
            break
        case 0xba:		/* INDR */
            var temp1: Byte
            var temp2: Byte
            
            contend_read_no_mreq(IR, tStates: 1)
            temp1 = ioReadAddress(BC)
            internalWriteAddress(HL, value: temp1)
            
            B = B &- 1
            temp2 = temp1 + C - 1
            F = (temp1 & 0x80 != 0x00 ? FLAG_N : 0) | ((temp2 < temp1) ? FLAG_H | FLAG_C : 0) | (parityTable[ (temp2 & 0x07) ^ B ] != 0x00 ? FLAG_P : 0) | SZ35Table[B]
            
            if B != 0x00 {
                contend_write_no_mreq(HL, tStates: 1)
                contend_write_no_mreq(HL, tStates: 1)
                contend_write_no_mreq(HL, tStates: 1)
                contend_write_no_mreq(HL, tStates: 1)
                contend_write_no_mreq(HL, tStates: 1)
                PC -= 2
            }
            HL = HL &- 1

            break
        case 0xbb:		/* OTDR */
            var temp1: Byte
            var temp2: Byte
            
            contend_read_no_mreq(IR, tStates: 1)
            temp1 = internalReadAddress(HL, tStates: 3)
            B  = B &- 1	/* This does happen first, despite what the specs say */
            ioWriteAddress(BC, value : temp1)
            
            HL = HL &- 1
            temp2 = temp1 &+ L
            F = (temp1 & 0x80 != 0x00 ? FLAG_N : 0) | ((temp2 < temp1) ? FLAG_H | FLAG_C : 0) | (parityTable[ (temp2 & 0x07) ^ B ] != 0x00 ? FLAG_P : 0) | SZ35Table[B]
            
            if B != 0x00 {
                contend_read_no_mreq(BC, tStates: 1)
                contend_read_no_mreq(BC, tStates: 1)
                contend_read_no_mreq(BC, tStates: 1)
                contend_read_no_mreq(BC, tStates: 1)
                contend_read_no_mreq(BC, tStates: 1)
                PC -= 2
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
