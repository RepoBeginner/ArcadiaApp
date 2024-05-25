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
            CircleButtonView(arcadiaCoreButton: .joypadStart)
            Spacer()
                .frame(width: 50)
            CircleButtonView(arcadiaCoreButton: .joypadSelect)
        }

        HStack {
            DPadView()
            Spacer()
            VStack {
                Spacer()
                    .frame(maxHeight: 100)
                CircleButtonView(arcadiaCoreButton: .arcadiaButton)
            }
            Spacer()
            TwoButtonsView()
        }
        .padding()

    }
}

#Preview {
    GBCButtonLayout()
}
