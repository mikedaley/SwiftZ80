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
			var string = String(format: "%5i: ", i)
			for index in i ... i + 31 {
				let value = appDelegate!.memory[index]
				string.appendContentsOf(String(format:"%02X ", value))
			}
			cell.textField?.stringValue = string
            return cell
        }
        return nil
		
    }
    
}

