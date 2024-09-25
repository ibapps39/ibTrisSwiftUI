//
//  ContentView.swift
//  ibTrisSwiftUI
//
//  Created by Ian Brown on 9/23/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var gameModel = GameModel()
    var body: some View {
        GridView()
    }
}


#Preview {
    ContentView()
}
