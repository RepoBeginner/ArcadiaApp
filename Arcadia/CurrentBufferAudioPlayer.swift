//
//  CurrentBufferAudioPlayer.swift
//  Arcadia
//
//  Created by Davide Andreoli on 17/05/24.
//

import AVFoundation

class CurrentBufferAudioPlayer {
    private var audioEngine: AVAudioEngine
    private var playerNode: AVAudioPlayerNode
    private var audioFormat: AVAudioFormat

    init() {
        audioEngine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()

        let sampleRate: Double = 44100
        let channels: AVAudioChannelCount = 2 // Two channels for stereo

        // Use Float32 format with interleaved data
        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: channels) else {
            fatalError("Failed to create audio format")
        }
        audioFormat = format

        audioEngine.attach(playerNode)
        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: audioFormat)
    }

    func start() {
        do {
            try audioEngine.start()
            playerNode.play()
        } catch {
            print("Error starting audio engine: \(error)")
        }
    }

    func updateBuffer(with audioData: [Int16]) {
        let frameCount = AVAudioFrameCount(audioData.count / 2)
        
        guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: frameCount) else {
            print("Failed to create PCM buffer with frame capacity \(frameCount)")
            return
        }
        buffer.frameLength = frameCount

        // Access the audioBufferList directly for interleaved data
        guard let audioBuffer = buffer.audioBufferList.pointee.mBuffers.mData else {
            print("Failed to get audio buffer data")
            return
        }

        // Get a pointer to the interleaved Float32 data
        let floatBuffer = audioBuffer.bindMemory(to: Float32.self, capacity: Int(buffer.frameLength) * Int(audioFormat.channelCount))

        // Convert Int16 data to Float32 and fill the interleaved buffer
        for i in 0..<Int(buffer.frameLength) {
            floatBuffer[2 * i] = Float32(audioData[2 * i]) / Float32(Int16.max)
            floatBuffer[2 * i + 1] = Float32(audioData[2 * i + 1]) / Float32(Int16.max)
        }

        playerNode.scheduleBuffer(buffer, completionHandler: nil)
    }
}

