import MetalKit
import ArcadiaCore

class CurrentBufferMetalRenderer: NSObject, MTKViewDelegate {
    var commandQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState!
    var texture: MTLTexture?

    override init() {
        super.init()
        setupMetal()
    }

    private func setupMetal() {
        guard let device = MTLCreateSystemDefaultDevice() else { return }
        commandQueue = device.makeCommandQueue()
        
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertexShader")
        let fragmentFunction = library?.makeFunction(name: "fragmentShader")

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm

        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            print("Failed to create pipeline state: \(error)")
        }
    }

    func updateTexture(with pixelData: [UInt8], width: Int, height: Int) {
        guard let device = MTLCreateSystemDefaultDevice() else { return }

        let textureDescriptor = MTLTextureDescriptor()
        textureDescriptor.pixelFormat = .bgra8Unorm
        textureDescriptor.width = width
        textureDescriptor.height = height
        textureDescriptor.usage = .shaderRead

        texture = device.makeTexture(descriptor: textureDescriptor)
        let region = MTLRegionMake2D(0, 0, width, height)
        texture?.replace(region: region, mipmapLevel: 0, withBytes: pixelData, bytesPerRow: 4 * width)
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // Handle view size changes if necessary
    }

    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let descriptor = view.currentRenderPassDescriptor else { return }

        let commandBuffer = commandQueue.makeCommandBuffer()
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)

        renderEncoder?.setRenderPipelineState(pipelineState)
        renderEncoder?.setFragmentTexture(texture, index: 0)
        renderEncoder?.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)

        renderEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}

import SwiftUI
import MetalKit
import AVFoundation

#if os(macOS)
typealias PlatformViewRepresentable = NSViewRepresentable
import AppKit
#else
typealias PlatformViewRepresentable = UIViewRepresentable
import UIKit
#endif

struct CurrentBufferMetalView: PlatformViewRepresentable {
    @Binding var pixelData: [UInt8]
    @Binding var audioData: [Int16]
    let width: Int
    let height: Int

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

#if os(macOS)
    func makeNSView(context: Context) -> MTKView {
        let metalView = MTKView()
        metalView.device = MTLCreateSystemDefaultDevice()
        metalView.delegate = context.coordinator.metalRenderer
        metalView.enableSetNeedsDisplay = true
        metalView.framebufferOnly = false
        return metalView
    }

    func updateNSView(_ nsView: MTKView, context: Context) {
        context.coordinator.update(pixelData: pixelData, audioData: audioData, width: width, height: height)
        nsView.setNeedsDisplay(nsView.bounds)
    }
#else
    func makeUIView(context: Context) -> MTKView {
        let metalView = MTKView()
        metalView.device = MTLCreateSystemDefaultDevice()
        metalView.delegate = context.coordinator.metalRenderer
        metalView.enableSetNeedsDisplay = true
        metalView.framebufferOnly = false
        return metalView
    }

    func updateUIView(_ uiView: MTKView, context: Context) {
        context.coordinator.update(pixelData: pixelData, audioData: audioData, width: width, height: height)
        uiView.setNeedsDisplay()
    }
#endif

    class Coordinator: NSObject {
        var parent: CurrentBufferMetalView
        var audioPlayer: CurrentBufferAudioPlayer
        var metalRenderer: CurrentBufferMetalRenderer

        init(_ parent: CurrentBufferMetalView) {
            self.parent = parent
            self.audioPlayer = CurrentBufferAudioPlayer()
            self.metalRenderer = CurrentBufferMetalRenderer()
            super.init()
            audioPlayer.start()
        }

        func update(pixelData: [UInt8], audioData: [Int16], width: Int, height: Int) {
            // Update texture
            metalRenderer.updateTexture(with: pixelData, width: width, height: height)

            // Update audio data
            audioPlayer.updateBuffer(with: audioData)
        }
    }
}


class CurrentBufferAudioPlayer {
    private var audioEngine: AVAudioEngine
    private var playerNode: AVAudioPlayerNode
    private var audioFormat: AVAudioFormat

    init() {
        audioEngine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()

        let sampleRate: Double = 32768.0
        let channels: AVAudioChannelCount = 2 // Two channels for stereo
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

        guard let channelDataLeft = buffer.int16ChannelData?[0], let channelDataRight = buffer.int16ChannelData?[1] else {
            print("Failed to get channel data pointers")
            return
        }

        // Fill the buffer with interleaved stereo audio data
        for i in 0..<Int(buffer.frameLength) {
            channelDataLeft[i] = audioData[2 * i]
            channelDataRight[i] = audioData[2 * i + 1]
        }

        playerNode.scheduleBuffer(buffer, completionHandler: nil)
    }
}
