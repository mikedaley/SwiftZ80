//
//  AudioCore.swift
//  SwiftZ80
//
//  Created by Mike Daley on 22/08/2016.
//  Copyright © 2016 71Squared Ltd. All rights reserved.
//

import AVFoundation

class AudioCore {
	
	let audioEngine: AVAudioEngine
	let playerNode: AVAudioPlayerNode
	let mixerNode: AVAudioMixerNode
	let buffers: NSMutableArray = []
	
	var totalBuffers = 0
	var currentBuffer = 0
	var currentBufferPosition = 0
	var lastScheduledBuffer = 0
	var frameCapacity: Double = 0
	
	init(sampleRate: Double, framesPerSecond: Double) {
	
		frameCapacity = (sampleRate / framesPerSecond) - 1
		
		audioEngine = AVAudioEngine()
		playerNode = AVAudioPlayerNode()
		mixerNode = audioEngine.mainMixerNode
		mixerNode.outputVolume = 0.1
		
		let audioFormat = AVAudioFormat.init(commonFormat: AVAudioCommonFormat.PCMFormatFloat32, sampleRate: sampleRate, channels: 1, interleaved: false)
		totalBuffers = 64
		
		for _ in 0 ..< totalBuffers {
			let buffer = AVAudioPCMBuffer.init(PCMFormat: audioFormat, frameCapacity: UInt32(frameCapacity))
			buffer.frameLength = UInt32(frameCapacity)
			buffers.addObject(buffer)
		}
		
		audioEngine.attachNode(playerNode)
		audioEngine.connect(playerNode, to: mixerNode, format: audioFormat)
		do {
			try audioEngine.start()
		} catch {
			print("Failed to start the audio engine")
		}
		playerNode.play()
		
		currentBuffer = 0
		currentBufferPosition = 0
	}
	
	func updateBeeperWithValue(value: Float) {
		
		let buffer = buffers.objectAtIndex(currentBuffer)
		let data = buffer.floatChannelData[0]
		data[currentBufferPosition] = value * 0.003
		
		currentBufferPosition += 1
		
		if currentBufferPosition > Int(frameCapacity) {
			playerNode.scheduleBuffer(buffer as! AVAudioPCMBuffer, completionHandler: nil)
			currentBufferPosition = 0
			currentBuffer = (currentBuffer + 1) % totalBuffers
		}

	}
	
}