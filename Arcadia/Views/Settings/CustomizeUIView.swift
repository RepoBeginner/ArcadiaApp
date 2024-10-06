//
//  CustomizeUIView.swift
//  Altea
//
//  Created by Davide Andreoli on 06/10/24.
//

import SwiftUI
import ArcadiaCore

struct CustomizeUIView: View {
    @AppStorage("directionPadButtonScale") private var directionPadButtonScale: Double = 1
    @AppStorage("actionPadButtonScale") private var actionPadButtonScale: Double = 1
    @AppStorage("smallButtonScale") private var smallButtonScale: Double = 1
    @AppStorage("shoulderButtonScale") private var shoulderButtonScale: Double = 1
    @AppStorage("buttonOpacity") private var buttonOpacity: Double = 1
    @AppStorage("customizeGameViewBackgroundColor") private var customizeGameViewBackgroundColor: Bool = false
    @AppStorage("gameViewBackgroundColor") var gameViewBackgroundColor: Color = .black
    
    var body: some View {
        Form {
            Section(header: Text("Button size"), footer: Text("Use the sliders to adjust button scale, double tap a slider to restore its original value")) {
                VStack(alignment: .leading) {
                    Text("Direction Pad")
                        .font(.headline)
                    Slider(value: $directionPadButtonScale, in: 0.5...1.5, step: 0.1)
                    {
                        Text("Scale")
                    } minimumValueLabel: {
                        Text("0.5")
                    } maximumValueLabel: {
                        Text("1.5")
                    }
                    .onTapGesture(count: 2) {
                        directionPadButtonScale = 1
                    }
                    HStack {
                        Spacer()
                        DPadView()
                            .disabled(true)
                        Spacer()
                    }
                }
                VStack(alignment: .leading) {
                    Text("Action Pad")
                        .font(.headline)
                    Slider(value: $actionPadButtonScale, in: 0.5...1.5, step: 0.1)
                    {
                        Text("Scale")
                    } minimumValueLabel: {
                        Text("0.5")
                    } maximumValueLabel: {
                        Text("1.5")
                    }
                    .onTapGesture(count: 2) {
                        actionPadButtonScale = 1
                    }
                    HStack {
                        Spacer()
                        ActionButtonsView(numberOfButtons: 4)
                            .disabled(true)
                        Spacer()
                    }
                }
                VStack(alignment: .leading) {
                    Text("Small buttons")
                        .font(.headline)
                    Slider(value: $smallButtonScale, in: 0.5...1.5, step: 0.1)
                    {
                        Text("Scale")
                    } minimumValueLabel: {
                        Text("0.5")
                    } maximumValueLabel: {
                        Text("1.5")
                    }
                    .onTapGesture(count: 2) {
                        smallButtonScale = 1
                    }
                    HStack {
                        Spacer()
                        CircleButtonView(arcadiaCoreButton: .arcadiaButton, size: 35*smallButtonScale)
                            .disabled(true)
                        Spacer()
                    }
                }
                VStack(alignment: .leading) {
                    Text("Shoulder buttons")
                        .font(.headline)
                    Slider(value: $shoulderButtonScale, in: 0.5...1.5, step: 0.1)
                    {
                        Text("Scale")
                    } minimumValueLabel: {
                        Text("0.5")
                    } maximumValueLabel: {
                        Text("1.5")
                    }
                    .onTapGesture(count: 2) {
                        shoulderButtonScale = 1
                    }
                    HStack {
                        Spacer()
                        CircleButtonView(arcadiaCoreButton: .joypadR, height: 40*shoulderButtonScale, width: 70*shoulderButtonScale)
                            .disabled(true)
                        Spacer()
                    }
                }
            }
            Section(header: Text("Button opacity"), footer: Text("Use the slider to adjust button opacity, double tap the slider to restore its original value. A lower value means that the button will be more transparent.")) {
                VStack(alignment: .leading) {
                    Slider(value: $buttonOpacity, in: 0.3...1, step: 0.1)
                    {
                        Text("Scale")
                    } minimumValueLabel: {
                        Text("0.3")
                    } maximumValueLabel: {
                        Text("1")
                    }
                    .onTapGesture(count: 2) {
                        buttonOpacity = 1
                    }
                    HStack {
                        Spacer()
                        CircleButtonView(arcadiaCoreButton: .arcadiaButton, size: 50*smallButtonScale)
                            .disabled(true)
                        Spacer()
                    }
                }
            }
            
            Section(header: Text("Game view background color"), footer: Text("Use the toggle to turn on the customization, and pick a color using the slider. To go back to the default behaviour, simply turn off the toggle.")) {
                Toggle(isOn: $customizeGameViewBackgroundColor) {
                    Text("Customize background color")
                }
                ColorPicker("Game view background color", selection: $gameViewBackgroundColor, supportsOpacity: false)
            }
        }
    }
}

#Preview {
    CustomizeUIView()
        .environment(ArcadiaCoreEmulationState.sharedInstance)
        .environment(InputController.shared)
}
