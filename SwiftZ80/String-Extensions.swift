//
//  String-Extensions.swift
//  SwiftZ80
//
//  Created by Mike Daley on 03/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

extension String {
	
	func padWithLength(length: Int) -> String {

		return String(count: length - self.characters.count, repeatedValue: Character("0"))
	
	}
}
