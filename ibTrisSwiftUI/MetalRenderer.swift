//
//  MetalRenderer.swift
//  ibTrisSwiftUI
//
//  Created by Ian Brown on 9/23/24.
//

import Metal

class  MetalRenderer {
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState!
    
    init(device: MTLDevice!, commandQueue: MTLCommandQueue!, pipelineState: MTLRenderPipelineState!) {
        setupMetal()
    }
    
    private func setupMetal() {
        device = MTLCreateSystemDefaultDevice()
        commandQueue = device.makeCommandQueue()
    }
}
