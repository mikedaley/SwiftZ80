//
//  MemoryViewController.swift
//  SwiftZ80
//
//  Created by Mike Daley on 23/07/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

import Cocoa

class MemoryViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var memoryTableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        memoryTableView.setDelegate(self)
        memoryTableView.setDataSource(self)
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return 65535 / 10
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeViewWithIdentifier("cell", owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = "00"
            return cell
        }
        return nil
    }
    
}
