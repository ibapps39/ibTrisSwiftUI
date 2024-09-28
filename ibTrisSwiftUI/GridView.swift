//
//  GridView.swift
//  ibTrisSwiftUI
//
//  Created by Ian Brown on 9/23/24.
//

import SwiftUI

struct Grid {
    let rows: Int
    let columns: Int
    var grid: [[Int]]
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        self.grid = Array(repeating: Array(repeating: 0, count: columns), count: rows)
    }
}

struct GridView: View {
    @StateObject private var gameModel = GameModel()
    @State private var lastDragValue: CGSize = .zero // Track last drag position
    let cellSize: CGFloat = 25
    private let dragThreshold: CGFloat = 30 // Set a threshold for dragging
    private let verticalFlickThreshold: CGFloat = 2
    private let flickDragTimeThresold: CGFloat = 0.5
    let gridColor: Color = Color.gray
    
    var body: some View {
        ZStack {
            Color.black
            VStack {
                if gameModel.gameOver {
                    Text("Game Over")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                        .padding()
                    Button(action: gameModel.resetGame) {
                        Text("Restart?")
                    }
                } else {
                    ForEach(0..<gameModel.grid.rows, id: \.self) { row in
                        HStack {
                            ForEach(0..<gameModel.grid.columns, id: \.self) { column in
                                Rectangle()
                                    .fill(self.cellColor(forRow: row, column: column))
                                    .frame(width: cellSize, height: cellSize)
                                    .overlay(
                                        // Add landing preview
                                        self.landingPreview(forRow: row, column: column)
                                    )
                            }
                        }
                    }
                }
            }
            .padding()
            .gesture(
                TapGesture()
                    .onEnded {
                        gameModel.rotateTetromino()
                    }
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if gameModel.isDragTimerNil() {
                            gameModel.resetDragDuration()
                            gameModel.startDragTimer()
                        }
                        
                        let newDragValue = value.translation
                        
                        // Calculate deltas
                        let horizontalDelta = newDragValue.width - lastDragValue.width
                        let verticalDelta = newDragValue.height - lastDragValue.height
                        
                        // Handle horizontal movement with a threshold
                        if abs(horizontalDelta) > dragThreshold {
                            let direction = horizontalDelta > 0 ? 1 : -1
                            gameModel.moveTetromino(direction: direction)
                            
                            // Reset lastDragValue to allow for continuous dragging
                            lastDragValue.width = newDragValue.width
                        }
                        
                        // Handle vertical movement with a threshold
                        if verticalDelta > dragThreshold {
                            gameModel.activateGravity()
                            
                            // Reset lastDragValue to allow for continuous dragging
                            lastDragValue.height = newDragValue.height
                        }
                    }
                    .onEnded { value in
                        gameModel.stopDragTimer()
                        let dragDuration = gameModel.getDragDuration()
                        let velocityY = value.velocity.height
                        
                        if velocityY > verticalFlickThreshold && flickDragTimeThresold < 1 {
                            gameModel.currentTetromino?.position = gameModel.calculateLandingPosition()
                            gameModel.setAndPlaceTetromino()
                        }
                        // Redundant yes, but not sure why not
                        gameModel.resetDragDuration()
                        lastDragValue = .zero // Reset on drag end
                    }
            )
        }
        Button(action: {
            gameModel.rotateTetromino() // Call rotation on button press
        }) {
            Text("Rotate 45°")
                .font(.title)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
    private func cellColor(forRow row: Int, column: Int) -> Color {
        if let currentTetromino = gameModel.currentTetromino {
            for position in currentTetromino.position {
                if position.row == row && position.column == column {
                    return currentTetromino.type.color
                }
            }
        }
        // Check for locked positions
        if gameModel.grid.grid[row][column] != 0 {
            return Color.black // Color for locked cells (you can customize this)
        }
        return gridColor // Default color for empty cells
    }
    private func landingPreview(forRow row: Int, column: Int) -> some View {
        guard let currentTetromino = gameModel.currentTetromino else {
            return AnyView(EmptyView())
        }
        let landingPositions = gameModel.calculateLandingPosition()
        
        if landingPositions.contains(where: { $0.row == row && $0.column == column }) {
            return AnyView(
                Rectangle()
                    .fill(currentTetromino.type.color.opacity(0.5)) // Color for the landing preview
                    .frame(width: cellSize, height: cellSize)
            )
        }
        return AnyView(EmptyView())
    }
}
