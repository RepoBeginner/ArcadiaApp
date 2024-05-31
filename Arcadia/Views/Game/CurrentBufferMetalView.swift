
import ArcadiaCore
import SwiftUI
import MetalKit

#if os(macOS)
typealias PlatformViewRepresentable = NSViewRepresentable
import AppKit
#else
typealias PlatformViewRepresentable = UIViewRepresentable
import UIKit
#endif

struct CurrentBufferMetalView: PlatformViewRepresentable {

    let width: Int
    let height: Int
    @Environment(ArcadiaCoreEmulationState.self) var emulationState: ArcadiaCoreEmulationState

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeMetalView(context: Context) -> MTKView {
        let metalView = MTKView()
        metalView.device = MTLCreateSystemDefaultDevice()
        metalView.delegate = context.coordinator.metalRenderer
        metalView.enableSetNeedsDisplay = true
        metalView.framebufferOnly = false
        metalView.preferredFramesPerSecond = 60
        return metalView
    }

#if os(macOS)
    func makeNSView(context: Context) -> MTKView {
        return makeMetalView(context: context)
    }

    func updateNSView(_ nsView: MTKView, context: Context) {
        context.coordinator.update(pixelData: pixelData, audioData: audioData, width: width, height: height)
        DispatchQueue.main.async {
            nsView.setNeedsDisplay(nsView.bounds)
        }
    }
#else
    func makeUIView(context: Context) -> MTKView {
        return makeMetalView(context: context)
    }

    func updateUIView(_ uiView: MTKView, context: Context) {
        context.coordinator.update(pixelData: emulationState.mainBuffer, audioData: emulationState.currentAudioFrameFloat, width: width, height: height)
        DispatchQueue.main.async {
            uiView.setNeedsDisplay()
        }
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

        func update(pixelData: [UInt8], audioData: [Float32], width: Int, height: Int) {
            // Update texture
            metalRenderer.updateTexture(with: pixelData, width: width, height: height)

            // Update audio data
            audioPlayer.updateBuffer(with: audioData)
        }
    }
}

