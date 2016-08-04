//: Playground - noun: a place where people can play

import Cocoa

typealias Byte = UInt8
typealias Word = UInt16


var a: Byte = 0x01
var v: Byte = 0x02
var b: Int16 = Int16(a) - Int16(v)

a = Byte(b & 0xff)

func ADD<T>(value: T) {
	
	let result: Int = value as! Int
	
}