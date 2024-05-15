//
//  CurrentBufferMetalView.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 15/05/24.
//

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
    @Binding var pixelData: [UInt8]
    let width: Int
    let height: Int

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

#if os(macOS)
    func makeNSView(context: Context) -> MTKView {
        let metalView = MTKView()
        metalView.device = MTLCreateSystemDefaultDevice()
        metalView.delegate = context.coordinator
        metalView.enableSetNeedsDisplay = true
        metalView.framebufferOnly = false
        return metalView
    }

    func updateNSView(_ nsView: MTKView, context: Context) {
        context.coordinator.update(pixelData: pixelData, width: width, height: height)
        nsView.setNeedsDisplay(nsView.bounds)
    }
    
   
#else
    func makeUIView(context: Context) -> MTKView {
        let metalView = MTKView()
        metalView.device = MTLCreateSystemDefaultDevice()
        metalView.delegate = context.coordinator
        metalView.enableSetNeedsDisplay = true
        metalView.framebufferOnly = false
        return metalView
    }

    func updateUIView(_ uiView: MTKView, context: Context) {
        context.coordinator.update(pixelData: pixelData, width: width, height: height)
        uiView.setNeedsDisplay()
    }
#endif

    class Coordinator: NSObject, MTKViewDelegate {
        var parent: CurrentBufferMetalView
        var commandQueue: MTLCommandQueue!
        var pipelineState: MTLRenderPipelineState!
        var texture: MTLTexture?

        init(_ parent: CurrentBufferMetalView) {
            self.parent = parent
            super.init()
            setupMetal()
        }
        
        deinit {
            cleanup()
        }

        func setupMetal() {
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

        func update(pixelData: [UInt8], width: Int, height: Int) {
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
        
        func cleanup() {
            texture = nil
            pipelineState = nil
            commandQueue = nil
        }
    }
}



/*
 #Preview {
 let yourPixelData: [UInt8] = [
 255, 255, 0, 0,    // Red pixel
 255, 0, 255, 0,    // Green pixel
 255, 0, 0, 255,    // Blue pixel
 255, 255, 255, 0,  // Yellow pixel
 ]
 let yourWidth = 2
 let yourHeight = 2
 CurrentBufferMetalView(pixelData: .constant(yourPixelData), width: yourWidth, height: yourHeight)
 }
 */
