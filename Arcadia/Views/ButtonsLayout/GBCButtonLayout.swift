//
//  GBCButtonLayout.swift
//  Arcadia
//
//  Created by Davide Andreoli on 23/05/24.
//

import SwiftUI

struct GBCButtonLayout: View {
    var body: some View {
        HStack {
            CapsuleButtonView(arcadiaCoreButton: .joypadStart, buttonText: "Start", color: Color.gray)
            CapsuleButtonView(arcadiaCoreButton: .joypadSelect, buttonText: "Select", color: Color.gray)
        }

        HStack {
            DPadView()
            Spacer()
            TwoButtonsView()
        }
        .padding()

    }
}

#Preview {
    GBCButtonLayout()
}
