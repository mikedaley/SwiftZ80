//
//  AppDelegate.swift
//  SwiftZ80
//
//  Created by Mike Daley on 21/07/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

import Foundation
import Cocoa

/**
* Array Extension
* This extension adds a Word subscript
*/
extension Array {
	subscript(i: Word) -> Element {
		get {
			return self[Int(i)]
		}
		set (newValue) {
			self[Int(i)] = newValue
		}
	}
}

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
	
	var z80Core: SwiftZ80Core?
	
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
		
		z80Core = SwiftZ80Core.init(memoryRead: readFromMemoryAddress,
		                            memoryWrite: writeToMemoryAddress,
		                            ioRead: ioReadAddress,
		                            ioWrite: ioWriteAddress,
		                            contentionReadNoMREQ: contentionReadNoMREQAddress,
		                            contentionWriteNoMREQ: contentionWriteNoMREQAddress,
		                            contentionRead: contentionReadAddress)
	
		memory[0] = 0x0a
		memory[1] = 0xfa
		
		z80Core!.R1.BC = 0x0a0b
		print(String(format: "0x%04X", z80Core!.R1.BC))

		z80Core!.R1.B = 0x0f
		print(String(format: "0x%04X", z80Core!.R1.BC))

		z80Core!.R1.C = 0x43
		print(String(format: "0x%04X", z80Core!.R1.BC))
		
		z80Core!.memoryWriteAddress( 0x0000, value: 0xdd)
		print(z80Core!.memoryReadAddress(0x0000))
		
		z80Core!.R1.F = 0xff
		
		dispatch_source_set_timer(emulationTimer, DISPATCH_TIME_NOW, UInt64(1.0/50.0 * Double(NSEC_PER_SEC)), 0)
		
		dispatch_source_set_event_handler(emulationTimer) {
			var a = self.z80Core!.memoryReadAddress(0x00) &+ 1
			self.z80Core!.memoryWriteAddress(0x00, value: a)

			a = self.z80Core!.memoryReadAddress(0x21) &+ 1
			self.z80Core!.memoryWriteAddress(0x21, value: a)

			a = self.z80Core!.memoryReadAddress(0xffff) &+ 1
			self.z80Core!.memoryWriteAddress(0xffff, value: a)
			
			self.z80Core!.R1.DE = self.z80Core!.R1.DE &+ 1
			
			self.z80Core!.tStates = self.z80Core!.tStates + 1
			
//			self.z80Core!.R1.F = self.z80Core!.R1.F ^ 255
			
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
		self.cpuViewController.A.stringValue = String(format: "%02X", (self.z80Core?.R1.A)!)
		self.cpuViewController.F.stringValue = String(format: "%02X", (self.z80Core?.R1.F)!)
		self.cpuViewController.B.stringValue = String(format: "%02X", (self.z80Core?.R1.B)!)
		self.cpuViewController.C.stringValue = String(format: "%02X", (self.z80Core?.R1.C)!)
		self.cpuViewController.D.stringValue = String(format: "%02X", (self.z80Core?.R1.D)!)
		self.cpuViewController.E.stringValue = String(format: "%02X", (self.z80Core?.R1.E)!)
		self.cpuViewController.H.stringValue = String(format: "%02X", (self.z80Core?.R1.H)!)
		self.cpuViewController.L.stringValue = String(format: "%02X", (self.z80Core?.R1.L)!)
		self.cpuViewController.IYh.stringValue = String(format: "%02X", (self.z80Core?.R1.IYh)!)
		self.cpuViewController.IYl.stringValue = String(format: "%02X", (self.z80Core?.R1.IYl)!)
		self.cpuViewController.IXh.stringValue = String(format: "%02X", (self.z80Core?.R1.IXh)!)
		self.cpuViewController.IXl.stringValue = String(format: "%02X", (self.z80Core?.R1.IXl)!)

		self.cpuViewController.A_A.stringValue = String(format: "%02X", (self.z80Core?.R2.A)!)
		self.cpuViewController.A_F.stringValue = String(format: "%02X", (self.z80Core?.R2.F)!)
		self.cpuViewController.A_B.stringValue = String(format: "%02X", (self.z80Core?.R2.B)!)
		self.cpuViewController.A_C.stringValue = String(format: "%02X", (self.z80Core?.R2.C)!)
		self.cpuViewController.A_D.stringValue = String(format: "%02X", (self.z80Core?.R2.D)!)
		self.cpuViewController.A_E.stringValue = String(format: "%02X", (self.z80Core?.R2.E)!)
		self.cpuViewController.A_H.stringValue = String(format: "%02X", (self.z80Core?.R2.H)!)
		self.cpuViewController.A_L.stringValue = String(format: "%02X", (self.z80Core?.R2.L)!)
		self.cpuViewController.A_IYh.stringValue = String(format: "%02X", (self.z80Core?.R2.IYh)!)
		self.cpuViewController.A_IYl.stringValue = String(format: "%02X", (self.z80Core?.R2.IYl)!)
		self.cpuViewController.A_IXh.stringValue = String(format: "%02X", (self.z80Core?.R2.IXh)!)
		self.cpuViewController.A_IXl.stringValue = String(format: "%02X", (self.z80Core?.R2.IXl)!)

		self.cpuViewController.IFF1.stringValue = String(format: "%02X", (self.z80Core?.IFF1)!)
		self.cpuViewController.IFF2.stringValue = String(format: "%02X", (self.z80Core?.IFF2)!)
		self.cpuViewController.tStates.stringValue = String(format: "%i", (self.z80Core?.tStates)!)
		self.cpuViewController.IM.stringValue = String(format: "%02X", (self.z80Core?.IM)!)
		self.cpuViewController.R.stringValue = String(format: "%02X", (self.z80Core?.R)!)
		self.cpuViewController.I.stringValue = String(format: "%02X", (self.z80Core?.I)!)
		
		self.cpuViewController.F_S.state = Int((self.z80Core?.R1.F)! & 0x80)
		self.cpuViewController.F_Z.state = Int((self.z80Core?.R1.F)! & 0x40)
		self.cpuViewController.F_H.state = Int((self.z80Core?.R1.F)! & 0x10)
		self.cpuViewController.F_P.state = Int((self.z80Core?.R1.F)! & 0x04)
		self.cpuViewController.F_N.state = Int((self.z80Core?.R1.F)! & 0x02)
		self.cpuViewController.F_C.state = Int((self.z80Core?.R1.F)! & 0x01)
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
	
	func contentionReadNoMREQAddress(address: Word, tStates: Int) -> Byte {
		return 0x00
	}

	func contentionWriteNoMREQAddress(address: Word, tStates: Int, value: Byte) {
		
	}
	
	func contentionReadAddress(address: Word, tStates: Int) -> Byte {
		return 0x00
	}

}

