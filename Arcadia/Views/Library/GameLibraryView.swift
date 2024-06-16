//
//  GameLibraryView.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 07/05/24.
//

import SwiftUI

struct GameLibraryView: View {
    @State private var system: ArcadiaGameType?
    
    var body: some View {

        NavigationSplitView {
            List(ArcadiaGameType.allCases, selection: $system) { gameType in
                NavigationLink(value: gameType) {
                    GameSystemRowView(gameSystem: gameType)
                        .focusable()
                }
            }
            .navigationTitle("Game Systems")
        } detail: {
            if let selectedSystem = system {
                NavigationStack {
                    GameCollectionView(gameType: selectedSystem)
                        .id(selectedSystem.id)
                }

            } else {
                Text("Select a system")
            }
        }
        

    }
}

#Preview {
    GameLibraryView()
}
