//
//  iRetroFileManager.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 07/05/24.
//

import Foundation
import UniformTypeIdentifiers
import ArcadiaCore

@Observable class ArcadiaFileManager {
    
    public static var shared = ArcadiaFileManager()
    
    var documentsDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    var libraryDirectory: URL {
        return FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
    }
    
    var documentsMainDirectory: URL {
        return documentsDirectory.appendingPathComponent("Arcadia")
    }
    
    var libraryMainDirectory: URL {
        return libraryDirectory.appendingPathComponent("Arcadia")
    }
    
    var gamesDirectory: URL {
        return documentsMainDirectory.appendingPathComponent("Games")
    }
    
    var savesDirectory: URL {
        return documentsMainDirectory.appendingPathComponent("Saves")
    }
    
    var statesDirectory: URL {
        return documentsMainDirectory.appendingPathComponent("States")
    }
    
    var imagesDirectory: URL {
        return libraryMainDirectory.appendingPathComponent("Images")
    }
    

    private init() {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let libraryDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let documentsMainDirectory = documentsDirectory.appendingPathComponent("Arcadia")
        let libraryMainDirectory = libraryDirectory.appendingPathComponent("Arcadia")
        
        let gamesDirectory = documentsMainDirectory.appendingPathComponent("Games")
        let savesDirectory = documentsMainDirectory.appendingPathComponent("Saves")
        let statesDirectory = documentsMainDirectory.appendingPathComponent("States")
        let imagesDirectory = libraryMainDirectory.appendingPathComponent("Images")
        
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
            var correctFiles = [URL]()
            for fileToCheck in dir {
                if gameSystem.allowedExtensions.contains(UTType(filenameExtension: fileToCheck.pathExtension)!) {
                    correctFiles.append(fileToCheck)
                }
                
            }
            return correctFiles
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
    
    func getSaveURL(gameURL: URL, gameType: ArcadiaGameType, memoryType: ArcadiaCoreMemoryType) -> URL {
        return self.savesDirectory.appendingPathComponent(gameType.rawValue).appendingPathComponent(gameURL.deletingPathExtension().lastPathComponent).appendingPathExtension(gameType.supportedSaveFiles[memoryType]!)
    }
    
    func getStateURL(gameURL: URL, gameType: ArcadiaGameType) -> URL {
        return self.statesDirectory.appendingPathComponent(gameType.rawValue).appendingPathComponent(gameURL.deletingPathExtension().lastPathComponent).appendingPathExtension("state")
    }
    
    func getImageURL(gameURL: URL, gameType: ArcadiaGameType) -> URL {
        return self.imagesDirectory.appendingPathComponent(gameType.rawValue).appendingPathComponent(gameURL.deletingPathExtension().lastPathComponent).appendingPathExtension("png")
    }
    
    func getImageData(gameURL: URL, gameType: ArcadiaGameType) -> Data? {
        let fileURL = getImageURL(gameURL: gameURL, gameType: gameType)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                let imageData = try Data(contentsOf: fileURL)
                return imageData
            } catch {
                print("Error loading image : \(error)")
            }
            return nil
        }
        return nil
    }
    
    func deleteGame(gameURL: URL, gameType: ArcadiaGameType) {
        let imageURL = getImageURL(gameURL: gameURL, gameType: gameType)
        let saveURL = getSaveURL(gameURL: gameURL, gameType: gameType)
        let stateURL = getStateURL(gameURL: gameURL, gameType: gameType)
        
        for fileURL in [imageURL, saveURL, stateURL] {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path)
                } catch {
                    print("Could not delete")
                }
            }
        }
        
        if FileManager.default.fileExists(atPath: gameURL.path) {
            do {
                try FileManager.default.removeItem(atPath: gameURL.path)
            } catch {
                print("Could not delete")
            }
        }
        

    }
    

    
}
