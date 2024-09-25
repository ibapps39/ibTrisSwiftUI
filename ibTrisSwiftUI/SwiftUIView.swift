//
//  SwiftUIView.swift
//  ibTrisSwiftUI
//
//  Created by Ian Brown on 9/24/24.
//

import SwiftUI

struct SwiftUIView: View {
    @State private var rect1Color = Color.blue
    @State private var rect2Color = Color.red

    @State private var rect1Position = CGRect.zero
    @State private var rect2Position = CGRect.zero

    var body: some View {
        ZStack {
            Rectangle()
                .fill(rect1Color)
                .frame(width: 100, height: 100)
                .position(x: 150, y: 200)
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                rect1Position = geometry.frame(in: .global)
                            }
                            .onChange(of: rect1Position) { _ in
                                checkForTouch()
                            }
                    }
                )

            Rectangle()
                .fill(rect2Color)
                .frame(width: 100, height: 100)
                .position(x: 300, y: 200)
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                rect2Position = geometry.frame(in: .global)
                            }
                            .onChange(of: rect2Position) { _ in
                                checkForTouch()
                            }
                    }
                )
        }
        .onAppear {
            rect1Position = CGRect(x: 150, y: 200, width: 100, height: 100)
            rect2Position = CGRect(x: 300, y: 200, width: 100, height: 100)
        }
    }
    
    private func checkForTouch() {
        if rect1Position.intersects(rect2Position) {
            rect1Color = Color.green
            rect2Color = Color.green
        } else {
            rect1Color = Color.blue
            rect2Color = Color.red
        }
    }
}

#Preview {
    SwiftUIView()
}



extension CGRect {
    func intersects(_ rect: CGRect) -> Bool {
        return self.maxX > rect.minX &&
               self.minX < rect.maxX &&
               self.maxY > rect.minY &&
               self.minY < rect.maxY
    }
}

