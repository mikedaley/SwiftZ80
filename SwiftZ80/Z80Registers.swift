//
//  SwiftZ80Registers.swift
//  SwiftZ80
//
//  Created by Mike Daley on 23/07/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

/**
* A Z80 register set
* Defines all of the registers within the Z80 CPU. Each 16-bit register is of a Z80Register type so that its possible
* to access both the high and low byte of the word. It also includes the SP register as a word as its not possible to
* access the high or low byte of that register individually
*/
class Z80Registers {
	
	// AF
	var AF: Word = 0x00
	var A: Byte {
		get {
			return Byte(AF >> 8)
		}
		set {
			AF = (Word(newValue) << 8) | (AF & 0xff)
		}
	}
	var F: Byte {
		get {
			return Byte(AF & 0xff)
		}
		set {
			AF = (AF & 0xff00) | Word(newValue)
		}
	}

	// BC
	var BC: Word = 0x00
	var B: Byte {
		get {
			return Byte(BC >> 8)
		}
		set {
			BC = (Word(newValue) << 8) | (BC & 0xff)
		}
	}
	var C: Byte {
		get {
			return Byte(BC & 0xff)
		}
		set {
			BC = (BC & 0xff00) | Word(newValue)
		}
	}

	// DE
	var DE: Word = 0x00
	var D: Byte {
		get {
			return Byte(DE >> 8)
		}
		set {
			DE = (Word(newValue) << 8) | (DE & 0xff)
		}
	}
	var E: Byte {
		get {
			return Byte(DE & 0xff)
		}
		set {
			DE = (DE & 0xff00) | Word(newValue)
		}
	}
	
	// HL
	var HL: Word = 0x00
	var H: Byte {
		get {
			return Byte(HL >> 8)
		}
		set {
			HL = (Word(newValue) << 8) | (HL & 0xff)
		}
	}
	var L: Byte {
		get {
			return Byte(HL & 0xff)
		}
		set {
			HL = (HL & 0xff00) | Word(newValue)
		}
	}
	
	// IX
	var IX: Word = 0x00
	var IXh: Byte {
		get {
			return Byte(IX >> 8)
		}
		set {
			IX = (Word(newValue) << 8) | (IX & 0xff)
		}
	}
	var IXl: Byte {
		get {
			return Byte(IX & 0xff)
		}
		set {
			IX = (IX & 0xff00) | Word(newValue)
		}
	}
	
	// IY
	var IY: Word = 0x00
	var IYh: Byte {
		get {
			return Byte(IY >> 8)
		}
		set {
			IY = (Word(newValue) << 8) | (IY & 0xff)
		}
	}
	var IYl: Byte {
		get {
			return Byte(IY & 0xff)
		}
		set {
			IY = (IY & 0xff00) | Word(newValue)
		}
	}
}
