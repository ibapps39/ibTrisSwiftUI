//
//  Extensions.swift
//  ibTrisSwiftUI
//
//  Created by Ian Brown on 9/23/24.
//

import SwiftUI

extension GameModel {
    func startGame() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.activateGravity()
        }
    }
}
