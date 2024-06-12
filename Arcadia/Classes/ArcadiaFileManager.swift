//
//  iRetroFileManager.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 07/05/24.
//

import Foundation
import UniformTypeIdentifiers
import ArcadiaCore
import SQLite3
import CryptoKit
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif


@Observable class ArcadiaFileManager {
    
    public static var shared = ArcadiaFileManager()
    public var currentGames: [URL] = []
    
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
        return documentsMainDirectory.appendingPathComponent("Images")
    }
    
    var coresDirectory: URL {
        return documentsMainDirectory.appendingPathComponent("Cores")
    }
    

    private init() {
                
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let libraryDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let documentsMainDirectory = documentsDirectory.appendingPathComponent("Arcadia")

        
        let gamesDirectory = documentsMainDirectory.appendingPathComponent("Games")
        let savesDirectory = documentsMainDirectory.appendingPathComponent("Saves")
        let statesDirectory = documentsMainDirectory.appendingPathComponent("States")
        let imagesDirectory = documentsMainDirectory.appendingPathComponent("Images")
        let coresDirectory = documentsMainDirectory.appendingPathComponent("Cores")
        
        for dir in [gamesDirectory, savesDirectory, statesDirectory, imagesDirectory, coresDirectory] {
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
    
    func getGamesURL(gameSystem: ArcadiaGameType) {
        do {
            let dir = try FileManager.default.contentsOfDirectory(at: self.gamesDirectory.appendingPathComponent(gameSystem.rawValue), includingPropertiesForKeys: nil)
            var correctFiles = [URL]()
            for fileToCheck in dir {
                if gameSystem.allowedExtensions.contains(UTType(filenameExtension: fileToCheck.pathExtension)!) {
                    correctFiles.append(fileToCheck)
                }
                
            }
            self.currentGames = correctFiles.sorted(by: {
                file1, file2 in
                return file1.deletingPathExtension().lastPathComponent.lowercased() <  file2.deletingPathExtension().lastPathComponent.lowercased()
            })
        }
        catch {
            self.currentGames = []
        }
    }
    
    func saveGame(gameURL: URL, gameType: ArcadiaGameType) {
        if  gameURL.startAccessingSecurityScopedResource() {
            
            defer {
                gameURL.stopAccessingSecurityScopedResource()
            }
            
            do {
                
                let romFile = try Data(contentsOf: gameURL)
                let savePath = self.gamesDirectory.appendingPathComponent(gameType.rawValue).appendingPathComponent(gameURL.lastPathComponent)
                try romFile.write(to: savePath, options: .atomic)
                
                if let boxArtPath = getGameFromURL(gameURL: gameURL) {
                    guard let boxArtURL = URL(string: boxArtPath) else { return }
                    print("Got boxULR :\(boxArtURL)")
                    downloadAndProcessImage(of: gameURL, from: boxArtURL, gameType: gameType) { error in
                        DispatchQueue.main.async {
                            if let error = error {
                                print("Error: \(error.localizedDescription)")
                            } else {
                                print("Image saved successfully")
                            }
                        }
                    }
                }
                //To update the game list
                getGamesURL(gameSystem: gameType)
            } catch {
                print("couldn't save file")
            }
        

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
        return self.imagesDirectory.appendingPathComponent(gameType.rawValue).appendingPathComponent(gameURL.deletingPathExtension().lastPathComponent).appendingPathExtension("jpg")
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
    
    func loadCustomImage(imageData: Data, gameURL: URL, gameType: ArcadiaGameType) {
        #if os(iOS)
        guard let image = UIImage(data: imageData) else {
            return
        }
        let resizedImage = resizeImage(image: image, toMaxDimension: 80)
        guard let resizedImageData = resizedImage.pngData() else {
            return
        }
        #elseif os(macOS)
        guard let image = NSImage(data: imageData) else {
            return
        }
        let resizedImage = resizeImage(image: image, toMaxDimension: 80)
        guard let resizedImageTiffData = resizedImage.tiffRepresentation else {
            return
        }
        let bitmapImageRep = NSBitmapImageRep(data: resizedImageTiffData)
        guard let resizedImageData = bitmapImageRep?.representation(using: .png, properties: [:]) else {
            return
        }
        #endif
        let imageURL = getImageURL(gameURL: gameURL, gameType: gameType)
        do {
            try resizedImageData.write(to: imageURL)
        }
        catch {
            print("Error saving image")
        }

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
        //To update the list
        getGamesURL(gameSystem: gameType)
        
    }
    
    func deleteSaves(gameURL: URL, gameType: ArcadiaGameType) {
        let saveURL = getSaveURL(gameURL: gameURL, gameType: gameType)
        
        if FileManager.default.fileExists(atPath: saveURL.path) {
            do {
                try FileManager.default.removeItem(atPath: saveURL.path)
            } catch {
                print("Could not delete")
            }
        }

    }
    
    func deleteStates(gameURL: URL, gameType: ArcadiaGameType) {
        let stateURL = getStateURL(gameURL: gameURL, gameType: gameType)
        
        if FileManager.default.fileExists(atPath: stateURL.path) {
            do {
                try FileManager.default.removeItem(atPath: stateURL.path)
            } catch {
                print("Could not delete")
            }
        }

    }
    
    func clearSavesAndStates(gameURL: URL, gameType: ArcadiaGameType) {
        deleteSaves(gameURL: gameURL, gameType: gameType)
        deleteStates(gameURL: gameURL, gameType: gameType)

    }
    
    func renameGame(gameURL: URL, newName: String, gameType: ArcadiaGameType) {
        let imageURL = getImageURL(gameURL: gameURL, gameType: gameType)
        let saveURL = getSaveURL(gameURL: gameURL, gameType: gameType)
        let stateURL = getStateURL(gameURL: gameURL, gameType: gameType)
        
        let newGameURL = gameURL.deletingLastPathComponent().appendingPathComponent(newName).appendingPathExtension(gameURL.pathExtension)
        let newImageURL = getImageURL(gameURL: newGameURL, gameType: gameType)
        let newSaveURL = getSaveURL(gameURL: newGameURL, gameType: gameType)
        let newStateURL = getStateURL(gameURL: newGameURL, gameType: gameType)
        
        let fileURLs = [(imageURL, newImageURL), (saveURL, newSaveURL), (stateURL, newStateURL)]
        
        for (oldURL, newURL) in fileURLs {
            if FileManager.default.fileExists(atPath: oldURL.path) {
                do {
                    try FileManager.default.moveItem(at: oldURL, to: newURL)
                } catch {
                    print("Could not rename \(oldURL.lastPathComponent) to \(newURL.lastPathComponent)")
                }
            }
        }
        
        if FileManager.default.fileExists(atPath: gameURL.path) {
            do {
                try FileManager.default.moveItem(at: gameURL, to: newGameURL)
            } catch {
                print("Could not rename \(gameURL.lastPathComponent) to \(newGameURL.lastPathComponent)")
            }
        }
        // To update the list
        getGamesURL(gameSystem: gameType)
        
    }
    
    func md5Hash(from url: URL) -> String? {
        do {

            let data = try Data(contentsOf: url)
            let md5 = Insecure.MD5.hash(data: data)
            
            let md5String = md5.map { String(format: "%02hhx", $0) }.joined()
            
            return md5String.uppercased()
        } catch {
            print("Error reading data from URL: \(error)")
            return nil
        }
    }

    func openDatabase() -> OpaquePointer? {
        guard let fileURL = Bundle.main.url(forResource: "openvgdb", withExtension: "sqlite") else {
            print("Database file not found in bundle.")
            return nil
        }
        print("Database file path: \(fileURL.path)")
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            debugPrint("Cannot open DB. Error: \(String(cString: sqlite3_errmsg(db)))")
            return nil
        } else {
            print("DB successfully opened.")
            return db
        }
    }

    func getGameFromURL(gameURL: URL) -> String? {
           guard let db = openDatabase() else { return nil }
           defer { sqlite3_close(db) }
           
           guard let gameHash = md5Hash(from: gameURL) else { return nil }
           print("MD5 Hash: \(gameHash)")
           
           let queryStatementString = """
           SELECT releaseCoverFront
           FROM ROMs
           INNER JOIN RELEASES ON ROMs.romID = RELEASES.romID
           WHERE ROMs.romHashMD5 = '\(gameHash)'
           ORDER BY RELEASES.releaseDate DESC
           LIMIT 1;
           """
           print("SQL Query: \(queryStatementString)")
           
           var queryStatement: OpaquePointer? = nil
           var boxArtUrl: String? = nil
           
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                if let columnText = sqlite3_column_text(queryStatement, 0) {
                    boxArtUrl = String(cString: columnText)
                }
            }
            sqlite3_finalize(queryStatement)
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error preparing SELECT statement: \(errmsg)")
        }
           
           return boxArtUrl
       }
    
    
    func downloadAndProcessImage(of gameURL: URL, from imageURL: URL, gameType: ArcadiaGameType, completion: @escaping (Error?) -> Void) {
        
        print("Trying to download from \(imageURL)")
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let error = error {
                completion(error)
                return
            }
            
            print("Downloaded from \(imageURL)")
            guard let data = data else {
                completion(NSError(domain: "ImageProcessingError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                return
            }
            
            #if os(iOS)
            guard let image = UIImage(data: data) else {
                completion(NSError(domain: "ImageProcessingError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Unable to create image from data"]))
                return
            }
            #elseif os(macOS)
            guard let image = NSImage(data: data) else {
                completion(NSError(domain: "ImageProcessingError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Unable to create image from data"]))
                return
            }
            #endif
            
            let imageFileName = self.getImageURL(gameURL: gameURL, gameType: gameType)
            
            let resizedImage = self.resizeImage(image: image, toMaxDimension: 80)
            print("Resized image")
            
            #if os(iOS)
            guard let jpegData = resizedImage.jpegData(compressionQuality: 1.0) else {
                completion(NSError(domain: "ImageProcessingError", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Unable to convert image to JPEG"]))
                return
            }
            #elseif os(macOS)
            guard let tiffData = resizedImage.tiffRepresentation,
                  let bitmap = NSBitmapImageRep(data: tiffData),
                  let jpegData = bitmap.representation(using: .jpeg, properties: [:]) else {
                completion(NSError(domain: "ImageProcessingError", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Unable to convert image to JPEG"]))
                return
            }
            #endif
            
            do {
                print("Writing to \(imageFileName)")
                try jpegData.write(to: imageFileName)
                completion(nil)
            } catch {
                completion(error)
            }
        }.resume()
    }

    #if os(iOS)
    func resizeImage(image: UIImage, toMaxDimension maxDimension: CGFloat) -> UIImage {
        let size = image.size
        let widthRatio = maxDimension / size.width
        let heightRatio = maxDimension / size.height

        let scaleFactor = min(widthRatio, heightRatio)
        
        let newSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resizedImage = renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        return resizedImage
    }
    #elseif os(macOS)
    func resizeImage(image: NSImage, toMaxDimension maxDimension: CGFloat) -> NSImage {
        let size = image.size
        let widthRatio = maxDimension / size.width
        let heightRatio = maxDimension / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        let newSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        
        let resizedImage = NSImage(size: newSize)
        resizedImage.lockFocus()
        image.draw(in: NSRect(origin: .zero, size: newSize),
                   from: NSRect(origin: .zero, size: size),
                   operation: .copy,
                   fraction: 1.0)
        resizedImage.unlockFocus()
        
        return resizedImage
    }
    #endif
    
    func getSaveDirectory(for gameSystem: ArcadiaGameType) -> URL {
        return self.savesDirectory.appendingPathComponent(gameSystem.rawValue)
    }
    
    func getStateDirectory(for gameSystem: ArcadiaGameType) -> URL {
        return self.statesDirectory.appendingPathComponent(gameSystem.rawValue)
    }
    
    func getImageDirectory(for gameSystem: ArcadiaGameType) -> URL {
        return self.imagesDirectory.appendingPathComponent(gameSystem.rawValue)
    }
    
    func getCoreDirectory(for gameSystem: ArcadiaGameType) -> URL {
        return self.coresDirectory.appendingPathComponent(gameSystem.rawValue)
    }

    
}
