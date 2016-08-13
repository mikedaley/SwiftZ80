//
//  SwiftZ80.swift
//  SwiftZ80
//
//  Created by Mike Daley on 21/07/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

public typealias Byte = UInt8
public typealias Word = UInt16

/**
* Z80 flags
*/
let FLAG_C: Byte	= 0x01
let FLAG_N: Byte	= 0x02
let FLAG_P: Byte	= 0x04
let FLAG_V: Byte	= FLAG_P
let FLAG_3: Byte	= 0x08
let FLAG_H: Byte	= 0x10
let FLAG_5: Byte	= 0x20
let FLAG_Z: Byte	= 0x40
let FLAG_S: Byte	= 0x80

/**
* SwiftZ80Core
* Structure that defines the properties, functions and opcode implementations needed to emulate the Z80 CPU
*/
struct SwiftZ80Core
{	
	// Z80 registers
	var R1: Z80Registers
	var AF: Word {
		get {
			return R1.AF
		}
		set {
			R1.AF = newValue
		}
	}
	var A: Byte {
		get {
			return R1.A
		}
		set {
			R1.A = newValue
		}
	}
	var F: Byte {
		get {
			return R1.F
		}
		set {
			R1.F = newValue
		}
	}
	var BC: Word {
		get {
			return R1.BC
		}
		set {
			R1.BC = newValue
		}
	}
	var B: Byte {
		get {
			return R1.B
		}
		set {
			R1.B = newValue
		}
	}
	var C: Byte {
		get {
			return R1.B
		}
		set {
			R1.B = newValue
		}
	}
	var DE: Word {
		get {
			return R1.DE
		}
		set {
			R1.DE = newValue
		}
	}
	var D: Byte {
		get {
			return R1.D
		}
		set {
			R1.D = newValue
		}
	}
	var E: Byte {
		get {
			return R1.E
		}
		set {
			R1.E = newValue
		}
	}
	var HL: Word {
		get {
			return R1.HL
		}
		set {
			R1.HL = newValue
		}
	}
	var H: Byte {
		get {
			return R1.H
		}
		set {
			R1.H = newValue
		}
	}
	var L: Byte {
		get {
			return R1.L
		}
		set {
			R1.L = newValue
		}
	}
	var IX: Word {
		get {
			return R1.IX
		}
		set {
			R1.IX = newValue
		}
	}
	var IXh: Byte {
		get {
			return R1.IXh
		}
		set {
			R1.IXh = newValue
		}
	}
	var IXl: Byte {
		get {
			return R1.IXl
		}
		set {
			R1.IXl = newValue
		}
	}
	var IY: Word {
		get {
			return R1.IY
		}
		set {
			R1.IY = newValue
		}
	}
	var IYh: Byte {
		get {
			return R1.IYh
		}
		set {
			R1.IYh = newValue
		}
	}
	var IYl: Byte {
		get {
			return R1.IYl
		}
		set {
			R1.IYl = newValue
		}
	}
	
	// Z80 shadow registers
	var R2: Z80Registers
	var AF_: Word {
		get {
			return R2.AF
		}
		set {
			R2.AF = newValue
		}
	}
	var A_: Byte {
		get {
			return R2.A
		}
		set {
			R2.A = newValue
		}
	}
	var F_: Byte {
		get {
			return R2.F
		}
		set {
			R2.F = newValue
		}
	}
	var BC_: Word {
		get {
			return R2.BC
		}
		set {
			R2.BC = newValue
		}
	}
	var B_: Byte {
		get {
			return R2.B
		}
		set {
			R2.B = newValue
		}
	}
	var C_: Byte {
		get {
			return R2.B
		}
		set {
			R2.B = newValue
		}
	}
	var DE_: Word {
		get {
			return R2.DE
		}
		set {
			R2.DE = newValue
		}
	}
	var D_: Byte {
		get {
			return R2.D
		}
		set {
			R2.D = newValue
		}
	}
	var E_: Byte {
		get {
			return R2.E
		}
		set {
			R2.E = newValue
		}
	}
	var HL_: Word {
		get {
			return R2.HL
		}
		set {
			R2.HL = newValue
		}
	}
	var H_: Byte {
		get {
			return R2.H
		}
		set {
			R2.H = newValue
		}
	}
	var L_: Byte {
		get {
			return R2.L
		}
		set {
			R2.L = newValue
		}
	}
	
	// PC & SP
	var PC: Word
    var PCh: Byte {
		get {
			return Byte(PC >> 8)
		}
        set {
            PC = (Word(newValue) << 8) + (PC & 0xff)
        }
	}
    var PCl: Byte {
		get {
			return Byte(PC & 0xff)
		}
        set {
            PC = (PC & 0xff00) + Word(newValue)
        }
	}
	
	var SP: Word = 0x00
	private var SPh: Byte {
		get {
			return Byte(SP >> 8)
		}
	}
	private var SPl: Byte {
		get {
			return Byte(SP & 0xff)
		}
	}
	
