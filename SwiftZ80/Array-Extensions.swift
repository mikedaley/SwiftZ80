//
//  Array-Extensions.swift
//  SwiftZ80
//
//  Created by Mike Daley on 02/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

/**
* This extension adds a Word subscript
*/
extension Array {
	subscript(i: Word) -> Element {
		get {
			return self[Int(i)]
		}
		set (newValue) {
			self[Int(i)] = newValue
		}
	}
}

/**
* This extension adds a Byte subscript
*/
extension Array {
	subscript(i: Byte) -> Element {
		get {
			let index = Int(i)
			return self[index]
		}
		set (newValue) {
			self[Int(i)] = newValue
		}
	}
}