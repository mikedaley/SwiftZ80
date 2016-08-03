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
	
	// Main memory array
	var memory = [Byte](count: 65536, repeatedValue: 0x00)
	
	var core: SwiftZ80Core?
	
	let emulationQueue = dispatch_queue_create("emulationQueue", nil)
	var emulationTimer: dispatch_source_t
	
	let displayQueue = dispatch_queue_create("displayQueue", nil)
	var displayTimer: dispatch_source_t
	
	override init() {
		emulationTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, emulationQueue)
		displayTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, displayQueue)
	}
	
	func applicationDidFinishLaunching(aNotification: NSNotification) {
		// Insert code here to initialize your application
		
		window.contentView?.wantsLayer = true
//		window.aspectRatio = window.frame.size
		
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
		
		core = SwiftZ80Core.init(memoryRead: readFromMemoryAddress,
		                            memoryWrite: writeToMemoryAddress,
		                            ioRead: ioReadAddress,
		                            ioWrite: ioWriteAddress,
		                            contentionReadNoMREQ: contentionReadNoMREQAddress,
		                            contentionWriteNoMREQ: contentionWriteNoMREQAddress,
		                            contentionRead: contentionReadAddress)
		
		core!.z80InitTables()
	
		core?.F |= 0x00
		core?.A = 0xfe
		memory[0] = 0xce
		memory[1] = 0x0a
		
		core?.execute()
		
		dispatch_source_set_timer(emulationTimer, DISPATCH_TIME_NOW, UInt64(1.0/50.0 * Double(NSEC_PER_SEC)), 0)
		
		dispatch_source_set_event_handler(emulationTimer) {
//			var a = self.core!.memoryReadAddress(0x00) &+ 1
//			self.core!.memoryWriteAddress(0x00, value: a)
//
//			a = self.core!.memoryReadAddress(0x21) &+ 1
//			self.core!.memoryWriteAddress(0x21, value: a)
//
//			a = self.core!.memoryReadAddress(0xffff) &+ 1
//			self.core!.memoryWriteAddress(0xffff, value: a)
//			
//			self.core!.R1.DE = self.core!.R1.DE &+ 1
//			
//			self.core!.tStates = self.core!.tStates + 1
//			
//			self.core!.A = 0xee
//			
//			self.core!.F = 132
//			self.core!.F_ = 132
			
		}
		
		dispatch_resume(emulationTimer)

		dispatch_source_set_timer(displayTimer, DISPATCH_TIME_NOW, UInt64(0.25 * Double(NSEC_PER_SEC)), 0)
		dispatch_source_set_event_handler(displayTimer) {
			dispatch_async(dispatch_get_main_queue(), { 
				self.updateUI()
			})
		}
		
		dispatch_resume(displayTimer)

	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}
	
	func updateUI() {
		// Update the memory view
		let visibleRect = self.memoryViewController.memoryTableView.visibleRect
		let rowsInRect = self.memoryViewController.memoryTableView.rowsInRect(visibleRect)
		let colsInRect = self.memoryViewController.memoryTableView.columnIndexesInRect(visibleRect)
		self.memoryViewController.memoryTableView.reloadDataForRowIndexes(NSIndexSet.init(indexesInRange: rowsInRect), columnIndexes: colsInRect)
		
		// Update the CPU view
		self.cpuViewController.A.stringValue = String(format: "%02X", (self.core?.A)!)
		self.cpuViewController.F.stringValue = String(format: "%02X", (self.core?.F)!)
		self.cpuViewController.B.stringValue = String(format: "%02X", (self.core?.B)!)
		self.cpuViewController.C.stringValue = String(format: "%02X", (self.core?.C)!)
		self.cpuViewController.D.stringValue = String(format: "%02X", (self.core?.D)!)
		self.cpuViewController.E.stringValue = String(format: "%02X", (self.core?.E)!)
		self.cpuViewController.H.stringValue = String(format: "%02X", (self.core?.H)!)
		self.cpuViewController.L.stringValue = String(format: "%02X", (self.core?.L)!)
		self.cpuViewController.IYh.stringValue = String(format: "%02X", (self.core?.IYh)!)
		self.cpuViewController.IYl.stringValue = String(format: "%02X", (self.core?.IYl)!)
		self.cpuViewController.IXh.stringValue = String(format: "%02X", (self.core?.IXh)!)
		self.cpuViewController.IXl.stringValue = String(format: "%02X", (self.core?.IXl)!)

		self.cpuViewController.A_A.stringValue = String(format: "%02X", (self.core?.A_)!)
		self.cpuViewController.A_F.stringValue = String(format: "%02X", (self.core?.F_)!)
		self.cpuViewController.A_B.stringValue = String(format: "%02X", (self.core?.B_)!)
		self.cpuViewController.A_C.stringValue = String(format: "%02X", (self.core?.C_)!)
		self.cpuViewController.A_D.stringValue = String(format: "%02X", (self.core?.D_)!)
		self.cpuViewController.A_E.stringValue = String(format: "%02X", (self.core?.E_)!)
		self.cpuViewController.A_H.stringValue = String(format: "%02X", (self.core?.H_)!)
		self.cpuViewController.A_L.stringValue = String(format: "%02X", (self.core?.L_)!)

		self.cpuViewController.IFF1.stringValue = String(format: "%02X", (self.core?.IFF1)!)
		self.cpuViewController.IFF2.stringValue = String(format: "%02X", (self.core?.IFF2)!)
		self.cpuViewController.tStates.stringValue = String(format: "%i", (self.core?.tStates)!)
		self.cpuViewController.IM.stringValue = String(format: "%02X", (self.core?.IM)!)
		self.cpuViewController.R.stringValue = String(format: "%02X", (self.core?.R)!)
		self.cpuViewController.I.stringValue = String(format: "%02X", (self.core?.I)!)
		
		self.cpuViewController.F_S.state = Int((self.core?.R1.F)! & 0x80)
		self.cpuViewController.F_Z.state = Int((self.core?.R1.F)! & 0x40)
		self.cpuViewController.F_H.state = Int((self.core?.R1.F)! & 0x10)
		self.cpuViewController.F_P.state = Int((self.core?.R1.F)! & 0x04)
		self.cpuViewController.F_N.state = Int((self.core?.R1.F)! & 0x02)
		self.cpuViewController.F_C.state = Int((self.core?.R1.F)! & 0x01)
	}
	
/**
* Z80 Core context method implementations
*/
	func readFromMemoryAddress(address: Word) -> Byte {
		return memory[address]
	}

	func writeToMemoryAddress(address: Word, value: Byte) {
		memory[address] = value
	}

	func ioReadAddress(address: Word) -> Byte {
		return 0xff
	}
	
	func ioWriteAddress(address: Word, value: Byte) {
		
	}
	
	func contentionReadNoMREQAddress(address: Word, tStates: Int) {

	}

	func contentionWriteNoMREQAddress(address: Word, tStates: Int) {
		
	}
	
	func contentionReadAddress(address: Word, tStates: Int) {

	}

}