	// Interrupt and refresh registers
	var R: Byte
	var I: Byte
	var IR: Word {
		get {
			return ((Word(I) << 8) | (Word(R7 & 0x80)) | (Word(R & 0x7f)))
		}
	}
	var R7: Byte {
		get {
			return R & 0x80
		}
	}
	var IFF1: Byte
	var IFF2: Byte
	var IM: Byte
	
	// General core properties
	var halted: Bool = false
	var tStates: Int = 0
	
	// References to functions that manage memory access
	var memoryReadAddress: (Word) -> (Byte)
	var memoryWriteAddress: (Word, value: Byte) -> ()
	
	// References to functions that manage io access
	var ioReadAddress: (Word) -> (Byte)
	var ioWriteAddress: (Word, value: Byte) -> ()
	
	// References to functions that manage any contention rules
	var contend_read_no_mreq: (Word, tStates: Int) -> ()
	var contend_write_no_mreq: (Word, tStates: Int) -> ()
	var contend_read: (Word, tStates: Int) -> ()
	
	// Flag tables
	let halfcarryAddTable: [Byte] = [0, FLAG_H, FLAG_H, FLAG_H, 0, 0, 0, FLAG_H]
	let halfcarrySubTable: [Byte] = [0, 0, FLAG_H, 0, FLAG_H, 0, FLAG_H, FLAG_H]

    let overflowAddTable: [Byte] = [0, 0, 0, FLAG_V, FLAG_V, 0, 0, 0]
	let overflowSubTable: [Byte] = [0, FLAG_V, 0, 0, 0, 0, FLAG_V, 0]
    
    var SZ35Table = [Byte](count: 256, repeatedValue: 0)
    var parityTable = [Byte](count: 256, repeatedValue: 0)
    
	/**
	* Initializer
	* Takes references to the functions that the core is to use when accessing memory, io and contention.
	* This allows how memory is mapped and stored to be managed outside of the core making the core more
	* general purpose.
	*/
	init(memoryRead: (address: Word) -> (Byte),
	     memoryWrite: (address: Word, value: Byte) -> (),
	     ioRead: (address: Word) -> (Byte),
	     ioWrite: (address: Word, value: Byte) -> (),
	     contentionReadNoMREQ: (address: Word, tStates: Int) -> (),
	     contentionWriteNoMREQ: (address: Word, tStates: Int) -> (),
	     contentionRead: (address: Word, tStates: Int) -> ()) {
		
		R1 = Z80Registers()
		R2 = Z80Registers()
		PC = 0x00
		SP = 0x00
		R = 0x00
		I = 0x00
		IFF1 = 0x00
		IFF2 = 0x00
		IM = 0x00
		halted = false
		tStates = 0
		self.memoryReadAddress = memoryRead
		self.memoryWriteAddress = memoryWrite
		self.ioReadAddress = ioRead
		self.ioWriteAddress = ioWrite
		self.contend_read_no_mreq = contentionReadNoMREQ
		self.contend_write_no_mreq = contentionWriteNoMREQ
		self.contend_read = contentionRead
        
        setupTables()
	}
	
    mutating func setupTables() {

        for i: Int in 0...255 {
            
            SZ35Table[i] = (i == 0) ? FLAG_Z : 0;
            SZ35Table[i] |= ((i & 0x80) == 0x80) ? FLAG_S : 0;
            SZ35Table[i] |= Byte(i) & (FLAG_3 | FLAG_5);

            var parity: Byte = 0
            var v: Byte = Byte(i)
            
            for _ in 0...7 {
                parity ^= v & 0x01
                v >>= 0x01
            }
            
            var p: Byte = FLAG_P
            if (parity == 0x01) {
                p = 0x00
            }
            
            parityTable[i] = p
        }
    }
    
    // MARK: Core execution functions
	
    /**
     * Execute a single opcode based on the current PC. Start by looking up the base opcode.
	 * If a mult-byte opcode is identified then it will call into the next opcode level e.g. CB and
	 * then ED etc. until it finds the opcode implementation needed
     */
    mutating func execute() {
		
		let opcode: Byte = memoryReadAddress(PC)
		PC += 1
		lookupBaseOpcode(opcode)
	
	}
	
	// MARK: Core flag functions

	/**
	* Get the specified flag
	*/
	func getFlag(flag: Byte) -> Byte {
		return F & flag
	}

	/**
	* Reset the specific flag
	*/
	mutating func ResetFlag(flag: Byte) {
		F &= ~flag
	}

	/**
	* Set the specified flag
	*/
	mutating func SetFlag(flag: Byte) {
		F |= flag
	}
	
	/**
	* Get or Reset the specified flag based on the value passed in
	*/
	mutating func ValFlag(flag: Byte, value: Byte) {
		if value != 0 {
			SetFlag(flag)
		} else {
			ResetFlag(flag)
		}
	}

}