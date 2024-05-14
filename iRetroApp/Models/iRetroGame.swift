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
    var gameType: iRetroGameType
    var name: String
    
    init(name: String, gameType: iRetroGameType) {
        self.gameType = gameType
        self.name = name
    }
}

enum iRetroGameType: String, Codable, CaseIterable, Identifiable {
    
    var id: Self {
        return self
    }
    
    case gameBoyGame = "GameBoy"
}
