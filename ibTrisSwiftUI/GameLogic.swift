//
//  GameLogic.swift
//  ibTrisSwiftUI
//
//  Created by Ian Brown on 9/23/24.
//

import SwiftUI

class GameModel: ObservableObject {
    @Published var currentTetromino: Tetromino?
    
    let gravity: Int = 1
    
    init() {
        spawnTetromino()
        activateGravity()
    }
    
    func spawnTetromino() {
        let tetromino = TetrominoType.allCases.randomElement()!
        currentTetromino = Tetromino(type: tetromino)
    }
    
    func activateGravity() {
        guard let currentTetromino = self.currentTetromino else { return }
        let newPosition = currentTetromino.position.map {
            ($0.row + 1, $0.column)
        }
        if canMove(to: newPosition) {
            self.currentTetromino?.position = newPosition
        } else {
            lockTetromino(currentTetromino)
            spawnTetromino()
        }
    }
    private func canMove(to newPosition: [(row: Int, column: Int)]) -> Bool {
        for (row, column) in newPosition {
            // will it stop if you touch wall?
            if row >= 20 || column >= 10 || column < 0 || row < 0 {
                return false
            }
        }
        return true
    }
    
    private func lockTetromino(_ tetromino: Tetromino) {
        for position in tetromino.position {
            return
        }
    }
    
    func moveTetromino() {
        
    }
    
    func rotateTetromino() {
        
    }
    
}


