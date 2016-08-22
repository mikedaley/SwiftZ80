//
//  Opcodes_DDFDCB.swift
//  SwiftZ80
//
//  Created by Mike Daley on 02/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

extension SwiftZ80Core {
    
    func lookupDDFDCBOpcode(opcode: Byte, address: Word) {
        
        let tempaddr: Word = address
        
        switch opcode {
            
        case 0x00:		/* LD B,RLC (REGISTER+dd) */
            B = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RLC(&B)
            coreMemoryWrite(tempaddr, value: B)
            break
        case 0x01:		/* LD C,RLC (REGISTER+dd) */
            C = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RLC(&C)
            coreMemoryWrite(tempaddr, value: C)
            break
        case 0x02:		/* LD D,RLC (REGISTER+dd) */
            D = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RLC(&D)
            coreMemoryWrite(tempaddr, value: D)
            break
        case 0x03:		/* LD E,RLC (REGISTER+dd) */
            E=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RLC(&E)
            coreMemoryWrite(tempaddr, value: E)
            break
        case 0x04:		/* LD H,RLC (REGISTER+dd) */
            H=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RLC(&H)
            coreMemoryWrite(tempaddr, value: H)
            break
        case 0x05:		/* LD L,RLC (REGISTER+dd) */
            L=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RLC(&L)
            coreMemoryWrite(tempaddr, value: L)
            break
        case 0x06:		/* RLC (REGISTER+dd) */
            var bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RLC(&bytetemp)
            coreMemoryWrite(tempaddr,value: bytetemp)
            break
        case 0x07:		/* LD A,RLC (REGISTER+dd) */
            A = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RLC(&A)
            coreMemoryWrite(tempaddr, value: A)
            break
        case 0x08:		/* LD B,RRC (REGISTER+dd) */
            B=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RRC(&B)
            coreMemoryWrite(tempaddr, value: B)
            break
        case 0x09:		/* LD C,RRC (REGISTER+dd) */
            C=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RRC(&C)
            coreMemoryWrite(tempaddr, value: C)
            break
        case 0x0a:		/* LD D,RRC (REGISTER+dd) */
            D=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RRC(&D)
            coreMemoryWrite(tempaddr, value: D)
            break
        case 0x0b:		/* LD E,RRC (REGISTER+dd) */
            E=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RRC(&E)
            coreMemoryWrite(tempaddr, value: E)
            break
        case 0x0c:		/* LD H,RRC (REGISTER+dd) */
            H=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RRC(&H)
            coreMemoryWrite(tempaddr, value: H)
            break
        case 0x0d:		/* LD L,RRC (REGISTER+dd) */
            L=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RRC(&L)
            coreMemoryWrite(tempaddr, value: L)
            break
        case 0x0e:		/* RRC (REGISTER+dd) */
            var bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RRC(&bytetemp)
            coreMemoryWrite(tempaddr, value: bytetemp)
            break
        case 0x0f:		/* LD A,RRC (REGISTER+dd) */
            A=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RRC(&A)
            coreMemoryWrite(tempaddr, value: A)
            break
        case 0x10:		/* LD B,RL (REGISTER+dd) */
            B=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RL(&B)
            coreMemoryWrite(tempaddr, value: B)
            break
        case 0x11:		/* LD C,RL (REGISTER+dd) */
            C=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RL(&C)
            coreMemoryWrite(tempaddr, value: C)
            break
        case 0x12:		/* LD D,RL (REGISTER+dd) */
            D=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RL(&D)
            coreMemoryWrite(tempaddr, value: D)
            break
        case 0x13:		/* LD E,RL (REGISTER+dd) */
            E=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RL(&E)
            coreMemoryWrite(tempaddr, value: E)
            break
        case 0x14:		/* LD H,RL (REGISTER+dd) */
            H=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RL(&H)
            coreMemoryWrite(tempaddr, value: H)
            break
        case 0x15:		/* LD L,RL (REGISTER+dd) */
            L=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RL(&L)
            coreMemoryWrite(tempaddr, value: L)
            break
        case 0x16:		/* RL (REGISTER+dd) */
            var bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RL(&bytetemp)
            coreMemoryWrite(tempaddr, value: bytetemp)
            break
        case 0x17:		/* LD A,RL (REGISTER+dd) */
            A=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RL(&A)
            coreMemoryWrite(tempaddr, value: A)
            break
        case 0x18:		/* LD B,RR (REGISTER+dd) */
            B=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RR(&B)
            coreMemoryWrite(tempaddr, value: B)
            break
        case 0x19:		/* LD C,RR (REGISTER+dd) */
            C=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RR(&C)
            coreMemoryWrite(tempaddr, value: C)
            break
        case 0x1a:		/* LD D,RR (REGISTER+dd) */
            D=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RR(&D)
            coreMemoryWrite(tempaddr, value: D)
            break
        case 0x1b:		/* LD E,RR (REGISTER+dd) */
            E=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RR(&E)
            coreMemoryWrite(tempaddr, value: E)
            break
        case 0x1c:		/* LD H,RR (REGISTER+dd) */
            H=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RR(&H)
            coreMemoryWrite(tempaddr, value: H)
            break
        case 0x1d:		/* LD L,RR (REGISTER+dd) */
            L=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RR(&L)
            coreMemoryWrite(tempaddr, value: L)
            break
        case 0x1e:		/* RR (REGISTER+dd) */
            var bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RR(&bytetemp)
            coreMemoryWrite(tempaddr, value: bytetemp)
            break
        case 0x1f:		/* LD A,RR (REGISTER+dd) */
            A=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            RR(&A)
            coreMemoryWrite(tempaddr, value: A)
            break
        case 0x20:		/* LD B,SLA (REGISTER+dd) */
            B=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SLA(&B)
            coreMemoryWrite(tempaddr, value: B)
            break
        case 0x21:		/* LD C,SLA (REGISTER+dd) */
            C=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SLA(&C)
            coreMemoryWrite(tempaddr, value: C)
            break
        case 0x22:		/* LD D,SLA (REGISTER+dd) */
            D=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SLA(&D)
            coreMemoryWrite(tempaddr, value: D)
            break
        case 0x23:		/* LD E,SLA (REGISTER+dd) */
            E=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SLA(&E)
            coreMemoryWrite(tempaddr, value: E)
            break
        case 0x24:		/* LD H,SLA (REGISTER+dd) */
            H=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SLA(&H)
            coreMemoryWrite(tempaddr, value: H)
            break
        case 0x25:		/* LD L,SLA (REGISTER+dd) */
            L=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SLA(&L)
            coreMemoryWrite(tempaddr, value: L)
            break
        case 0x26:		/* SLA (REGISTER+dd) */
            var bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SLA(&bytetemp)
            coreMemoryWrite(tempaddr, value: bytetemp)
            break
        case 0x27:		/* LD A,SLA (REGISTER+dd) */
            A=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SLA(&A)
            coreMemoryWrite(tempaddr, value: A)
            break
        case 0x28:		/* LD B,SRA (REGISTER+dd) */
            B=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SRA(&B)
            coreMemoryWrite(tempaddr, value: B)
            break
        case 0x29:		/* LD C,SRA (REGISTER+dd) */
            C=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SRA(&C)
            coreMemoryWrite(tempaddr, value: C)
            break
        case 0x2a:		/* LD D,SRA (REGISTER+dd) */
            D=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SRA(&D)
            coreMemoryWrite(tempaddr, value: D)
            break
        case 0x2b:		/* LD E,SRA (REGISTER+dd) */
            E=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SRA(&E)
            coreMemoryWrite(tempaddr, value: E)
            break
        case 0x2c:		/* LD H,SRA (REGISTER+dd) */
            H=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SRA(&H)
            coreMemoryWrite(tempaddr, value: H)
            break
        case 0x2d:		/* LD L,SRA (REGISTER+dd) */
            L=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SRA(&L)
            coreMemoryWrite(tempaddr, value: L)
            break
        case 0x2e:		/* SRA (REGISTER+dd) */
            var bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SRA(&bytetemp)
            coreMemoryWrite(tempaddr, value: bytetemp)
            break
        case 0x2f:		/* LD A,SRA (REGISTER+dd) */
            A=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SRA(&A)
            coreMemoryWrite(tempaddr, value: A)
            break
        case 0x30:		/* LD B,SLL (REGISTER+dd) */
            B=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SLL(&B)
            coreMemoryWrite(tempaddr, value: B)
            break
        case 0x31:		/* LD C,SLL (REGISTER+dd) */
            C=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SLL(&C)
            coreMemoryWrite(tempaddr, value: C)
            break
        case 0x32:		/* LD D,SLL (REGISTER+dd) */
            D=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SLL(&D)
            coreMemoryWrite(tempaddr, value: D)
            break
        case 0x33:		/* LD E,SLL (REGISTER+dd) */
            E=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SLL(&E)
            coreMemoryWrite(tempaddr, value: E)
            break
        case 0x34:		/* LD H,SLL (REGISTER+dd) */
            H=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SLL(&H)
            coreMemoryWrite(tempaddr, value: H)
            break
        case 0x35:		/* LD L,SLL (REGISTER+dd) */
            L=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SLL(&L)
            coreMemoryWrite(tempaddr, value: L)
            break
        case 0x36:		/* SLL (REGISTER+dd) */
            var bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SLL(&bytetemp)
            coreMemoryWrite(tempaddr, value: bytetemp)
            break
        case 0x37:		/* LD A,SLL (REGISTER+dd) */
            A=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SLL(&A)
            coreMemoryWrite(tempaddr, value: A)
            break
        case 0x38:		/* LD B,SRL (REGISTER+dd) */
            B=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SRL(&B)
            coreMemoryWrite(tempaddr, value: B)
            break
        case 0x39:		/* LD C,SRL (REGISTER+dd) */
            C=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SRL(&C)
            coreMemoryWrite(tempaddr, value: C)
            break
        case 0x3a:		/* LD D,SRL (REGISTER+dd) */
            D=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SRL(&D)
            coreMemoryWrite(tempaddr, value: D)
            break
        case 0x3b:		/* LD E,SRL (REGISTER+dd) */
            E=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SRL(&E)
            coreMemoryWrite(tempaddr, value: E)
            break
        case 0x3c:		/* LD H,SRL (REGISTER+dd) */
            H=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SRL(&H)
            coreMemoryWrite(tempaddr, value: H)
            break
        case 0x3d:		/* LD L,SRL (REGISTER+dd) */
            L=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SRL(&L)
            coreMemoryWrite(tempaddr, value: L)
            break
        case 0x3e:		/* SRL (REGISTER+dd) */
            var bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SRL(&bytetemp)
            coreMemoryWrite(tempaddr, value: bytetemp)
            break
        case 0x3f:		/* LD A,SRL (REGISTER+dd) */
            A=coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            SRL(&A)
            coreMemoryWrite(tempaddr, value: A)
            break
        case 0x40: fallthrough
        case 0x41: fallthrough
        case 0x42: fallthrough
        case 0x43: fallthrough
        case 0x44: fallthrough
        case 0x45: fallthrough
        case 0x46: fallthrough
        case 0x47:		/* BIT 0,(REGISTER+dd) */
            let bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            BIT_I(0, value: bytetemp, address: tempaddr)
            break
        case 0x48: fallthrough
        case 0x49: fallthrough
        case 0x4a: fallthrough
        case 0x4b: fallthrough
        case 0x4c: fallthrough
        case 0x4d: fallthrough
        case 0x4e: fallthrough
        case 0x4f:		/* BIT 1,(REGISTER+dd) */
            let bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            BIT_I(1, value: bytetemp, address: tempaddr)
            break
        case 0x50: fallthrough
        case 0x51: fallthrough
        case 0x52: fallthrough
        case 0x53: fallthrough
        case 0x54: fallthrough
        case 0x55: fallthrough
        case 0x56: fallthrough
        case 0x57:		/* BIT 2,(REGISTER+dd) */
            let bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            BIT_I(2, value: bytetemp, address: tempaddr)
            break
        case 0x58: fallthrough
        case 0x59: fallthrough
        case 0x5a: fallthrough
        case 0x5b: fallthrough
        case 0x5c: fallthrough
        case 0x5d: fallthrough
        case 0x5e: fallthrough
        case 0x5f:		/* BIT 3,(REGISTER+dd) */
            let bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            BIT_I(3, value: bytetemp, address: tempaddr)
            break
        case 0x60: fallthrough
        case 0x61: fallthrough
        case 0x62: fallthrough
        case 0x63: fallthrough
        case 0x64: fallthrough
        case 0x65: fallthrough
        case 0x66: fallthrough
        case 0x67:		/* BIT 4,(REGISTER+dd) */
            let bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            BIT_I(4, value: bytetemp, address: tempaddr)
            break
        case 0x68: fallthrough
        case 0x69: fallthrough
        case 0x6a: fallthrough
        case 0x6b: fallthrough
        case 0x6c: fallthrough
        case 0x6d: fallthrough
        case 0x6e: fallthrough
        case 0x6f:		/* BIT 5,(REGISTER+dd) */
            let bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            BIT_I(5, value: bytetemp, address: tempaddr)
            break
        case 0x70: fallthrough
        case 0x71: fallthrough
        case 0x72: fallthrough
        case 0x73: fallthrough
        case 0x74: fallthrough
        case 0x75: fallthrough
        case 0x76: fallthrough
        case 0x77:		/* BIT 6,(REGISTER+dd) */
            let bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            BIT_I(6, value: bytetemp, address: tempaddr)
            break
        case 0x78: fallthrough
        case 0x79: fallthrough
        case 0x7a: fallthrough
        case 0x7b: fallthrough
        case 0x7c: fallthrough
        case 0x7d: fallthrough
        case 0x7e: fallthrough
        case 0x7f:		/* BIT 7,(REGISTER+dd) */
            let bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            BIT_I(7, value: bytetemp, address: tempaddr)
            break
        case 0x80:		/* LD B,RES 0,(REGISTER+dd) */
            B = coreMemoryRead(tempaddr, tStates: 3) & 0xfe
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: B)
            break
        case 0x81:		/* LD C,RES 0,(REGISTER+dd) */
            C = coreMemoryRead(tempaddr, tStates: 3) & 0xfe
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: C)
            break
        case 0x82:		/* LD D,RES 0,(REGISTER+dd) */
            D = coreMemoryRead(tempaddr, tStates: 3) & 0xfe
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: D)
            break
        case 0x83:		/* LD E,RES 0,(REGISTER+dd) */
            E = coreMemoryRead(tempaddr, tStates: 3) & 0xfe
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: E)
            break
        case 0x84:		/* LD H,RES 0,(REGISTER+dd) */
            H = coreMemoryRead(tempaddr, tStates: 3) & 0xfe
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: H)
            break
        case 0x85:		/* LD L,RES 0,(REGISTER+dd) */
            L = coreMemoryRead(tempaddr, tStates: 3) & 0xfe
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: L)
            break
        case 0x86:		/* RES 0,(REGISTER+dd) */
            let bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: bytetemp & 0xfe)
            break
        case 0x87:		/* LD A,RES 0,(REGISTER+dd) */
            A = coreMemoryRead(tempaddr, tStates: 3) & 0xfe
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: A)
            break
        case 0x88:		/* LD B,RES 1,(REGISTER+dd) */
            B = coreMemoryRead(tempaddr, tStates: 3) & 0xfd
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: B)
            break
        case 0x89:		/* LD C,RES 1,(REGISTER+dd) */
            C = coreMemoryRead(tempaddr, tStates: 3) & 0xfd
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: C)
            break
        case 0x8a:		/* LD D,RES 1,(REGISTER+dd) */
            D = coreMemoryRead(tempaddr, tStates: 3) & 0xfd
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: D)
            break
        case 0x8b:		/* LD E,RES 1,(REGISTER+dd) */
            E = coreMemoryRead(tempaddr, tStates: 3) & 0xfd
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: E)
            break
        case 0x8c:		/* LD H,RES 1,(REGISTER+dd) */
            H = coreMemoryRead(tempaddr, tStates: 3) & 0xfd
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: H)
            break
        case 0x8d:		/* LD L,RES 1,(REGISTER+dd) */
            L = coreMemoryRead(tempaddr, tStates: 3) & 0xfd
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: L)
            break
        case 0x8e:		/* RES 1,(REGISTER+dd) */
            let bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: bytetemp & 0xfd)
            break
        case 0x8f:		/* LD A,RES 1,(REGISTER+dd) */
            A = coreMemoryRead(tempaddr, tStates: 3) & 0xfd
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: A)
            break
        case 0x90:		/* LD B,RES 2,(REGISTER+dd) */
            B = coreMemoryRead(tempaddr, tStates: 3) & 0xfb
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: B)
            break
        case 0x91:		/* LD C,RES 2,(REGISTER+dd) */
            C = coreMemoryRead(tempaddr, tStates: 3) & 0xfb
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: C)
            break
        case 0x92:		/* LD D,RES 2,(REGISTER+dd) */
            D = coreMemoryRead(tempaddr, tStates: 3) & 0xfb
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: D)
            break
        case 0x93:		/* LD E,RES 2,(REGISTER+dd) */
            E = coreMemoryRead(tempaddr, tStates: 3) & 0xfb
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: E)
            break
        case 0x94:		/* LD H,RES 2,(REGISTER+dd) */
            H = coreMemoryRead(tempaddr, tStates: 3) & 0xfb
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: H)
            break
        case 0x95:		/* LD L,RES 2,(REGISTER+dd) */
            L = coreMemoryRead(tempaddr, tStates: 3) & 0xfb
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: L)
            break
        case 0x96:		/* RES 2,(REGISTER+dd) */
            let bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: bytetemp & 0xfb)
            break
        case 0x97:		/* LD A,RES 2,(REGISTER+dd) */
            A = coreMemoryRead(tempaddr, tStates: 3) & 0xfb
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: A)
            break
        case 0x98:		/* LD B,RES 3,(REGISTER+dd) */
            B = coreMemoryRead(tempaddr, tStates: 3) & 0xf7
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: B)
            break
        case 0x99:		/* LD C,RES 3,(REGISTER+dd) */
            C = coreMemoryRead(tempaddr, tStates: 3) & 0xf7
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: C)
            break
        case 0x9a:		/* LD D,RES 3,(REGISTER+dd) */
            D = coreMemoryRead(tempaddr, tStates: 3) & 0xf7
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: D)
            break
        case 0x9b:		/* LD E,RES 3,(REGISTER+dd) */
            E = coreMemoryRead(tempaddr, tStates: 3) & 0xf7
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: E)
            break
        case 0x9c:		/* LD H,RES 3,(REGISTER+dd) */
            H = coreMemoryRead(tempaddr, tStates: 3) & 0xf7
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: H)
            break
        case 0x9d:		/* LD L,RES 3,(REGISTER+dd) */
            L = coreMemoryRead(tempaddr, tStates: 3) & 0xf7
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: L)
            break
        case 0x9e:		/* RES 3,(REGISTER+dd) */
            let bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: bytetemp & 0xf7)
            break
        case 0x9f:		/* LD A,RES 3,(REGISTER+dd) */
            A = coreMemoryRead(tempaddr, tStates: 3) & 0xf7
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: A)
            break
        case 0xa0:		/* LD B,RES 4,(REGISTER+dd) */
            B = coreMemoryRead(tempaddr, tStates: 3) & 0xef
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: B)
            break
        case 0xa1:		/* LD C,RES 4,(REGISTER+dd) */
            C = coreMemoryRead(tempaddr, tStates: 3) & 0xef
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: C)
            break
        case 0xa2:		/* LD D,RES 4,(REGISTER+dd) */
            D = coreMemoryRead(tempaddr, tStates: 3) & 0xef
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: D)
            break
        case 0xa3:		/* LD E,RES 4,(REGISTER+dd) */
            E = coreMemoryRead(tempaddr, tStates: 3) & 0xef
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: E)
            break
        case 0xa4:		/* LD H,RES 4,(REGISTER+dd) */
            H = coreMemoryRead(tempaddr, tStates: 3) & 0xef
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: H)
            break
        case 0xa5:		/* LD L,RES 4,(REGISTER+dd) */
            L = coreMemoryRead(tempaddr, tStates: 3) & 0xef
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: L)
            break
        case 0xa6:		/* RES 4,(REGISTER+dd) */
            let bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: bytetemp & 0xef)
            break
        case 0xa7:		/* LD A,RES 4,(REGISTER+dd) */
            A = coreMemoryRead(tempaddr, tStates: 3) & 0xef
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: A)
            break
        case 0xa8:		/* LD B,RES 5,(REGISTER+dd) */
            B = coreMemoryRead(tempaddr, tStates: 3) & 0xdf
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: B)
            break
        case 0xa9:		/* LD C,RES 5,(REGISTER+dd) */
            C = coreMemoryRead(tempaddr, tStates: 3) & 0xdf
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: C)
            break
        case 0xaa:		/* LD D,RES 5,(REGISTER+dd) */
            D = coreMemoryRead(tempaddr, tStates: 3) & 0xdf
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: D)
            break
        case 0xab:		/* LD E,RES 5,(REGISTER+dd) */
            E = coreMemoryRead(tempaddr, tStates: 3) & 0xdf
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: E)
            break
        case 0xac:		/* LD H,RES 5,(REGISTER+dd) */
            H = coreMemoryRead(tempaddr, tStates: 3) & 0xdf
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: H)
            break
        case 0xad:		/* LD L,RES 5,(REGISTER+dd) */
            L = coreMemoryRead(tempaddr, tStates: 3) & 0xdf
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: L)
            break
        case 0xae:		/* RES 5,(REGISTER+dd) */
            let bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: bytetemp & 0xdf)
            break
        case 0xaf:		/* LD A,RES 5,(REGISTER+dd) */
            A = coreMemoryRead(tempaddr, tStates: 3) & 0xdf
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: A)
            break
        case 0xb0:		/* LD B,RES 6,(REGISTER+dd) */
            B = coreMemoryRead(tempaddr, tStates: 3) & 0xbf
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: B)
            break
        case 0xb1:		/* LD C,RES 6,(REGISTER+dd) */
            C = coreMemoryRead(tempaddr, tStates: 3) & 0xbf
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: C)
            break
        case 0xb2:		/* LD D,RES 6,(REGISTER+dd) */
            D = coreMemoryRead(tempaddr, tStates: 3) & 0xbf
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: D)
            break
        case 0xb3:		/* LD E,RES 6,(REGISTER+dd) */
            E = coreMemoryRead(tempaddr, tStates: 3) & 0xbf
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: E)
            break
        case 0xb4:		/* LD H,RES 6,(REGISTER+dd) */
            H = coreMemoryRead(tempaddr, tStates: 3) & 0xbf
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: H)
            break
        case 0xb5:		/* LD L,RES 6,(REGISTER+dd) */
            L = coreMemoryRead(tempaddr, tStates: 3) & 0xbf
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: L)
            break
        case 0xb6:		/* RES 6,(REGISTER+dd) */
            let bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: bytetemp & 0xbf)
            break
        case 0xb7:		/* LD A,RES 6,(REGISTER+dd) */
            A = (coreMemoryRead(tempaddr, tStates: 3) & 0xbf)
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: A)
            break
        case 0xb8:		/* LD B,RES 7,(REGISTER+dd) */
            B = coreMemoryRead(tempaddr, tStates: 3) & 0x7f
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: B)
            break
        case 0xb9:		/* LD C,RES 7,(REGISTER+dd) */
            C = coreMemoryRead(tempaddr, tStates: 3) & 0x7f
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: C)
            break
        case 0xba:		/* LD D,RES 7,(REGISTER+dd) */
            D = coreMemoryRead(tempaddr, tStates: 3) & 0x7f
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: D)
            break
        case 0xbb:		/* LD E,RES 7,(REGISTER+dd) */
            E = coreMemoryRead(tempaddr, tStates: 3) & 0x7f
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: E)
            break
        case 0xbc:		/* LD H,RES 7,(REGISTER+dd) */
            H = coreMemoryRead(tempaddr, tStates: 3) & 0x7f
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: H)
            break
        case 0xbd:		/* LD L,RES 7,(REGISTER+dd) */
            L = coreMemoryRead(tempaddr, tStates: 3) & 0x7f
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: L)
            break
        case 0xbe:		/* RES 7,(REGISTER+dd) */
            let bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: bytetemp & 0x7f)
            break
        case 0xbf:		/* LD A,RES 7,(REGISTER+dd) */
            A = coreMemoryRead(tempaddr, tStates: 3) & 0x7f
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: A)
            break
        case 0xc0:		/* LD B,SET 0,(REGISTER+dd) */
            B = coreMemoryRead(tempaddr, tStates: 3) | 0x01
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: B)
            break
        case 0xc1:		/* LD C,SET 0,(REGISTER+dd) */
            C = coreMemoryRead(tempaddr, tStates: 3) | 0x01
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: C)
            break
        case 0xc2:		/* LD D,SET 0,(REGISTER+dd) */
            D = coreMemoryRead(tempaddr, tStates: 3) | 0x01
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: D)
            break
        case 0xc3:		/* LD E,SET 0,(REGISTER+dd) */
            E = coreMemoryRead(tempaddr, tStates: 3) | 0x01
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: E)
            break
        case 0xc4:		/* LD H,SET 0,(REGISTER+dd) */
            H = coreMemoryRead(tempaddr, tStates: 3) | 0x01
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: H)
            break
        case 0xc5:		/* LD L,SET 0,(REGISTER+dd) */
            L = coreMemoryRead(tempaddr, tStates: 3) | 0x01
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: L)
            break
        case 0xc6:		/* SET 0,(REGISTER+dd) */
            let bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: bytetemp | 0x01)
            break
        case 0xc7:		/* LD A,SET 0,(REGISTER+dd) */
            A = coreMemoryRead(tempaddr, tStates: 3) | 0x01
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: A)
            break
        case 0xc8:		/* LD B,SET 1,(REGISTER+dd) */
            B = coreMemoryRead(tempaddr, tStates: 3) | 0x02
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: B)
            break
        case 0xc9:		/* LD C,SET 1,(REGISTER+dd) */
            C = coreMemoryRead(tempaddr, tStates: 3) | 0x02
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: C)
            break
        case 0xca:		/* LD D,SET 1,(REGISTER+dd) */
            D = coreMemoryRead(tempaddr, tStates: 3) | 0x02
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: D)
            break
        case 0xcb:		/* LD E,SET 1,(REGISTER+dd) */
            E = coreMemoryRead(tempaddr, tStates: 3) | 0x02
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: E)
            break
        case 0xcc:		/* LD H,SET 1,(REGISTER+dd) */
            H = coreMemoryRead(tempaddr, tStates: 3) | 0x02
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: H)
            break
        case 0xcd:		/* LD L,SET 1,(REGISTER+dd) */
            L = coreMemoryRead(tempaddr, tStates: 3) | 0x02
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: L)
            break
        case 0xce:		/* SET 1,(REGISTER+dd) */
            let bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: bytetemp | 0x02)
            break
        case 0xcf:		/* LD A,SET 1,(REGISTER+dd) */
            A = coreMemoryRead(tempaddr, tStates: 3) | 0x02
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: A)
            break
        case 0xd0:		/* LD B,SET 2,(REGISTER+dd) */
            B = coreMemoryRead(tempaddr, tStates: 3) | 0x04
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: B)
            break
        case 0xd1:		/* LD C,SET 2,(REGISTER+dd) */
            C = coreMemoryRead(tempaddr, tStates: 3) | 0x04
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: C)
            break
        case 0xd2:		/* LD D,SET 2,(REGISTER+dd) */
            D = coreMemoryRead(tempaddr, tStates: 3) | 0x04
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: D)
            break
        case 0xd3:		/* LD E,SET 2,(REGISTER+dd) */
            E = coreMemoryRead(tempaddr, tStates: 3) | 0x04
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: E)
            break
        case 0xd4:		/* LD H,SET 2,(REGISTER+dd) */
            H = coreMemoryRead(tempaddr, tStates: 3) | 0x04
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: H)
            break
        case 0xd5:		/* LD L,SET 2,(REGISTER+dd) */
            L = coreMemoryRead(tempaddr, tStates: 3) | 0x04
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: L)
            break
        case 0xd6:		/* SET 2,(REGISTER+dd) */
            let bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: bytetemp | 0x04)
            break
        case 0xd7:		/* LD A,SET 2,(REGISTER+dd) */
            A = coreMemoryRead(tempaddr, tStates: 3) | 0x04
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: A)
            break
        case 0xd8:		/* LD B,SET 3,(REGISTER+dd) */
            B = coreMemoryRead(tempaddr, tStates: 3) | 0x08
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: B)
            break
        case 0xd9:		/* LD C,SET 3,(REGISTER+dd) */
            C = coreMemoryRead(tempaddr, tStates: 3) | 0x08
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: C)
            break
        case 0xda:		/* LD D,SET 3,(REGISTER+dd) */
            D = coreMemoryRead(tempaddr, tStates: 3) | 0x08
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: D)
            break
        case 0xdb:		/* LD E,SET 3,(REGISTER+dd) */
            E = coreMemoryRead(tempaddr, tStates: 3) | 0x08
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: E)
            break
        case 0xdc:		/* LD H,SET 3,(REGISTER+dd) */
            H = coreMemoryRead(tempaddr, tStates: 3) | 0x08
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: H)
            break
        case 0xdd:		/* LD L,SET 3,(REGISTER+dd) */
            L = coreMemoryRead(tempaddr, tStates: 3) | 0x08
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: L)
            break
        case 0xde:		/* SET 3,(REGISTER+dd) */
            let bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: bytetemp | 0x08)
            break
        case 0xdf:		/* LD A,SET 3,(REGISTER+dd) */
            A = coreMemoryRead(tempaddr, tStates: 3) | 0x08
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: A)
            break
        case 0xe0:		/* LD B,SET 4,(REGISTER+dd) */
            B = coreMemoryRead(tempaddr, tStates: 3) | 0x10
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: B)
            break
        case 0xe1:		/* LD C,SET 4,(REGISTER+dd) */
            C = coreMemoryRead(tempaddr, tStates: 3) | 0x10
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: C)
            break
        case 0xe2:		/* LD D,SET 4,(REGISTER+dd) */
            D = coreMemoryRead(tempaddr, tStates: 3) | 0x10
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: D)
            break
        case 0xe3:		/* LD E,SET 4,(REGISTER+dd) */
            E = coreMemoryRead(tempaddr, tStates: 3) | 0x10
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: E)
            break
        case 0xe4:		/* LD H,SET 4,(REGISTER+dd) */
            H = coreMemoryRead(tempaddr, tStates: 3) | 0x10
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: H)
            break
        case 0xe5:		/* LD L,SET 4,(REGISTER+dd) */
            L = coreMemoryRead(tempaddr, tStates: 3) | 0x10
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: L)
            break
        case 0xe6:		/* SET 4,(REGISTER+dd) */
            let bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: bytetemp | 0x10)
            break
        case 0xe7:		/* LD A,SET 4,(REGISTER+dd) */
            A = coreMemoryRead(tempaddr, tStates: 3) | 0x10
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: A)
            break
        case 0xe8:		/* LD B,SET 5,(REGISTER+dd) */
            B = coreMemoryRead(tempaddr, tStates: 3) | 0x20
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: B)
            break
        case 0xe9:		/* LD C,SET 5,(REGISTER+dd) */
            C = coreMemoryRead(tempaddr, tStates: 3) | 0x20
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: C)
            break
        case 0xea:		/* LD D,SET 5,(REGISTER+dd) */
            D = coreMemoryRead(tempaddr, tStates: 3) | 0x20
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: D)
            break
        case 0xeb:		/* LD E,SET 5,(REGISTER+dd) */
            E = coreMemoryRead(tempaddr, tStates: 3) | 0x20
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: E)
            break
        case 0xec:		/* LD H,SET 5,(REGISTER+dd) */
            H = coreMemoryRead(tempaddr, tStates: 3) | 0x20
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: H)
            break
        case 0xed:		/* LD L,SET 5,(REGISTER+dd) */
            L = coreMemoryRead(tempaddr, tStates: 3) | 0x20
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: L)
            break
        case 0xee:		/* SET 5,(REGISTER+dd) */
            let bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: bytetemp | 0x20)
            break
        case 0xef:		/* LD A,SET 5,(REGISTER+dd) */
            A = coreMemoryRead(tempaddr, tStates: 3) | 0x20
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: A)
            break
        case 0xf0:		/* LD B,SET 6,(REGISTER+dd) */
            B = coreMemoryRead(tempaddr, tStates: 3) | 0x40
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: B)
            break
        case 0xf1:		/* LD C,SET 6,(REGISTER+dd) */
            C = coreMemoryRead(tempaddr, tStates: 3) | 0x40
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: C)
            break
        case 0xf2:		/* LD D,SET 6,(REGISTER+dd) */
            D = coreMemoryRead(tempaddr, tStates: 3) | 0x40
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: D)
            break
        case 0xf3:		/* LD E,SET 6,(REGISTER+dd) */
            E = coreMemoryRead(tempaddr, tStates: 3) | 0x40
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: E)
            break
        case 0xf4:		/* LD H,SET 6,(REGISTER+dd) */
            H = coreMemoryRead(tempaddr, tStates: 3) | 0x40
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: H)
            break
        case 0xf5:		/* LD L,SET 6,(REGISTER+dd) */
            L = coreMemoryRead(tempaddr, tStates: 3) | 0x40
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: L)
            break
        case 0xf6:		/* SET 6,(REGISTER+dd) */
            let bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: bytetemp | 0x40)
            break
        case 0xf7:		/* LD A,SET 6,(REGISTER+dd) */
            A = coreMemoryRead(tempaddr, tStates: 3) | 0x40
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: A)
            break
        case 0xf8:		/* LD B,SET 7,(REGISTER+dd) */
            B = coreMemoryRead(tempaddr, tStates: 3) | 0x80
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: B)
            break
        case 0xf9:		/* LD C,SET 7,(REGISTER+dd) */
            C = coreMemoryRead(tempaddr, tStates: 3) | 0x80
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: C)
            break
        case 0xfa:		/* LD D,SET 7,(REGISTER+dd) */
            D = coreMemoryRead(tempaddr, tStates: 3) | 0x80
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: D)
            break
        case 0xfb:		/* LD E,SET 7,(REGISTER+dd) */
            E = coreMemoryRead(tempaddr, tStates: 3) | 0x80
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: E)
            break
        case 0xfc:		/* LD H,SET 7,(REGISTER+dd) */
            H = coreMemoryRead(tempaddr, tStates: 3) | 0x80
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: H)
            break
        case 0xfd:		/* LD L,SET 7,(REGISTER+dd) */
            L = coreMemoryRead(tempaddr, tStates: 3) | 0x80
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: L)
            break
        case 0xfe:		/* SET 7,(REGISTER+dd) */
            let bytetemp: Byte = coreMemoryRead(tempaddr, tStates: 3)
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: bytetemp | 0x80)
            break
        case 0xff:		/* LD A,SET 7,(REGISTER+dd) */
            A = coreMemoryRead(tempaddr, tStates: 3) | 0x80
            coreMemoryContention(tempaddr, tStates: 1)
            coreMemoryWrite(tempaddr, value: A)
            break
            
        default:
            break
        }
        
    }
    
}
