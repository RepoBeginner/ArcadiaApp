//
//  InputSettingsView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 12/06/24.
//

import SwiftUI
import GameController

struct InputSettingsView: View {
    
    @AppStorage("hapticFeedback") private var useHapticFeedback = true
    @Environment(InputController.self) var inputController: InputController
    
    var body: some View {
        @Bindable var inputController = inputController
        Form {
            PlayerSelectionView()
            Section(header: Text("Keyboard mapping")) {
                if inputController.keyboardIsConnected {
                    ForEach(Array(inputController.gameKeyboardMapping.keys.sorted(by: {element1, element2 in element1.buttonName < element2.buttonName})), id: \.self) {arcadiaButton in
                        Picker("\(arcadiaButton.buttonName)", selection: $inputController.gameKeyboardMapping[arcadiaButton]) {
                            Text("Q").tag(Optional(GCKeyCode.keyQ))
                            Text("W").tag(Optional(GCKeyCode.keyW))
                            Text("E").tag(Optional(GCKeyCode.keyE))
                            Text("R").tag(Optional(GCKeyCode.keyR))
                            Text("T").tag(Optional(GCKeyCode.keyT))
                            Text("Y").tag(Optional(GCKeyCode.keyY))
                            Text("U").tag(Optional(GCKeyCode.keyU))
                            Text("I").tag(Optional(GCKeyCode.keyI))
                            Text("O").tag(Optional(GCKeyCode.keyO))
                            Text("P").tag(Optional(GCKeyCode.keyP))
                            Text("A").tag(Optional(GCKeyCode.keyA))
                            Text("S").tag(Optional(GCKeyCode.keyS))
                            Text("D").tag(Optional(GCKeyCode.keyD))
                            Text("F").tag(Optional(GCKeyCode.keyF))
                            Text("G").tag(Optional(GCKeyCode.keyG))
                            Text("H").tag(Optional(GCKeyCode.keyH))
                            Text("J").tag(Optional(GCKeyCode.keyJ))
                            Text("K").tag(Optional(GCKeyCode.keyK))
                            Text("L").tag(Optional(GCKeyCode.keyL))
                            Text("Z").tag(Optional(GCKeyCode.keyZ))
                            Text("X").tag(Optional(GCKeyCode.keyX))
                            Text("C").tag(Optional(GCKeyCode.keyC))
                            Text("V").tag(Optional(GCKeyCode.keyV))
                            Text("B").tag(Optional(GCKeyCode.keyB))
                            Text("N").tag(Optional(GCKeyCode.keyN))
                            Text("M").tag(Optional(GCKeyCode.keyM))
                            Text("Up arrow").tag(Optional(GCKeyCode.upArrow))
                            Text("Down arrow").tag(Optional(GCKeyCode.downArrow))
                            Text("Left arrow").tag(Optional(GCKeyCode.leftArrow))
                            Text("Right arrow").tag(Optional(GCKeyCode.rightArrow))
                            Text("Numpad 1").tag(Optional(GCKeyCode.one))
                            Text("Numpad 2").tag(Optional(GCKeyCode.two))
                            Text("Numpad 3").tag(Optional(GCKeyCode.three))
                            Text("Numpad 4").tag(Optional(GCKeyCode.four))
                            Text("Numpad 5").tag(Optional(GCKeyCode.five))
                            Text("Numpad 6").tag(Optional(GCKeyCode.six))
                            Text("Numpad 7").tag(Optional(GCKeyCode.seven))
                            Text("Numpad 8").tag(Optional(GCKeyCode.eight))
                            Text("Numpad 9").tag(Optional(GCKeyCode.nine))
                            Text("Numpad 0").tag(Optional(GCKeyCode.zero))
                            Text("Left Ctrl").tag(Optional(GCKeyCode.leftControl))
                            Text("Left Shift").tag(Optional(GCKeyCode.leftShift))
                            Text("Right Shift").tag(Optional(GCKeyCode.rightShift))
                            Text("Left Alt").tag(Optional(GCKeyCode.leftAlt))
                            Text("Right Alt").tag(Optional(GCKeyCode.rightAlt))
                            Text("Enter").tag(Optional(GCKeyCode.returnOrEnter))
                        }
                        .onChange(of: inputController.gameKeyboardMapping[arcadiaButton]) {
                            inputController.updateKeyboardMapping()
                        }
                       
                    }
                } else {
                    Text("No keyboard connected")
                }
            }
            Toggle(isOn: $useHapticFeedback) {
                Text("Haptic Feedback")
            }
        }
        .navigationTitle("Input settings")
    }
}

#Preview {
    InputSettingsView()
        .environment(InputController.shared)
}
