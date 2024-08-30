//
//  DiscoverGameRowView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 28/08/24.
//

import SwiftUI

struct DiscoverGameRowView: View {
    
    private var game: ArcadiaFeaturedContent
    init(game: ArcadiaFeaturedContent) {
        self.game = game
    }
    
    var body: some View {
        HStack {
            if game.game.coverImageAssetName == "" {
                game.game.gameType.defaultCollectionImage
                    .resizable()
                    .frame(width: 80, height: 80)
            } else {
                Image(game.game.coverImageAssetName)
                    .resizable()
                    .frame(width: 80, height: 80)
            }
            
            VStack(alignment: .leading) {
                Text(game.game.name)
                    .font(.headline)
                Text(game.author.name)
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    DiscoverGameRowView(game: ArcadiaFeaturedContent(game: ArcadiaFeaturedGame(id: 0, name: "Awesome game", bundledFileExtension: "", gameType: .gameBoyGame, shortDescription: "This game is awesome", genres: [], longDescription: "Very long text", developerId: 0, coverImageAssetName: "gbc_icon", itchURL: nil, screenshotsAssetName: []), author: ArcadiaGameDeveloper(id: 0, name: "Awesome developer", bio: "", socials: [])))
}
