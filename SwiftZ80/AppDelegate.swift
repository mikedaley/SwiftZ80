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
	
	@IBOutlet weak var pcLabel: NSTextField!

	var machine: ZXSpectrum48!
	
    var runCoreTests = false
	
    var coreTests: SwiftZ80CoreTest = SwiftZ80CoreTest()
	
	var windowWidthConstraint: NSLayoutConstraint!
	var windowHeightConstraint: NSLayoutConstraint!
    
	func applicationDidFinishLaunching(aNotification: NSNotification) {
		
        window.contentView?.wantsLayer = true
		
		machine = ZXSpectrum48(emulationScreenView: emulationDisplayViewController.view)
		
		setupView()
        
        if runCoreTests {
            coreTests.runTests()
        } else {
            machine.startExecution()
        }
		
    }

	func applicationWillTerminate(aNotification: NSNotification) {
		// NOTHING TO SEE HERE :)
	}

	func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
		return true
	}
	
	func application(sender: NSApplication, openFiles filenames: [String]) {
		machine.loadSnapShotWithPath(filenames[0])
	}

	// MARK: User interface
	
    func setupView() {
		
		window.contentView?.addSubview(emulationDisplayViewController.view)
		
		emulationDisplayViewController.view.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        let views = ["emulationDisplayView" : emulationDisplayViewController.view]
		
		windowWidthConstraint = NSLayoutConstraint(item: emulationDisplayViewController.view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 320.0)
		windowHeightConstraint = NSLayoutConstraint(item: emulationDisplayViewController.view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 256.0)
		
		window.contentView!.addConstraint(windowWidthConstraint)
		window.contentView!.addConstraint(windowHeightConstraint)
		
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
	
	@IBAction func screenMagnificationFilter(sender: AnyObject) {
		
		if emulationDisplayViewController.view.layer?.magnificationFilter == kCAFilterNearest {
			emulationDisplayViewController.view.layer?.magnificationFilter = kCAFilterLinear
		} else {
			emulationDisplayViewController.view.layer?.magnificationFilter = kCAFilterNearest
		}
		
	}
	
	@IBAction func animateWindowSize(sender: AnyObject) {

		NSAnimationContext.runAnimationGroup({ (context: NSAnimationContext) in
			
			context.duration = 0.2
			context.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
			
			self.windowWidthConstraint.animator().constant = 320 * (CGFloat(sender.tag) / 2.0)
			self.windowHeightConstraint.animator().constant = 256 * (CGFloat(sender.tag) / 2.0)
			
			}, completionHandler: nil)
		
	}

	@IBAction func openDocument(sender: AnyObject) {
		let openPanel = NSOpenPanel.init()
		openPanel.canChooseDirectories = false
		openPanel.allowsMultipleSelection = false
		openPanel.allowedFileTypes = ["sna"]
		if openPanel.runModal() == NSModalResponseOK {
			machine.loadSnapShotWithPath(openPanel.URLs[0].path!)
		}
	}

}

