//
//  ViewEventProtocol.swift
//  SwiftZ80
//
//  Created by Mike Daley on 19/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

import Cocoa

protocol ViewEventProtocol {
	
	func keyDown(theEvent: NSEvent)
	func keyUp(theEvent: NSEvent)
	func flagsChanged(theEvent: NSEvent)
	
}