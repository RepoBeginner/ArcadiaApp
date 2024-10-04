//
//  SettingsView.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 08/05/24.
//

import SwiftUI

struct SettingsView: View {
        
    var body: some View {
        #if os(macOS)
        TabView {
            InputSettingsView()
                .tabItem {
                    Label("Input", systemImage: "gamecontroller")
                }
            AudioSettingsView()
                .frame(minWidth: 375, minHeight: 175)
                .tabItem {
                    Label("Audio", systemImage: "music.note")
                }
            StorageSettingsView()
                .frame(minWidth: 375, minHeight: 175)
                .tabItem {
                    Label("Synchronization", systemImage: "cloud")
                }
            HelpView()
                .tabItem {
                    Label("Help", systemImage: "gear")
                }
            ContributeView()
                .tabItem {
                    Label("Contribute", systemImage: "hands.sparkles")
                }
            CreditsView()
                .tabItem {
                    Label("Credits", systemImage: "star")
                }

        }
        .navigationTitle("Settings")
        #else
        NavigationStack {
            Form {
                Section {
                    NavigationLink(destination: InputSettingsView()) {
                        Text("Input")
                    }
                    NavigationLink(destination: AudioSettingsView()) {
                        Text("Audio")
                    }
                    NavigationLink(destination: StorageSettingsView()) {
                        Text("Storage")
                    }
                }
                #if os(iOS)
                Section {
                    NavigationLink(destination: AppIconView()) {
                        Text("App Icon")
                    }
                }
                #endif
                Section {
                    NavigationLink(destination: HelpView()) {
                        Text("Help")
                    }
                    NavigationLink(destination: CreditsView()) {
                        Text("Credits")
                    }
                    NavigationLink(destination: ContributeView()) {
                        Text("Contribute")
                    }
                }
            }
            .navigationTitle("Settings")
        }
        
        #endif
    }
}

#Preview {
    SettingsView()
        .environment(InputController.shared)
}
