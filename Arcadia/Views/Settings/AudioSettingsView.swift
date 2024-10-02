//
//  AudioSettingsView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 16/09/24.
//

import SwiftUI
import ArcadiaCore

struct AudioSettingsView: View {
    
    @Environment(ArcadiaCoreEmulationState.self) var emulationState: ArcadiaCoreEmulationState
    @AppStorage("audioFollowsSilentSwitch") private var audioFollowsSilentSwitch = true
    @AppStorage("audioIsMuted") private var audioIsMuted = false
    
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $audioIsMuted) {
                    Text("Mute audio")
                }
                .onChange(of: audioIsMuted) { oldValue, newValue in
                    emulationState.audioPlayer.setMuted(newValue)
                }
                
                #if os(iOS)
                Toggle(isOn: $audioFollowsSilentSwitch) {
                    Text("Respect the mute switch")
                }
                .onChange(of: audioIsMuted) { oldValue, newValue in
                    emulationState.audioPlayer.setFollowsSilentSwitch(newValue)
                }
                #endif
                
            }
        }
    }
}

#Preview {
    AudioSettingsView()
        .environment(ArcadiaCoreEmulationState.sharedInstance)
}
