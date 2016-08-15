//
//  MemoryViewController.swift
//  SwiftZ80
//
//  Created by Mike Daley on 23/07/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

import Cocoa

extension String {
	init(_ byte: Byte) {
		self.init()
		self.append(UnicodeScalar(byte))
	}
}

class MemoryViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var memoryTableView: NSTableView!

	var appDelegate: AppDelegate?
	
	var fontManager: NSFontManager
	var boldFont: NSFont
	var memoryFont: NSFont

	required init?(coder: NSCoder) {

		fontManager = NSFontManager.sharedFontManager()
		boldFont = fontManager.fontWithFamily("Courier", traits: NSFontTraitMask.BoldFontMask, weight: 0, size: 14)!
		memoryFont = fontManager.fontWithFamily("Courier", traits: NSFontTraitMask.FixedPitchFontMask, weight: 0, size: 14)!
		super.init(coder: coder)
		
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
		
		appDelegate = NSApplication.sharedApplication().delegate as? AppDelegate
		
        memoryTableView.setDelegate(self)
        memoryTableView.setDataSource(self)
		
		memoryTableView.sizeLastColumnToFit()
		
		
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return 65535 / 32 + 1
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		if let cell = tableView.makeViewWithIdentifier("cell", owner: nil) as? NSTableCellView {
			
			let i = row * 32
			let string = String(format: "%5i: ", i)
			let attrString = NSMutableAttributedString.init(string: string, attributes: [NSFontAttributeName : boldFont])
			for index in i ... i + 31 {
				let value = appDelegate!.machine.memory[index]
				
				var textColor: NSColor = NSColor.blackColor()
				if index >= 0x4000 && index < 0x5800 {
					textColor = NSColor.blueColor()
				} else if appDelegate!.machine.memory[index] != 0x00 {
					textColor = NSColor.redColor()
				}
				let memoryString = NSAttributedString.init(string: String(format:"%02X ", value), attributes: [NSForegroundColorAttributeName : textColor])
				attrString.appendAttributedString(memoryString)
			}
			cell.textField?.attributedStringValue = attrString
            return cell
        }
        return nil
		
    }
    
}

