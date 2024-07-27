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
    case masterSystemGame = "Sega Master System"
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
            return "Sega Master System"
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
            return ["CAST(36 AS INT), CAST(37 AS INT)"]
        case .masterSystemGame:
            return ["CAST(31 AS INT)"]
        }
    }
    
    var allowedExtensions: [UTType] {
        switch self {
        case .gameBoyGame:
            return [UTType(filenameExtension: "gb")!, UTType(filenameExtension: "gbc")!, UTType(filenameExtension: "sgb")!, UTType(filenameExtension: "cgb")!]
        case .gameBoyAdvanceGame:
            return [UTType(filenameExtension: "gba")!]
        case .nesGame:
            return [UTType(filenameExtension: "nes")!]
        case .snesGame:
            return [UTType(filenameExtension: "smc")!, UTType(filenameExtension: "sfc")!]
        case .atari2600Game:
            return [UTType(filenameExtension: "a26")!]
        case .atari7800Game:
            return [UTType(filenameExtension: "a78")!]
        case .neoGeoPocketGame:
            return [UTType(filenameExtension: "ngp")!, UTType(filenameExtension: "ngc")!]
        case .masterSystemGame:
            return [UTType(filenameExtension: "sms")!]
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
            return Image("atari_7800_icon")
        case .masterSystemGame:
            return Image("nes_icon")
        }
    }
    
    @ViewBuilder var portraitButtonLayout: some View {
        switch self {
        case .gameBoyAdvanceGame:
            GBAButtonLayout()
        case .gameBoyGame:
            GBCButtonLayout()
        case .nesGame:
            GBCButtonLayout()
        case .snesGame:
            SNESButtonLayout()
        case .atari2600Game:
            Atari2600ButtonLayout()
        case .atari7800Game:
            Atari7800ButtonLayout()
        case .neoGeoPocketGame:
            GBCButtonLayout()
        case .masterSystemGame:
            GBCButtonLayout()
        }
    }
    
    @ViewBuilder var landscapeButtonLayoutLeft: some View {
        switch self {
        case .gameBoyAdvanceGame:
            GBAButtonLayoutLeft()
        case .gameBoyGame:
            GBCButtonLayoutLeft()
        case .nesGame:
            GBCButtonLayoutLeft()
        case .snesGame:
            SNESButtonLayoutLeft()
        case .atari2600Game:
            Atari2600ButtonLayoutLeft()
        case .atari7800Game:
            Atari2600ButtonLayoutLeft()
        case .neoGeoPocketGame:
            GBCButtonLayoutLeft()
        case .masterSystemGame:
            GBCButtonLayoutLeft()
        }
    }
    
    @ViewBuilder var landscapeButtonLayoutRight: some View {
        switch self {
        case .gameBoyAdvanceGame:
            GBAButtonLayoutRight()
        case .gameBoyGame:
            GBCButtonLayoutRight()
        case .nesGame:
            GBCButtonLayoutRight()
        case .snesGame:
            SNESButtonLayoutRight()
        case .atari2600Game:
            Atari2600ButtonLayoutRight()
        case .atari7800Game:
            Atari7800ButtonLayoutRight()
        case .neoGeoPocketGame:
            GBCButtonLayoutLeft()
        case .masterSystemGame:
            GBCButtonLayoutRight()
        }
    }
    
    var credits: AttributedString {
        switch self {
        case .gameBoyGame:
            return try! AttributedString(markdown: "drhelius's [Gearboy](https://github.com/drhelius/Gearboy)")
        case .gameBoyAdvanceGame:
            return try! AttributedString(markdown: "[Libretro version](https://github.com/libretro/vba-next) of VBA Next")
        case .nesGame:
            return try! AttributedString(markdown: "[Libretro version](https://github.com/libretro/nestopia) of [Nestopia UE](https://github.com/0ldsk00l/nestopia)")
        case .snesGame:
            return try! AttributedString(markdown: "[Libretro version](https://github.com/libretro/snes9x) of [snes9x](https://github.com/snes9xgit/snes9x)")
        case .atari2600Game:
            return try! AttributedString(markdown: "[Libretro version](https://github.com/libretro/stella2014-libretro) of [Stella](https://github.com/stella-emu/stella)")
        case .atari7800Game:
                return try! AttributedString(markdown: "[Libretro version](https://github.com/libretro/prosystem-libretro) of [ProSystem](https://github.com/gstanton/ProSystem1_3)")
        case .neoGeoPocketGame:
                return try! AttributedString(markdown: "[Libretro version](https://github.com/libretro/RACE) of [RACE](https://github.com/alekmaul/race)")
        case .masterSystemGame:
            return try! AttributedString(markdown: "drhelius's [Gearsystem](https://github.com/drhelius/Gearsystem)")
        }
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
