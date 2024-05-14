//
//  GameCollectionView.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 07/05/24.
//

import SwiftUI
import UniformTypeIdentifiers
import iRetroGBCCore
import iRetroCore

struct GameCollectionView: View {
    @State private var gameType: iRetroGameType
    @State private var showingAddGameView: Bool = false
    @Environment(iRetroFileManager.self) var manager: iRetroFileManager
    
    init(gameType: iRetroGameType) {
        self.gameType = gameType
    }
    
    var body: some View {
            List {
                ForEach(manager.gbGames, id: \.self) { file in
                    NavigationLink(destination: RunGameView(gameURL: file)
                        .environment(iRetroGBC.sharedInstance)
                        .environment(iRetroCoreEmulationState.sharedInstance)
                    ) {
                        Text(file.lastPathComponent)
                    }
                    }
            }
                .navigationTitle("Game Collection")
                .toolbar() {
                    Button(action: { showingAddGameView.toggle() }, label: {
                        Image(systemName: "plus")
                    })
                }
                .fileImporter(isPresented: $showingAddGameView, allowedContentTypes: [UTType(filenameExtension: "gb")!], onCompletion: { result in
                    do {
                        let fileUrl = try result.get()
                        fileUrl.startAccessingSecurityScopedResource()
                        let romFile = try Data(contentsOf: fileUrl)
                        
                        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        let gameDirectory = documentsDirectory.appendingPathComponent("GB")
                        
                        if !FileManager.default.fileExists(atPath: gameDirectory.path) {
                            try FileManager.default.createDirectory(at: gameDirectory, withIntermediateDirectories: true, attributes: nil)
                        }
                        
                        let savePath = gameDirectory.appendingPathComponent(fileUrl.lastPathComponent)
                        print(savePath)
                        try romFile.write(to: savePath, options: .atomic)
                        fileUrl.stopAccessingSecurityScopedResource()


                    } catch {
                        print ("error reading: \(error.localizedDescription)")
                    }
                    return
                })

    }
}

#Preview {
    GameCollectionView(gameType: iRetroGameType.gameBoyGame)
}
