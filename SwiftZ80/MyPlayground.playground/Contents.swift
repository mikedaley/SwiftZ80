//: Playground - noun: a place where people can play

import Cocoa

typealias Byte = UInt8
typealias Word = UInt16


//var a: Byte = 0x01
//var v: Byte = 0x02
//var b: Int16 = Int16(a) - Int16(v)
//
//a = Byte(b & 0xff)
//
//var p: Word = 4753
//
//var j: Int8 = -6
//
//var spc: Int16 = Int16(bitPattern: p)
//
//spc += Int16(j)
//
//p = Word(spc)
//
//
//let f53: Byte = Byte((p >> 8) & 0xff)


var a = Int8(bitPattern: 0xe6)
var ix: Word = 0xdea9
var six = Int(ix)

var r = six + Int(a)


struct register {
	var AF: Int = 0
}

struct test {

	var number: register?
	var BC = 0
	
	init() {
		number = register()
		number!.AF = 00
	}
	
	mutating func testing(inout num: Int) {
		depth(&num)
	}

}

extension test {
	
	mutating func depth(inout num: Int) {
		
		BC += 1
		
		num += 1
		
		if num < 10 {
		
			switch num {
				
			case 5:
				depth(&num)
				break
			case 8:
				depth(&num)
			default:
				depth(&num)
			}
		}
	}
}

var t = test()
var aa = t.number!.AF
t.testing(&aa)
print(aa)





