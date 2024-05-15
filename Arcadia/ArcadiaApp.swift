//
//  iRetroAppApp.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 01/05/24.
//

import SwiftUI
import SwiftData

@main
struct ArcadiaApp: App {
    var sharedModelContainer: ModelContainer = {
        UserDefaults.standard.setValue(iRetroInputMapping.returnKey.rawValue, forKey: "Return")
        let schema = Schema([
            Item.self,
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
                GameLibraryView()
        }
        .modelContainer(sharedModelContainer)
        .environment(ArcadiaFileManager())
    }
}
