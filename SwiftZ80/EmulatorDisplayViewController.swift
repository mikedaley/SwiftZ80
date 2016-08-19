
//
//  EmulatorDisplayViewController.swift
//  SwiftZ80
//
//  Created by Mike Daley on 19/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

import Cocoa

class EmulatorDisplayViewController: NSViewController {
	
	var delegate: ViewEventProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
		
		view.wantsLayer = true
		view.layer?.magnificationFilter = kCAFilterLinear
    }
	
	override func keyUp(theEvent: NSEvent) {
		if delegate != nil {
			delegate!.keyUp(theEvent)
		}
	}
	
	override func keyDown(theEvent: NSEvent) {
		if delegate != nil {
			delegate!.keyDown(theEvent)
		}
	}
	
	override func flagsChanged(theEvent: NSEvent) {
		if delegate != nil {
			delegate!.flagsChanged(theEvent)
		}
	}
	
}
