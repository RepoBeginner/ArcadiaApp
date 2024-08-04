//
//  PlayerSelectionView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 14/06/24.
//

import SwiftUI

struct PlayerSelectionView: View {
    @Environment(InputController.self) var inputController: InputController
    @AppStorage("hideButtons") private var hideButtons = false
    
    var body: some View {
        @Bindable var inputController = inputController
        
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
                    }
                }
            } else {
                Text("No controller connected")
            }

        }
        
        Section(header: Text("Hide buttons")) {
            Toggle(isOn: $hideButtons) {
                Text("Hide buttons")
            }
        }
    }
}

#Preview {
    PlayerSelectionView()
        .environment(InputController.shared)
}
