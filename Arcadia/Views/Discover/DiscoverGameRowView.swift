//
//  DiscoverGameRowView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 28/08/24.
//

import SwiftUI

struct DiscoverGameRowView: View {
    
    private var game: ArcadiaFeaturedGame
    init(game: ArcadiaFeaturedGame) {
        self.game = game
    }
    
    var body: some View {
        HStack {
            Image(game.coverImageAssetName)
            VStack(alignment: .leading) {
                Text(game.name)
                    .font(.headline)
                Text("Developer name")
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    DiscoverGameRowView(game: ArcadiaFeaturedGame(id: 0, name: "Awesome game", shortDescription: "This game is awesome", longDescription: "Very long text", developerId: 0, coverImageAssetName: "gbc_icon", itchURL: nil, screenshotsAssetName: []))
}
