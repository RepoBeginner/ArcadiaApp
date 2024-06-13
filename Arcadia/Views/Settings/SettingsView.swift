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
            HelpView()
                .tabItem {
                    Label("Help", systemImage: "gear")
                }

            CreditsView()
                .tabItem {
                    Label("Credits", systemImage: "star")
                }

        }
        .navigationTitle("Settings")
        .frame(minWidth: 375, minHeight: 150)
        #else
        NavigationStack {
            Form {
                NavigationLink(destination: InputSettingsView()) {
                    Text("Input")
                }
                NavigationLink(destination: HelpView()) {
                    Text("Help")
                }
                NavigationLink(destination: CreditsView()) {
                    Text("Credits")
                }
            }
            .navigationTitle("Settings")
        }
        
        #endif
    }
}

#Preview {
    SettingsView()
}
