//
//  iRetroGame.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 07/05/24.
//

import Foundation
import SwiftData

@Model
final class ArcadiaGame {
    var gameType: ArcadiaGameType
    var name: String
    var id: UUID
    var internalName: String
    
    init(name: String, gameType: ArcadiaGameType) {
        self.gameType = gameType
        self.name = name
        let id = UUID()
        self.id = id
        self.internalName = id.uuidString
    }
}

enum ArcadiaGameType: String, Codable, CaseIterable, Identifiable {
    
    var id: Self {
        return self
    }
    
    case gameBoyGame = "GameBoy"
}
