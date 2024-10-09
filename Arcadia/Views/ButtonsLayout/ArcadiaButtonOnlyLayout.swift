//
//  ArcadiaButtonLayout.swift
//  Arcadia
//
//  Created by Davide Andreoli on 04/08/24.
//

import SwiftUI
import ArcadiaCore

struct ArcadiaButtonOnlyLayout: View {
    
    @AppStorage("smallButtonScale") private var smallButtonScale: Double = 1
    
    var body: some View {
        HStack {
            VStack {
                Spacer()
                CircleButtonView(arcadiaCoreButton: .arcadiaButton, size: 35*smallButtonScale)
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
