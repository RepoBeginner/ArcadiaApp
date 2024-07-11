//
//  SynchronizationSettingsView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 09/07/24.
//

import SwiftUI

struct SynchronizationSettingsView: View {
    
    @AppStorage("iCloudSyncEnabled") private var useiCloudSync = false
    @Environment(ArcadiaFileManager.self) var fileManager: ArcadiaFileManager
    
    var body: some View {
        Form {
            Toggle(isOn: $useiCloudSync) {
                Label("Sync data to iCloud", systemImage: "cloud")
            }
            .onChange(of: useiCloudSync) { oldValue, newValue in
                if newValue {
                    fileManager.uploadFilesToiCloud()
                } else {
                    fileManager.downloadDataFromiCloud()
                }
            }
        }
        .navigationTitle("Synchronization")
    }
}

#Preview {
    SynchronizationSettingsView()
        .environment(ArcadiaFileManager.shared)
}
