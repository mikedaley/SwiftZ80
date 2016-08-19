//
//  AppDelegate.swift
//  SwiftZ80
//
//  Created by Mike Daley on 21/07/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

import Foundation
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!

	@IBOutlet weak var memoryViewController: MemoryViewController!
	@IBOutlet weak var cpuViewController: CPUViewController!
	@IBOutlet weak var graphicalMemoryController: GraphicalMemoryController!

	@IBOutlet weak var cpuView: NSView!
	@IBOutlet weak var memoryView: NSView!
    @IBOutlet weak var screenView: NSView!
		
    let displayQueue = dispatch_queue_create("displayQueue", nil)
    var displayTimer: dispatch_source_t
    
    var machine = ZXSpectrum48()
    
	override init() {
		displayTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, displayQueue)
	}
	
	func applicationDidFinishLaunching(aNotification: NSNotification) {
		
        // We want the views to be layer backed
        window.contentView?.wantsLayer = true
        screenView.wantsLayer = true
        screenView.layer?.magnificationFilter = kCAFilterLinear
		
        // Setup the views and constraints
        setupViewConstraints()
        
        dispatch_source_set_timer(displayTimer, DISPATCH_TIME_NOW, UInt64(1/50 * Double(NSEC_PER_SEC)), 0)
        dispatch_source_set_event_handler(displayTimer) {
            dispatch_async(dispatch_get_main_queue(), { 
                self.updateUI()
            })
        }
        
        dispatch_resume(displayTimer)
        
        // Start the emulation running
        machine.startExecution()
    }

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}
	
	func updateUI() {
		// Update the memory view
//		memoryViewController.update(machine.core!)
		
		// Update the CPU view
//        cpuViewController.update(machine.core!, tStatesInCurrentFrame: machine.tStatesInCurrentFrame)
		
        screenView.layer?.contents = machine.imageRef
	}
	
    func setupViewConstraints() {
        memoryViewController.view.translatesAutoresizingMaskIntoConstraints = false
        memoryViewController.view.canDrawSubviewsIntoLayer = true
        memoryView.addSubview(memoryViewController.view)
        memoryView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        let views = ["memoryTableView" : memoryViewController.view, "cpuView" : cpuViewController.view]
        let vertMemTableConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[memoryTableView]|", options: [], metrics: nil, views: views)
        constraints += vertMemTableConstraints
        let horizMemTableConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[memoryTableView]|", options: [], metrics: nil, views: views)
        constraints += horizMemTableConstraints
        
        memoryView.addConstraints(constraints)
        
        constraints.removeAll()
        
        cpuView.translatesAutoresizingMaskIntoConstraints = false
        cpuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        cpuView.addSubview(cpuViewController.view)
        
        let vertCPUViewConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[cpuView]|", options: [], metrics: nil, views: views)
        constraints += vertCPUViewConstraints
        let horizCPUViewConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[cpuView]|", options: [], metrics: nil, views: views)
        constraints += horizCPUViewConstraints
        
        cpuView.addConstraints(constraints)
    }
    
    @IBAction func machineReset(sender: AnyObject) {
        machine.reset()
    }

}

