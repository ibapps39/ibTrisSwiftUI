//
//  GridView.swift
//  ibTrisSwiftUI
//
//  Created by Ian Brown on 9/23/24.
//

import SwiftUI

struct Grid {
    // height
    let rows: Int
    // length
    let columns: Int
    var grid: [[Int]]
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        self.grid = Array(repeating:
                            Array(repeating: 0, count: columns),
                          count: rows)
    }
}

struct GridView: View {
    @State private var grid: Grid = Grid(rows: 20, columns: 10)
    
    @ObservedObject var gameModel = GameModel()
    
    let cellSize: CGFloat = 25
    
    var body: some View {
        VStack {
            ForEach(0..<grid.rows, id:\.self) { row in
                HStack {
                    ForEach(0..<grid.columns, id: \.self) { column in
                        Rectangle()
                            .fill(self.cellColor(forRow: row, column: column))
                            .frame(width: cellSize, height: cellSize)
                    }
                }
            }
        }
        .padding()
    }
    private func cellColor(forRow row: Int, column: Int) -> Color {
        // Check if the current tetromino is present at the given grid position
        if let currentTetromino = gameModel.currentTetromino {
            for position in currentTetromino.position {
                if position.row == row && position.column == column {
                    return currentTetromino.type.color
                }
            }
        }
        return Color.blue // Default color for empty cells
    }
}
