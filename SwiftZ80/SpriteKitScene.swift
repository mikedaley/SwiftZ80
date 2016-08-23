//
//  SpriteKitScene.swift
//  SwiftZ80
//
//  Created by Mike Daley on 22/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

import SpriteKit

class SpriteKitScene: SKScene {
	
	let emulatorNode = SKSpriteNode()
	
	override func didMoveToView(view: SKView) {
		
		emulatorNode.color = NSColor.redColor()
		emulatorNode.position = CGPoint(x: 0, y: 0)
		emulatorNode.size = CGSize(width: 256, height: 192)
		addChild(emulatorNode)
	}

}
