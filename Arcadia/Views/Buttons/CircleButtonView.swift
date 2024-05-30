//
//  CircleButtonView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 17/05/24.
//

import SwiftUI
import ArcadiaCore

struct CircleButtonView: View {
    private var arcadiaCoreButton: ArcadiaCoreButton
    private var color: Color
    @State private var timer: Timer?
    @State var isLongPressing = false
    
    init(arcadiaCoreButton: ArcadiaCoreButton, color: Color = .gray) {
        self.arcadiaCoreButton = arcadiaCoreButton
        self.color = color
    }
    
    var body: some View {
        
        Button(action: {
            if(self.isLongPressing){
                                self.isLongPressing.toggle()
                ArcadiaCoreEmulationState.sharedInstance.removeAction(port: 0, device: 1, index: 0, buttonIndex: arcadiaCoreButton.rawValue)
                                
                            } else {
                                if arcadiaCoreButton != .arcadiaButton {
                                    ArcadiaCoreEmulationState.sharedInstance.pressButton(port: 0, device: 1, index: 0, button: arcadiaCoreButton)
                                } else {
                                    ArcadiaCoreEmulationState.sharedInstance.pauseEmulation()
                                    ArcadiaCoreEmulationState.sharedInstance.showOverlay.toggle()
                                }
                                
                            }

        }) {
            Image(systemName: arcadiaCoreButton.systemImageName)
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundStyle(.primary)

            
/*
 ZStack {
     Circle()
         .fill(color
             .shadow(.inner(color: .black, radius: 5))
             .shadow(.drop(color: .black, radius: 10))
         
         )

         .frame(width: 60, height: 60)
     Text(buttonText)
         .font(.title)
         .foregroundStyle(
             Color.white
                 .shadow(.inner(color: .black, radius: 0.5, x: 0.5, y: 0.5))
         )
 }
 */
        }
        .simultaneousGesture(LongPressGesture(minimumDuration: 0.2).onEnded { _ in
                        print("long press")
                        self.isLongPressing = true
            ArcadiaCoreEmulationState.sharedInstance.addAction(port: 0, device: 1, index: 0, buttonIndex: arcadiaCoreButton.rawValue)
  
                    })
                

                       
    }
}

#Preview {
    CircleButtonView(arcadiaCoreButton: .joypadA)
}

