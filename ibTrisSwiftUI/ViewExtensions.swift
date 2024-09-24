//
//  ViewExtensions.swift
//  ibTrisSwiftUI
//
//  Created by Ian Brown on 9/23/24.
//

import SwiftUI
import Swift

extension View {
    func metalShader() -> some View {
        modifier(MetalShader())
    }
}

struct MetalShader: ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}
