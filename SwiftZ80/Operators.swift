//
//  Operators.swift
//  SwiftZ80
//
//  Created by Mike Daley on 02/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

import Foundation

postfix operator &++ {}
postfix operator &-- {}

postfix func &++(a: Byte) -> Byte {
	return a &+ 1
}

postfix func &++(a: Word) -> Word {
	return a &+ 1
}

postfix func &--(a: Byte) -> Byte {
	return a &- 1
}

postfix func &--(a: Word) -> Word {
	return a &- 1
}