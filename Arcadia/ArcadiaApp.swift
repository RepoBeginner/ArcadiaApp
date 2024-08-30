//
//  iRetroAppApp.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 01/05/24.
//

import SwiftUI
import SwiftData
import ArcadiaCore

@main
struct ArcadiaApp: App {
    /*
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ArcadiaGame.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
*/
    var body: some Scene {
        @Bindable var fileManager = ArcadiaFileManager.shared
        WindowGroup {
            #if os(macOS)
            GameLibraryView()
                .onOpenURL { url in
                    ArcadiaFileManager.shared.importGameFromShare(gameURL: url)
                }
            #elseif os(iOS)
            TabView {
                GameLibraryView()
                    .tabItem {
                            Label("Game Systems", systemImage: "gamecontroller")
                        }
                DiscoverGameListView()
                    .tabItem {
                            Label("Featured Games", systemImage: "star")
                        }
                SettingsView()
                    .tabItem {
                                Label("Settings", systemImage: "gear")
                            }
            }
            .alert("Game loaded!", isPresented: $fileManager.showAlert) {
                Button("Ok", action: {})
            } message: {
                Text("You will find the game in the console's collection.")
            }
            .onOpenURL { url in
                ArcadiaFileManager.shared.importGameFromShare(gameURL: url)
            }
            #endif
                
        }
        //.modelContainer(sharedModelContainer)
        .environment(ArcadiaFileManager.shared)
        .environment(ArcadiaCoreEmulationState.sharedInstance)
        .environment(InputController.shared)

        #if os(macOS)
        Settings {
            SettingsView()
                .environment(InputController.shared)
                .environment(ArcadiaFileManager.shared)
        }
        .windowResizability(.contentSize)
        Window("Featured Games", id: "featured-games") {
            DiscoverGameListView()
                .environment(ArcadiaFileManager.shared)
        }
        #endif
    }
}
