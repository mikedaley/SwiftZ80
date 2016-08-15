//
//  SwifZ80CoreExtensions.swift
//  SwiftZ80
//
//  Created by Mike Daley on 03/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

extension SwiftZ80Core {
	
	func debug() {
		
		print("PC: \(PC.toHexString) : SP: \(SP.toHexString)\n")
		print("SZ5H3PNC")
		print(F.toBinaryString + "\n")
		print("A:  \(A.toHexString)   -   F: \(F.toHexString)")
		print("BC: \(BC.toHexString) -   B: \(B.toHexString)   -   C: \(C.toHexString)")
		print("DE: \(DE.toHexString) -   D: \(B.toHexString)   -   E: \(E.toHexString)")
		print("HL: \(HL.toHexString) -   H: \(B.toHexString)   -   L: \(L.toHexString)")
		print("IX: \(IX.toHexString) - IXh: \(IXh.toHexString)   - IXl: \(IXh.toHexString)")
		print("IY: \(IY.toHexString) - IYh: \(IYh.toHexString)   - IYl: \(IYl.toHexString)\n")
		print("IM:   \(IM.toHexString)")
		print("IFF1: \(IFF1.toHexString)")
		print("T-States: \(tStates)")
		print("----------------------------------------")
		
	}
	

	
}
