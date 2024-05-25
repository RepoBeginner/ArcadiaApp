//
//  GameSystemRowView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 24/05/24.
//

import SwiftUI

struct GameSystemRowView: View {
    
    private var gameSystem: ArcadiaGameType
    
    init(gameSystem: ArcadiaGameType) {
        self.gameSystem = gameSystem
    }
    
    var body: some View {
        HStack {
            Text(gameSystem.rawValue)
            Spacer()
            gameSystem.defaultCollectionImage
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 40, maxHeight: 40)

                
        }
    }
}

#Preview {
    GameSystemRowView(gameSystem: .gameBoyGame)
}
