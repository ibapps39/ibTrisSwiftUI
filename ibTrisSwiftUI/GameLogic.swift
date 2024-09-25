//
//  GameLogic.swift
//  ibTrisSwiftUI
//
//  Created by Ian Brown on 9/23/24.
//

import SwiftUI
import Combine

class GameModel: ObservableObject {
    @Published var currentTetromino: Tetromino?
    @Published var grid: Grid
    @Published var gameOver: Bool = false
    private var timer: AnyCancellable?
    let gravityInterval: TimeInterval = 0.5

    init() {
        self.grid = Grid(rows: 20, columns: 10)
        spawnTetromino()
        startGravityTimer()
    }

    private func startGravityTimer() {
        timer = Timer.publish(every: gravityInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.activateGravity()
            }
    }

    func spawnTetromino() {
        let tetromino = TetrominoType.allCases.randomElement()!
        let newTetromino = Tetromino(type: tetromino)

        if canMove(to: newTetromino.position) {
            currentTetromino = newTetromino
        } else {
            gameOver = true
            timer?.cancel()
        }
    }
    
    func activateGravity() {
        guard let currentTetromino = self.currentTetromino else { return }
        let newPosition = currentTetromino.position.map { (row: $0.row + 1, column: $0.column) }
        
        if canMove(to: newPosition) {
            self.currentTetromino?.position = newPosition
        } else {
            // Lock the current tetromino into place
            lockTetromino(currentTetromino)
            // Check for completed lines here if needed
            clearFullLines() // Optional: Implement this to clear full lines
            // Spawn a new tetromino
            spawnTetromino()
        }
    }

    func moveTetromino(direction: Int) {
        guard let currentTetromino = self.currentTetromino else { return }
        let newPosition = currentTetromino.position.map {
            (row: $0.row, column: $0.column + direction) // Move left (-1) or right (+1)
        }
        
        if canMove(to: newPosition) {
            self.currentTetromino?.position = newPosition
        }
    }

    private func canMove(to newPosition: [(row: Int, column: Int)]) -> Bool {
        for (row, column) in newPosition {
            if row >= grid.rows || column >= grid.columns || column < 0 || row < 0 {
                return false
            }
            if grid.grid[row][column] != 0 {
                return false
            }
        }
        return true
    }

    private func lockTetromino(_ tetromino: Tetromino) {
        for position in tetromino.position {
            // Mark the position in the grid (you can use a different value for locked blocks)
            grid.grid[position.row][position.column] = 1
        }
        // Optionally, you can also set currentTetromino to nil after locking
        self.currentTetromino = nil
    }

    deinit {
        timer?.cancel()
    }
    
    func rotateTetromino() {
        guard let currentTetromino = self.currentTetromino else { return }
        
        // Calculate the center of the current tetromino
        let centerRow = currentTetromino.position.map { $0.row }.min()! + 1 // Assuming the center is just below the topmost row
        let centerColumn = currentTetromino.position.map { $0.column }.min()! + 1 // Adjust accordingly

        // Calculate the new rotated position based on the center
        let rotatedPosition = currentTetromino.position.map { (pos) -> (row: Int, column: Int) in
            let x = pos.column - centerColumn
            let y = pos.row - centerRow
            
            // Apply rotation
            return (row: centerRow - x, column: centerColumn + y)
        }

        // Check if the rotated position is valid
        if canMove(to: rotatedPosition) {
            self.currentTetromino?.position = rotatedPosition
        }
    }
    
    func resetGame() {
        self.grid = Grid(rows: 20, columns: 10) // Reset the grid
        self.gameOver = false // Reset the game over state
        spawnTetromino() // Spawn a new tetromino
        startGravityTimer() // Restart the gravity timer
    }

    private func clearFullLines() {
        for row in (0..<grid.rows).reversed() {
            if grid.grid[row].allSatisfy({ $0 != 0 }) {
                // Remove the line
                grid.grid.remove(at: row)
                // Add a new empty row at the top
                grid.grid.insert(Array(repeating: 0, count: grid.columns), at: 0)
            }
        }
    }
}
