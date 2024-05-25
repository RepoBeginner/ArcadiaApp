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
        #else
        NavigationStack {
            Form {
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
