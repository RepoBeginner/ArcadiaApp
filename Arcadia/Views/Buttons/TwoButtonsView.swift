//
//  TwoButtonsView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 20/05/24.
//

import SwiftUI
import ArcadiaCore

struct TwoButtonsView: View {
    var body: some View {
        HStack(spacing: 5) {
            VStack {
                Spacer()
                    .frame(height: 70)
                CircleButtonView(arcadiaCoreButton: .joypadB)
            }
            Spacer()
                .frame(width: 30)
            VStack {
                CircleButtonView(arcadiaCoreButton: .joypadA)
                Spacer()
                    .frame(height: 70)
            }
            
        }
    }
}

#Preview {
    TwoButtonsView()
}
