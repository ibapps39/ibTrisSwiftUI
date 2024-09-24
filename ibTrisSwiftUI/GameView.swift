//
//  GameView.swift
//  ibTrisSwiftUI
//
//  Created by Ian Brown on 9/23/24.
//

import SwiftUI

struct GridView: View {  // Renamed to GridView
    var grid: [[Int]]
    
    var body: some View {
        VStack {
            ForEach(0..<grid.count, id: \.self) { row in
                HStack {
                    ForEach(0..<grid[row].count, id: \.self) { column in
                        Rectangle()
                            .fill(grid[row][column] == 0 ? Color.clear : Color.blue)
                            .frame(width: 30, height: 30)
                            .border(Color.gray)
                    }
                }
            }
        }
    }
}

