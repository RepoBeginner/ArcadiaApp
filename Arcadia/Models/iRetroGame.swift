//
//  iRetroGame.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 07/05/24.
//

import Foundation
import SwiftData

@Model
final class iRetroGame {
    var gameType: ArcadiaGameType
    var name: String
    
    init(name: String, gameType: ArcadiaGameType) {
        self.gameType = gameType
        self.name = name
    }
}

enum ArcadiaGameType: String, Codable, CaseIterable, Identifiable {
    
    var id: Self {
        return self
    }
    
    case gameBoyGame = "GameBoy"
}
