//
//  Byte-Extensions.swift
//  SwiftZ80
//
//  Created by Mike Daley on 03/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

extension Byte {
	
	var toBinaryString: String {
		let tempString = String(self, radix: 2)
		let padString = String(count: 8 - tempString.characters.count, repeatedValue: Character("0"))
		return padString + String(self, radix: 2)
	}
	
	var toHexString: String {
		return String(format: "0x%02X", self)
	}
	
}
