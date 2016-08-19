//
//  CPUViewController.swift
//  SwiftZ80
//
//  Created by Mike Daley on 28/07/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

import Cocoa

class CPUViewController: NSViewController {

	@IBOutlet weak var A: NSTextField!
	@IBOutlet weak var A_A: NSTextField!
	@IBOutlet weak var F: NSTextField!
	@IBOutlet weak var A_F: NSTextField!
	@IBOutlet weak var B: NSTextField!
	@IBOutlet weak var C: NSTextField!
	@IBOutlet weak var A_B: NSTextField!
	@IBOutlet weak var A_C: NSTextField!
	@IBOutlet weak var D: NSTextField!
	@IBOutlet weak var E: NSTextField!
	@IBOutlet weak var A_D: NSTextField!
	@IBOutlet weak var A_E: NSTextField!
	@IBOutlet weak var H: NSTextField!
	@IBOutlet weak var L: NSTextField!
	@IBOutlet weak var A_H: NSTextField!
	@IBOutlet weak var A_L: NSTextField!
	@IBOutlet weak var IYh: NSTextField!
	@IBOutlet weak var IYl: NSTextField!
	@IBOutlet weak var A_IYh: NSTextField!
	@IBOutlet weak var A_IYl: NSTextField!
	@IBOutlet weak var IXh: NSTextField!
	@IBOutlet weak var IXl: NSTextField!
	@IBOutlet weak var A_IXh: NSTextField!
	@IBOutlet weak var A_IXl: NSTextField!
	@IBOutlet weak var IFF1: NSTextField!
	@IBOutlet weak var IFF2: NSTextField!
	@IBOutlet weak var tStates: NSTextField!
	@IBOutlet weak var IM: NSTextField!
	@IBOutlet weak var R: NSTextField!
	@IBOutlet weak var I: NSTextField!
    @IBOutlet weak var PC: NSTextField!
	
	@IBOutlet weak var F_S: NSButton!
	@IBOutlet weak var F_Z: NSButton!
	@IBOutlet weak var F_5: NSButton!
	@IBOutlet weak var F_H: NSButton!
	@IBOutlet weak var F_3: NSButton!
	@IBOutlet weak var F_P: NSButton!
	@IBOutlet weak var F_N: NSButton!
	@IBOutlet weak var F_C: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func update(z80Core: SwiftZ80Core, tStatesInCurrentFrame: Int) {
        A.stringValue = String(format: "%02X", (z80Core.A))
        F.stringValue = String(format: "%02X", (z80Core.F))
        B.stringValue = String(format: "%02X", (z80Core.B))
        C.stringValue = String(format: "%02X", (z80Core.C))
        D.stringValue = String(format: "%02X", (z80Core.D))
        E.stringValue = String(format: "%02X", (z80Core.E))
        H.stringValue = String(format: "%02X", (z80Core.H))
        L.stringValue = String(format: "%02X", (z80Core.L))
        IYh.stringValue = String(format: "%02X", (z80Core.IYh))
        IYl.stringValue = String(format: "%02X", (z80Core.IYl))
        IXh.stringValue = String(format: "%02X", (z80Core.IXh))
        IXl.stringValue = String(format: "%02X", (z80Core.IXl))
        
        A_A.stringValue = String(format: "%02X", (z80Core.A_))
        A_F.stringValue = String(format: "%02X", (z80Core.F_))
        A_B.stringValue = String(format: "%02X", (z80Core.B_))
        A_C.stringValue = String(format: "%02X", (z80Core.C_))
        A_D.stringValue = String(format: "%02X", (z80Core.D_))
        A_E.stringValue = String(format: "%02X", (z80Core.E_))
        A_H.stringValue = String(format: "%02X", (z80Core.H_))
        A_L.stringValue = String(format: "%02X", (z80Core.L_))
        
        IFF1.stringValue = String(format: "%02X", (z80Core.IFF1))
        IFF2.stringValue = String(format: "%02X", (z80Core.IFF2))
        tStates.stringValue = String(format: "%i", (tStatesInCurrentFrame))
        IM.stringValue = String(format: "%02X", (z80Core.IM))
        R.stringValue = String(format: "%02X", (z80Core.R))
        I.stringValue = String(format: "%02X", (z80Core.I))
        PC.stringValue = String(format: "%02X", (z80Core.PC))
        
        F_S.state = Int((z80Core.R1.F) & 0x80)
        F_Z.state = Int((z80Core.R1.F) & 0x40)
        F_H.state = Int((z80Core.R1.F) & 0x10)
        F_P.state = Int((z80Core.R1.F) & 0x04)
        F_N.state = Int((z80Core.R1.F) & 0x02)
        F_C.state = Int((z80Core.R1.F) & 0x01)
    }
    
}
