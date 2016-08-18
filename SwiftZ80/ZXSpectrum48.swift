//
//  ZXSpectrum48.swift
//  SwiftZ80
//
//  Created by Mike Daley on 13/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

import Foundation

class ZXSpectrum48 {
    
    var tStatesPerFrame = 69888
    
    var memory = [Byte](count: 65536, repeatedValue: 0x00)
    var core: SwiftZ80Core?
    
    var tStatesInCurrentFrame: Int = 0
    
    init() {
        
        core = SwiftZ80Core.init(memoryRead: readFromMemoryAddress,
                                 memoryWrite: writeToMemoryAddress,
                                 ioRead: ioReadAddress,
                                 ioWrite: ioWriteAddress,
                                 contentionReadNoMREQ: contentionReadNoMREQAddress,
                                 contentionWriteNoMREQ: contentionWriteNoMREQAddress,
                                 contentionRead: contentionReadAddress)
        
        self.loadROM()
    }
    
    /**
     * Core execution
     */
    
    func execute() -> (Int) {
        let currentTStates = core!.tStates
        if core!.PC == 0x120c {
            print("BREAK")
        }
        core!.execute()
        return core!.tStates - currentTStates
    }
    
    func step() -> (Int) {
        let cpuStates = self.execute()
        tStatesInCurrentFrame += cpuStates
        if tStatesInCurrentFrame >= tStatesPerFrame {
            tStatesInCurrentFrame -= tStatesPerFrame
        }
        return cpuStates
    }
    
    func runFrame() {
        var count = tStatesPerFrame
        while count > 0 {
            count -= self.step()
        }
    }
    
    /**
     * Load ROM
     */
    
    func loadROM() {
        let path = NSBundle.mainBundle().pathForResource("48", ofType: "ROM")
        let data = NSData.init(contentsOfFile: path!)
        let count = data!.length / sizeof(Byte)
        var fileBytes = [Byte](count: count, repeatedValue: 0x00)
        
        data!.getBytes(&fileBytes, length: count * sizeof(Byte))
        
        for i in 0..<data!.length {
            memory[i] = fileBytes[i]
        }
    }
    
    /**
     * SnapShot loading
     */
    
    func loadSnapShot(path: String) {
        
        let data = NSData.init(contentsOfFile: path)
        let count = data!.length / sizeof(Byte)
        var fileBytes = [Byte](count: count, repeatedValue: 0x00)
        
        data!.getBytes(&fileBytes, length: count * sizeof(Byte))
        
        if data?.length == 49179 {
            
            var snaAddr = 27
            for i in 16384..<(48 * 1024) {
                memory[i] = fileBytes[snaAddr]
                snaAddr += 1
            }
            
        }
        
    }
    
    
    /**
     * Memory and IO routines
     */
    
    func readFromMemoryAddress(address: Word) -> Byte {
        core!.tStates += 3
        return memory[address]
    }
    
    func writeToMemoryAddress(address: Word, value: Byte) {
        core!.tStates += 3
        memory[address] = value
    }
    
    func ioReadAddress(address: Word) -> Byte {
        return 0xff
    }
    
    func ioWriteAddress(address: Word, value: Byte) {

    }
    
    func contentionReadNoMREQAddress(address: Word, tStates: Int) {
//        core!.tStates += tStates
    }
    
    func contentionWriteNoMREQAddress(address: Word, tStates: Int) {
//        core!.tStates += tStates
    }
    
    func contentionReadAddress(address: Word, tStates: Int) {
//        core!.tStates += tStates
    }
    
    
}