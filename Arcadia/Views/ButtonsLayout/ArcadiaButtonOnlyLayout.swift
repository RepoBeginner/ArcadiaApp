//
//  ArcadiaButtonLayout.swift
//  Arcadia
//
//  Created by Davide Andreoli on 04/08/24.
//

import SwiftUI
import ArcadiaCore

struct ArcadiaButtonOnlyLayout: View {
    
    var body: some View {
        HStack {
            VStack {
                Spacer()
                CircleButtonView(arcadiaCoreButton: .arcadiaButton, size: 35)
            }
            .padding()
            Spacer()
        }

            
        }
}

#Preview {
    ArcadiaButtonOnlyLayout()
        .environment(ArcadiaCoreEmulationState.sharedInstance)
        .environment(InputController.shared)
}
