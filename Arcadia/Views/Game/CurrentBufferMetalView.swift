
import ArcadiaCore
import SwiftUI
import MetalKit

struct CurrentBufferMetalView: PlatformViewRepresentable {

    @Environment(ArcadiaCoreEmulationState.self) var emulationState: ArcadiaCoreEmulationState

    func makeCoordinator() -> Coordinator {
        Coordinator(self, renderer: emulationState.metalRendered)
    }
    
    func makeMetalView(context: Context) -> MTKView {
        print("makeMetalView called")
        let metalView = MTKView()
        metalView.device = MTLCreateSystemDefaultDevice()
        metalView.delegate = context.coordinator.metalRenderer
        metalView.enableSetNeedsDisplay = true
        metalView.framebufferOnly = false
        metalView.preferredFramesPerSecond = 60
        metalView.isPaused = false // Ensure the view is not paused
        return metalView
    }

#if os(macOS)
    func makeNSView(context: Context) -> MTKView {
        return makeMetalView(context: context)
    }

    func updateNSView(_ nsView: MTKView, context: Context) {
        DispatchQueue.main.async {
            nsView.setNeedsDisplay(nsView.bounds)
        }
    }
#else
    func makeUIView(context: Context) -> MTKView {
        return makeMetalView(context: context)
    }

    func updateUIView(_ uiView: MTKView, context: Context) {
        DispatchQueue.main.async {
            uiView.setNeedsDisplay()
        }
    }
#endif

    class Coordinator: NSObject {
        var parent: CurrentBufferMetalView
        var metalRenderer: ArcadiaCoreMetalRenderer

        init(_ parent: CurrentBufferMetalView, renderer: ArcadiaCoreMetalRenderer) {
            self.parent = parent
            self.metalRenderer = renderer
            super.init()
        }
    }
}


