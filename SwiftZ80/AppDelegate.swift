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
	@IBOutlet weak var emulationDisplayViewController: EmulatorDisplayViewController!
	
	var machine: ZXSpectrum48!
	
	func applicationDidFinishLaunching(aNotification: NSNotification) {
		
        window.contentView?.wantsLayer = true
		machine = ZXSpectrum48(view: emulationDisplayViewController.view)
		setupView()
        machine.startExecution()
		
    }

	func applicationWillTerminate(aNotification: NSNotification) {
		
	}

	// MARK: User interface
	
    func setupView() {
		window.contentView?.addSubview(emulationDisplayViewController.view)
		emulationDisplayViewController.view.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        let views = ["emulationDisplayView" : emulationDisplayViewController.view]
        let vertEmulationViewConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[emulationDisplayView]|", options: [], metrics: nil, views: views)
        constraints += vertEmulationViewConstraints
        let horizEmulationViewConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[emulationDisplayView]|", options: [], metrics: nil, views: views)
        constraints += horizEmulationViewConstraints
        window.contentView!.addConstraints(constraints)
		
		window.makeFirstResponder(emulationDisplayViewController.view)
		emulationDisplayViewController.delegate = machine
	}
	
    @IBAction func machineReset(sender: AnyObject) {
        machine.reset()
    }
	
	

}

