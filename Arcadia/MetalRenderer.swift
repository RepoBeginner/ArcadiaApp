import ArcadiaCore

import MetalKit
class MetalRenderer: NSObject {
    
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    var vertexBuffer: MTLBuffer!
    var pipelineState: MTLRenderPipelineState!
    var texture: MTLTexture!
    var pixels = [UInt8]()
    
    
    init(metalView: MTKView) {
        guard let device = MTLCreateSystemDefaultDevice(), let commandQueue = device.makeCommandQueue() else {
            fatalError("GPU not available")
        }
        MetalRenderer.device = device
        MetalRenderer.commandQueue = commandQueue
        metalView.device = device
        
        // Library
        let library = device.makeDefaultLibrary()
        MetalRenderer.library = library
        let vertexFunction = library?.makeFunction(name: "vertexShader")
        let fragmentFunction = library?.makeFunction(name: "fragmentShader")
        
        //Pipeline State
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm

        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error {
            fatalError(error.localizedDescription)
        }
        
        super.init()
        metalView.delegate = self
    }
}

extension MetalRenderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        //TODO: This function should probably be triggered by the game loop (?)
        guard
            let device = MetalRenderer.device,
            let commandBuffer = MetalRenderer.commandQueue.makeCommandBuffer(),
            let descriptor = view.currentRenderPassDescriptor,
            let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        else {return}
        
        renderEncoder.setRenderPipelineState(pipelineState)
        
        // Create the texture with UInt8 Data
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm, width: 160, height: 144, mipmapped: false)
        textureDescriptor.usage = [.shaderRead, .renderTarget]
        texture = device.makeTexture(descriptor: textureDescriptor)
        let region = MTLRegionMake2D(0, 0, 160, 144)
        texture.replace(region: region, mipmapLevel: 0, withBytes: ArcadiaCoreEmulationState.sharedInstance.mainBuffer, bytesPerRow: 4 * 160)
        
        renderEncoder.setFragmentTexture(texture, index: 0)
        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
        renderEncoder.endEncoding()
        
        guard let drawable = view.currentDrawable else {
            return
        }
        
        commandBuffer.present(drawable)
        commandBuffer.commit()


    }
    
}
