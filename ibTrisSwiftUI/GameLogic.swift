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
    
    private var dragTimer: Timer?
    private var dragDuration:TimeInterval = 0
    
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
    
    // Initiate here/in a function to recreate the timer (otherwise, we'd only make one on init()
    func startDragTimer() {
        dragTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.dragDuration += 0.1
        }
    }
    func resetDragDuration() {
        dragDuration = 0
    }
    func getDragDuration() -> TimeInterval {
        return dragDuration
    }
    
    func isDragTimerNil() -> Bool {
        return dragTimer == nil
    }
    
    func stopDragTimer() {
        dragTimer?.invalidate()
        // frees dragTimer to be reassigned
        dragTimer = nil
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
    
    func calculateLandingPosition() -> [(row: Int, column: Int)] {
        guard let currentTetromino = currentTetromino else { return [] }
        var landingPosition = currentTetromino.position
        
        // Keep moving down until it can no longer move
        while canMove(to: landingPosition.map { (row: $0.row + 1, column: $0.column) }) {
            landingPosition = landingPosition.map { (row: $0.row + 1, column: $0.column) }
        }
        
        return landingPosition
    }
    
    func setAndPlaceTetromino() {
        guard let currentTetromino = self.currentTetromino else { return }
        lockTetromino(currentTetromino)
        spawnTetromino()
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
