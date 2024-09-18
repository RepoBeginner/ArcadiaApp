//
//  AudioSettingsView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 16/09/24.
//

import SwiftUI

struct AudioSettingsView: View {
    
    @AppStorage("shouldRespectMuteSwitch") private var shouldRespectMuteSwitch = true
    @AppStorage("muteAudio") private var muteAudio = false
    
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $muteAudio) {
                    Text("Mute audio")
                }
                Toggle(isOn: $shouldRespectMuteSwitch) {
                    Text("Respect the mute switch")
                }
            }
        }
    }
}

#Preview {
    AudioSettingsView()
}
