//
//  GraphicalMemoryController.swift
//  SwiftZ80
//
//  Created by Mike Daley on 29/07/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

import Cocoa

class GraphicalMemoryController: NSViewController {

	var displayBuffer: [Byte]?
	var imageRef: CGImageRef?
	
	
	
	override func awakeFromNib() {
		
		displayBuffer = [Byte](count: 65536 * 8 * 4, repeatedValue: 0x00)
		
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
		
		view.wantsLayer = true
		
	
    }
	
	
	func updateMemoryImageWithCore(core: SwiftZ80Core) {
		
		
		
		
	}
    
}
