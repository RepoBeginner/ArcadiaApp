//
//  BButtonView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 17/07/24.
//

import SwiftUI
import ArcadiaCore


struct BButtonView: View {
    var body: some View {
        VStack(spacing: -5) {

            Spacer()
                .frame(width: 50, height: 50)
                    HStack(spacing: -0) {
                        Spacer()
                            .frame(width: 50, height: 50)

                        Spacer()
                            .frame(width: 50, height: 50)
                        Spacer()
                            .frame(width: 50, height: 50)

                    }
            CircleButtonView(arcadiaCoreButton: .joypadB, size:50)
                }
    }
}


#Preview {
    BButtonView()
        .environment(ArcadiaCoreEmulationState.sharedInstance)
}
