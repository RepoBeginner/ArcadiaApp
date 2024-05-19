//
//  iRetroFileManager.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 07/05/24.
//

import Foundation

@Observable class ArcadiaFileManager {
    
    public static var shared = ArcadiaFileManager()
    
    var documentsDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    var gamesDirectory: URL {
        return documentsDirectory.appendingPathComponent("Games")
    }
    
    var savesDirectory: URL {
        return documentsDirectory.appendingPathComponent("Saves")
    }
    
    var statesDirectory: URL {
        return documentsDirectory.appendingPathComponent("States")
    }
    

    private init() {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let gamesDirectory = documentsDirectory.appendingPathComponent("Games")
        let savesDirectory = documentsDirectory.appendingPathComponent("Saves")
        let statesDirectory = documentsDirectory.appendingPathComponent("States")
        
        for dir in [gamesDirectory, savesDirectory, statesDirectory] {
            do {
                if !FileManager.default.fileExists(atPath: dir.path) {
                    try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil)
                }
                
                for gameSystem in ArcadiaGameType.allCases {
                    let gameSystemFolder = dir.appendingPathComponent(gameSystem.rawValue)
                    if !FileManager.default.fileExists(atPath: gameSystemFolder.path) {
                        try FileManager.default.createDirectory(at: gameSystemFolder, withIntermediateDirectories: true, attributes: nil)
                    }
                }
                
            } catch {
                print("Error creating folder")
            }
        }
        
        
        
    }
    
    func getGamesURL(gameSystem: ArcadiaGameType) -> [URL] {
        do {
            let dir = try FileManager.default.contentsOfDirectory(at: self.gamesDirectory.appendingPathComponent(gameSystem.rawValue), includingPropertiesForKeys: nil)
            return dir
        }
        catch {
            return []
        }
    }
    
    func saveGame(gameURL: URL, gameType: ArcadiaGameType) {

            do {
                gameURL.startAccessingSecurityScopedResource()
                let romFile = try Data(contentsOf: gameURL)
                let savePath = self.gamesDirectory.appendingPathComponent(gameType.rawValue).appendingPathComponent(gameURL.lastPathComponent)
                try romFile.write(to: savePath, options: .atomic)
                gameURL.stopAccessingSecurityScopedResource()
            } catch {
                print("couldn't save file")
            }
    }
    
    func getSaveURL(gameURL: URL, gameType: ArcadiaGameType) -> URL {
        return self.savesDirectory.appendingPathComponent(gameType.rawValue).appendingPathComponent(gameURL.deletingPathExtension().lastPathComponent).appendingPathExtension("srm")
    }
    
}
