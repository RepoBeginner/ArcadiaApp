//
//  SNESButtonLayoutLeft.swift
//  Arcadia
//
//  Created by Davide Andreoli on 27/06/24.
//

import SwiftUI
import ArcadiaCore

struct SNESButtonLayoutLeft: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                CircleButtonView(arcadiaCoreButton: .joypadL, size: 50)
                Spacer()
                CircleButtonView(arcadiaCoreButton: .joypadSelect, size: 35)
            }
            .padding()

            HStack {
                DPadView()
                Spacer()
                VStack {
                    Spacer()
                        .frame(maxHeight: 100)
                    CircleButtonView(arcadiaCoreButton: .arcadiaButton, size: 35)
                }
            }
            .padding()
        }
    }
}

#Preview {
    SNESButtonLayoutLeft()
}
