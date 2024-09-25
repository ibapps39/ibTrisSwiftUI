//
//  Tetromino.swift
//  ibTrisSwiftUI
//
//  Created by Ian Brown on 9/23/24.
//

import SwiftUI

enum TetrominoType : CaseIterable {
    case I, LL, LR, ZR, ZL, T
    
    var color : Color {
        switch self {
        case .I: return Color.cyan
        case .LL: return Color.mint
        case .LR: return Color.green
        case .ZR: return Color.red
        case .ZL: return Color.orange
        case .T: return Color.purple
        }
    }
}

struct Tetromino {
    var type: TetrominoType
    var position: [(row: Int, column: Int)]
    
    //make more dynamic later if ever
    init(type: TetrominoType) {
        self.type = type
        switch type {
        case .I:
            self.position = [(0,4), (1,4), (2,4), (3,4)]
        case .LL:
            self.position = [(0,4), (1,4), (2,4), (2,3)]
        case .LR:
            self.position = [(0,4), (1,4), (2,4), (2,5)]
        case .ZR:
            self.position = [(0,4), (0,5), (1,4), (1,3)]
        case .ZL:
            self.position = [(0,4), (0,5), (1,5), (1,6)]
        case .T:
            self.position = [(0,3), (0,4), (0,5), (1,4)]
        }
        
    }
}
