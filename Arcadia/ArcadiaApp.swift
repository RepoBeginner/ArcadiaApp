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

    var body: some Scene {
        WindowGroup {
            #if os(macOS)
            GameLibraryView()
            #elseif os(iOS)
            TabView {
                GameLibraryView()
                    .tabItem {
                            Label("Game Systems", systemImage: "gamecontroller")
                        }
                SettingsView()
                    .tabItem {
                                Label("Settings", systemImage: "gear")
                            }
            }
            #endif
                
        }
        .modelContainer(sharedModelContainer)
        .environment(ArcadiaFileManager.shared)
        .environment(ArcadiaCoreEmulationState.sharedInstance)
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}
