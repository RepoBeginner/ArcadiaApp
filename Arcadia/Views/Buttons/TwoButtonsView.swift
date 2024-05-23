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
                    .frame(height: 80)
                CircleButtonView(arcadiaCoreButton: .joypadB, buttonText: "B", color: .gray)
            }
            Spacer()
                .frame(width: 30)
            VStack {
                CircleButtonView(arcadiaCoreButton: .joypadA, buttonText: "A", color: .gray)
                Spacer()
                    .frame(height: 80)
            }
            
        }
    }
}

#Preview {
    TwoButtonsView()
}
