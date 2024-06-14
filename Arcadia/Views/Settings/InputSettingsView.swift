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
                Picker("Touch input", selection: $inputController.mainInputPortID) {
                    Text("Player 1").tag(UInt32(0))
                    Text("Player 2").tag(UInt32(1))
                    Text("Player 3").tag(UInt32(2))
                    Text("Player 4").tag(UInt32(3))
                }
                if !inputController.controllers.isEmpty {
                    ForEach(Array(inputController.controllers.keys), id: \.self) {key in
                        Picker("\(key.vendorName ?? "Unknown device")", selection: $inputController.controllers[key]) {
                            Text("Player 1").tag(Optional(UInt32(0)))
                            Text("Player 2").tag(Optional(UInt32(1)))
                            Text("Player 3").tag(Optional(UInt32(2)))
                            Text("Player 4").tag(Optional(UInt32(3)))
                        }
                        .onChange(of: inputController.controllers[key]) { oldValue, newValue in
                            inputController.updateControllerConfiguration(controller: key, from: oldValue, to: newValue)
                            print(inputController.availablePortIDs)
                            print(inputController.nextPortID)
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
