//
//  CreditsView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 25/05/24.
//

import SwiftUI

struct CreditsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Arcadia")
                    .font(.largeTitle)
                Text("""
                This application is nothing but a frontend to the Libretro API, so nothing about this would be possible without the amazing work done by the [Libretro Team](https://www.libretro.com).
                Another honorary mention goes to [Retroreversing](https://www.retroreversing.com), because thanks to the resources they share the whole process has been made easier.
                """)
                Text("Cores")
                    .font(.title)
                Text("""
                Arcadia is built on top many different cores developed by extraordinary developers who made it possible to relive classic console experiences on other devices.
                In Arcadia, you will find the following cores:
                
                • GameBoy (Color): drhelius's [Gearboy](https://github.com/drhelius/Gearboy)
                """)
                Spacer()
            }
            .padding()
            
        }
    }
}

#Preview {
    CreditsView()
}
