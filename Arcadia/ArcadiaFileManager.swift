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
    var gbGameDirectory: URL {
        return documentsDirectory.appendingPathComponent("GB")
    }
    var gbGames: [URL] {
        do {
            let test = try FileManager.default.contentsOfDirectory(at: self.gbGameDirectory, includingPropertiesForKeys: nil)
            return test
        }
        catch {
            return []
        }
    }
    
    private init() {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let gameDirectory = documentsDirectory.appendingPathComponent("GB")
        
        do {
            if !FileManager.default.fileExists(atPath: gameDirectory.path) {
                try FileManager.default.createDirectory(at: gameDirectory, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {
            print("Error")
        }
        
    }
    
    func saveGame(gameURL: URL) {
        switch gameURL.pathExtension {
            case "gb":
            do {
                gameURL.startAccessingSecurityScopedResource()
                let romFile = try Data(contentsOf: gameURL)
                let savePath = self.gbGameDirectory.appendingPathComponent(gameURL.lastPathComponent)
                try romFile.write(to: savePath, options: .atomic)
                gameURL.stopAccessingSecurityScopedResource()
            } catch {
                print("couldn't save")
            }
            return
        default:
            return
        }
    }
    
}
