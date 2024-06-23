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
                Text("""
                This application is nothing but a frontend to the Libretro API, so nothing about this would be possible without the amazing work done by the [Libretro Team](https://www.libretro.com).
                Another honorary mention goes to [Retroreversing](https://www.retroreversing.com), because thanks to the resources they share the whole process has been made easier.
                """)
                Text("Cores")
                    .font(.title)
                Text("""
                Arcadia is built on top many different cores developed by extraordinary developers who made it possible to relive classic console experiences on other devices.
                In Arcadia, you will find the following cores:
                
                • GameBoy Advance: [Libretro version](https://github.com/libretro/vba-next) of VBA Next
                • GameBoy (Color): drhelius's [Gearboy](https://github.com/drhelius/Gearboy)
                • NES: [Libretro version](https://github.com/libretro/nestopia) of [Nestopia UE](https://github.com/0ldsk00l/nestopia)
                """)
                Text("Other")
                    .font(.title)
                Text("""
                • Game matching and cover downloading is provided thanks to [OpenVGDB](https://github.com/OpenVGDB/OpenVGDB)
                """)
                Spacer()
            }
            .padding()
            
        }
        .navigationTitle("Credits")
    }
}

#Preview {
    CreditsView()
}
