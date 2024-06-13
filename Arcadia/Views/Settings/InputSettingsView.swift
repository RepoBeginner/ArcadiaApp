//
//  InputSettingsView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 12/06/24.
//

import SwiftUI

struct InputSettingsView: View {
    
    @AppStorage("hapticFeedback") private var useHapticFeedback = true
    
    var body: some View {
        Form {
            Toggle(isOn: $useHapticFeedback) {
                Text("Haptic Feedback")
            }
        }
    }
}

#Preview {
    InputSettingsView()
}
