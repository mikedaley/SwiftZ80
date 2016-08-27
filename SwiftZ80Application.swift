//
//  SwiftZ80Application.swift
//  SwiftZ80
//
//  Created by Mike Daley on 26/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

import Foundation
import Cocoa

@objc(SwiftZ80Application)
class SwiftZ80Application: NSApplication {
	
	override func sendEvent(theEvent: NSEvent) {
		
		if theEvent.type == NSEventType.KeyUp && theEvent.modifierFlags.contains(.CommandKeyMask) {
			keyWindow?.sendEvent(theEvent)
			
		} else {
			super.sendEvent(theEvent)
		}
		
	}

}
