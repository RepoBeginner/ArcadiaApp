//
//  ArcadiaGameType.swift
//  Arcadia
//
//  Created by Davide Andreoli on 18/05/24.
//

import Foundation
import UniformTypeIdentifiers
import ArcadiaCore
import ArcadiaGBACore
import ArcadiaGBCCore
import ArcadiaNESCore
import ArcadiaSNESCore
import ArcadiaAtari2600Core
import ArcadiaAtari7800Core
import ArcadiaNeoGeoPocketCore
import ArcadiaMasterSystemCore
import ArcadiaGenesisCore
import ArcadiaPokemonMiniCore
import SwiftUI

enum ArcadiaGameType: String, Codable, CaseIterable, Identifiable, ArcadiaGameTypeProtocol {
    
    var id: Self {
        return self
    }
    
    case atari2600Game = "Atari 2600"
    case atari7800Game = "Atari 7800"
    case gameBoyAdvanceGame = "GameBoy Advance"
    case gameBoyGame = "GameBoy (Color)"
    case nesGame = "NES"
    case neoGeoPocketGame = "Neo Geo Pocket (Color)"
    case pokemonMiniGame = "Pokémon Mini"
    case gameGearGame = "Sega Game Gear"
    case genesisGame = "Sega Genesis"
    case masterSystemGame = "Sega Master System - SG 1000"
    case snesGame = "SNES"
    
    
    var name: String {
        switch self {
        case .gameBoyGame:
            return "GameBoy (Color)"
        case .gameBoyAdvanceGame:
            return "GameBoy Advance"
        case .nesGame:
            return "NES"
        case .snesGame:
            return "SNES"
        case .atari2600Game:
            return "Atari 2600"
        case .atari7800Game:
            return "Atari 7800"
        case .neoGeoPocketGame:
            return "Neo Geo Pocket (Color)"
        case .masterSystemGame:
            return "Sega Master System - SG 1000"
        case .gameGearGame:
            return "Sega Game Gear"
        case .genesisGame:
            return "Sega Genesis"
        case .pokemonMiniGame:
            return "Pokémon Mini"
        }
    }
    
    var dbSystemId: [String] {
        switch self {
        case .gameBoyGame:
            return ["CAST(19 AS INT)", "CAST(21 AS INT)"]
        case .gameBoyAdvanceGame:
            return ["CAST(20 AS INT)"]
        case .nesGame:
            return ["CAST(25 AS INT)"]
        case .snesGame:
            return ["CAST(26 AS INT)"]
        case .atari2600Game:
            return ["CAST(3 AS INT)"]
        case .atari7800Game:
            return ["CAST(5 AS INT)"]
        case .neoGeoPocketGame:
            return ["CAST(36 AS INT)", "CAST(37 AS INT)"]
        case .masterSystemGame:
            return ["CAST(31 AS INT)", "CAST(35 AS INT)"]
        case .gameGearGame:
            return ["CAST(30 AS INT)"]
        case .genesisGame:
            return ["CAST(33 AS INT)"]
        case .pokemonMiniGame:
            return ["CAST(0 AS INT)"]
        }
    }
    
