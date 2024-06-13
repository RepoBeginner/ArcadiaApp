//
//  InputSettingsView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 12/06/24.
//

import SwiftUI

struct InputSettingsView: View {
    
    @AppStorage("hapticFeedback") private var useHapticFeedback = true
    @Environment(InputController.self) var inputController: InputController
    
    var body: some View {
        @Bindable var inputController = inputController
        Form {
            Section(header: Text("Player selection")) {
                if !inputController.controllers.isEmpty {
                    ForEach(Array(inputController.controllers.keys), id: \.self) {key in
                        Picker("\(key.vendorName ?? "Unknown device")", selection: $inputController.controllers[key]) {
                            Text("Player 1").tag(Optional(UInt32(1)))
                            Text("Player 2").tag(Optional(UInt32(2)))
                            Text("Player 3").tag(Optional(UInt32(3)))
                            Text("Player 4").tag(Optional(UInt32(4)))
                            Text("No player").tag(nil as UInt32?)
                        }
                        .onChange(of: inputController.controllers[key]) { oldValue, newValue in
                            inputController.updateControllerConfiguration(controller: key, from: oldValue, to: newValue)
                        }
                    }
                } else {
                    Text("No device connecteed")
                }
            }
            Toggle(isOn: $useHapticFeedback) {
                Text("Haptic Feedback")
            }
        }
    }
}

#Preview {
    InputSettingsView()
        .environment(InputController.shared)
}
