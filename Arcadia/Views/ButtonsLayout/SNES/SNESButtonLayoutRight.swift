//
//  SNESButtonLayoutRight.swift
//  Arcadia
//
//  Created by Davide Andreoli on 27/06/24.
//

import SwiftUI
import ArcadiaCore

struct SNESButtonLayoutRight: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                CircleButtonView(arcadiaCoreButton: .joypadStart, size: 35)
                Spacer()
                CircleButtonView(arcadiaCoreButton: .joypadR, size: 50)
            }
            .padding()

            HStack {
                FourButtonsView()
            }
            .padding()
        }
    }
}

#Preview {
    SNESButtonLayoutRight()
}