    var allowedExtensions: [UTType] {
        switch self {
        case .gameBoyGame:
            return [UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.gb"), UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.gbc"), UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.sgb"), UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.cgb"), UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.dmg")]
        case .gameBoyAdvanceGame:
            return [UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.gba")]
        case .nesGame:
            return [UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.nes"), UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.unf"), UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.unif")]
        case .snesGame:
            return [UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.smc"), UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.sfc"), UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.swc"), UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.fig"), UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.bs"), UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.st")]
        case .atari2600Game:
            return [UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.a26"), UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.bin")]
        case .atari7800Game:
            return [UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.a78"), UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.bin")]
        case .neoGeoPocketGame:
            return [UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.ngp"), UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.ngc")]
        case .masterSystemGame:
            return [UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.sms"), UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.sg"), UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.bin")]
        case .gameGearGame:
            return [UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.gg"), UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.bin")]
        case .genesisGame:
            return [UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.gen"), UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.md"), UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.bin")]
        case .pokemonMiniGame:
            return [UTType(importedAs: "com.davideandreoli.Arcadia.gamefile.min")]
        }
        
    }
    
    var associatedCore: any ArcadiaCoreProtocol {
        switch self {
        case .gameBoyAdvanceGame:
            return ArcadiaGBA()
        case .gameBoyGame:
            return ArcadiaGBC()
        case .nesGame:
            return ArcadiaNES()
        case .snesGame:
            return ArcadiaSNES()
        case .atari2600Game:
            return ArcadiaAtari2600()
        case .atari7800Game:
            return ArcadiaAtari7800()
        case .neoGeoPocketGame:
            return ArcadiaNeoGeoPocket()
        case .masterSystemGame:
            return ArcadiaMasterSystem()
        case .gameGearGame:
            return ArcadiaMasterSystem()
        case .genesisGame:
            return ArcadiaGenesis()
        case .pokemonMiniGame:
            return ArcadiaPokemonMini()
        }
    }
    
    var saveFileExtension: String {
        switch self {
        case .gameBoyAdvanceGame:
            return "sav"
        case .gameBoyGame:
            return "srm"
        case .nesGame:
            return "srm"
        case .snesGame:
            return "srm"
        case .atari2600Game:
            return "srm"
        case .atari7800Game:
            return "srm"
        case .neoGeoPocketGame:
            return "ngf"
        case .masterSystemGame:
            return "srm"
        case .gameGearGame:
            return "srm"
        case .genesisGame:
            return "srm"
        case .pokemonMiniGame:
            return "eep"
        }
    }
    
    var supportedSaveFiles: [ArcadiaCoreMemoryType : String] {
        switch self {
        case .gameBoyAdvanceGame:
            return [
                .memorySaveRam : "srm"
            ]
        case .gameBoyGame:
            return [
                .memorySaveRam : "srm",
                .memoryRTC : "rtc"
            ]
        case.nesGame:
            return [
                .memorySaveRam : "srm"
            ]
        case .snesGame:
            return [
                .memorySaveRam : "srm"
            ]
        case .atari2600Game:
            return [
                :
            ]
        case .atari7800Game:
            return [
                :
            ]
        case .neoGeoPocketGame:
            return [
                .memorySaveRam : "ngf"
            ]
        case .masterSystemGame:
            return [
                .memorySaveRam : "srm"
            ]
        case .gameGearGame:
            return [
                .memorySaveRam : "srm"
            ]
        case .genesisGame:
            return [
                .memorySaveRam : "srm"
            ]
        case .pokemonMiniGame:
            return [
                .memorySystemRam : "eep"
            ]
        }
        
    }
    
    var defaultCollectionImage: Image {
        switch self {
        case .gameBoyAdvanceGame:
            return Image("gba_icon")
        case .gameBoyGame:
            return Image("gbc_icon")
        case .nesGame:
            return Image("nes_icon")
        case .snesGame:
            return Image("snes_icon")
        case .atari2600Game:
            return Image("atari_2600_icon")
        case .atari7800Game:
            return Image("atari_7800_icon")
        case .neoGeoPocketGame:
            return Image("neo_geo_icon")
        case .masterSystemGame:
            return Image("master_system_icon")
        case .gameGearGame:
            return Image("game_gear_icon")
        case .genesisGame:
            return Image("sega_genesis_icon")
        case .pokemonMiniGame:
            return Image("pokemon_mini_icon")
        }
    }
    
    var buttonLayoutElements: [ArcadiaButtonLayoutElements] {
        switch self {
        case .gameBoyAdvanceGame:
            return [.dPad, .twoActionButtons, .start, .select, .backButtonsFirstRow]
        case .gameBoyGame:
            return [.dPad, .twoActionButtons, .start, .select]
        case .nesGame:
            return [.dPad, .twoActionButtons, .start, .select]
        case .snesGame:
            return [.dPad, .fourActionButtons, .start, .select, .backButtonsFirstRow]
        case .atari2600Game:
            return [.dPad, .oneActionButton, .start, .select]
        case .atari7800Game:
            return [.dPad, .twoActionButtons, .start, .select]
        case .neoGeoPocketGame:
            return [.dPad, .twoActionButtons, .start]
        case .masterSystemGame:
            return [.dPad, .twoActionButtons]
        case .gameGearGame:
            return [.dPad, .twoActionButtons, .start]
        case .genesisGame:
            return [.dPad, .threeActionButtons, .start]
        case .pokemonMiniGame:
            return [.dPad, .twoActionButtons, .start, .select, .backButtonsFirstRow]
        }
    }
        
    var credits: AttributedString {
        switch self {
        case .gameBoyGame:
            return try! AttributedString(markdown: "[Gearboy](https://github.com/drhelius/Gearboy)")
        case .gameBoyAdvanceGame:
            return try! AttributedString(markdown: "[VBA Next](https://github.com/libretro/vba-next)")
        case .nesGame:
            return try! AttributedString(markdown: "[Nestopia UE](https://github.com/libretro/nestopia)")
        case .snesGame:
            return try! AttributedString(markdown: "[snes9x](https://github.com/libretro/snes9x)")
        case .atari2600Game:
            return try! AttributedString(markdown: "[Stella](https://github.com/libretro/stella2014-libretro)")
        case .atari7800Game:
                return try! AttributedString(markdown: "[ProSystem version](https://github.com/libretro/prosystem-libretro)")
        case .neoGeoPocketGame:
                return try! AttributedString(markdown: "[RACE](https://github.com/libretro/RACE)")
        case .masterSystemGame:
            return try! AttributedString(markdown: "[Gearsystem](https://github.com/drhelius/Gearsystem)")
        case .gameGearGame:
            return try! AttributedString(markdown: "[Gearsystem](https://github.com/drhelius/Gearsystem)")
        case .genesisGame:
            return try! AttributedString(markdown: "[picodrive](https://github.com/libretro/picodrive)")
        case .pokemonMiniGame:
            return try! AttributedString(markdown: "[PokeMini](https://github.com/libretro/PokeMini)")
        }
    }
    
    @ViewBuilder
    var coreSpecificInfo: some View {
        switch self {
        default:
            EmptyView()
        }
    }
    
    var getGameDirectory: URL {
        return ArcadiaFileManager.shared.getGameDirectory(for: self)
    }
    
    var getSaveDirectory: URL {
        return ArcadiaFileManager.shared.getSaveDirectory(for: self)
    }
    
    var getStateDirectory: URL {
        return ArcadiaFileManager.shared.getStateDirectory(for: self)
    }
    
    var getImageDirectory: URL {
        return ArcadiaFileManager.shared.getImageDirectory(for: self)
    }
    
    var getCoreDirectory: URL {
        return ArcadiaFileManager.shared.getCoreDirectory(for: self)
    }

}
