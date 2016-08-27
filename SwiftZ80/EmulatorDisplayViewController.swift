
//
//  EmulatorDisplayViewController.swift
//  SwiftZ80
//
//  Created by Mike Daley on 19/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

import Cocoa
import SpriteKit

class EmulatorDisplayViewController: NSViewController {
	
	var delegate: ViewEventProtocol?
	var scene: SKScene!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
		
		view.wantsLayer = true
		view.layer?.magnificationFilter = kCAFilterNearest
		

//		let skView = view as! SKView
//		
//		let scene = SpriteKitScene(size: CGSize(width: 256, height: 192))
//		scene.scaleMode = .AspectFit
//		skView.presentScene(scene)
		
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
