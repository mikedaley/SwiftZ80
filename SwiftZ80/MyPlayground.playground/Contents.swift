//: Playground - noun: a place where people can play

import Cocoa

typealias Byte = UInt8
typealias Word = UInt16


var a: Byte = 0x01
var v: Byte = 0x02
var b: Int16 = Int16(a) - Int16(v)

a = Byte(b & 0xff)

var p: Word = 4753

var j: Int8 = -6

var spc: Int16 = Int16(bitPattern: p)

spc += Int16(j)

p = Word(spc)


let f53: Byte = Byte((p >> 8) & 0xff)


