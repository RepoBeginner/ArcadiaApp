//
//  GameCollectionView.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 07/05/24.
//

import SwiftUI
import UniformTypeIdentifiers
import ArcadiaGBCCore
import ArcadiaCore

struct GameCollectionView: View {
    @State private var gameType: ArcadiaGameType
    @State private var showingAddGameView: Bool = false
    @Environment(ArcadiaFileManager.self) var manager: ArcadiaFileManager
    
    init(gameType: ArcadiaGameType) {
        self.gameType = gameType
    }
    
    var body: some View {
            List {
                ForEach(manager.gbGames, id: \.self) { file in
                    NavigationLink(destination: RunGameView(gameURL: file)
                        //TODO: Try to work without a shared instance in this case, would pause and unpause be feasible?
                        .environment(ArcadiaGBC.sharedInstance)
                        .environment(ArcadiaCoreEmulationState.sharedInstance)
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
    GameCollectionView(gameType: ArcadiaGameType.gameBoyGame)
}
