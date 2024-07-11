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
                This application is merely a frontend to the Libretro API, and it wouldn't be possible without the incredible work done by the [Libretro Team](https://www.libretro.com). Special thanks also go to [Retroreversing](https://www.retroreversing.com) for their invaluable resources, which have made the entire process much easier.
                """)
                Text("Cores")
                    .font(.title)
                Text("""
                Arcadia is built on numerous cores developed by extraordinary developers who have made it possible to relive classic console experiences on other devices. In Arcadia, you will find the following cores:
                
                • GameBoy Advance: [Libretro version](https://github.com/libretro/vba-next) of VBA Next
                • GameBoy (Color): drhelius's [Gearboy](https://github.com/drhelius/Gearboy)
                • NES: [Libretro version](https://github.com/libretro/nestopia) of [Nestopia UE](https://github.com/0ldsk00l/nestopia)
                • SNES: [Libretro version](https://github.com/libretro/snes9x) of [snes9x](https://github.com/snes9xgit/snes9x)
                """)
                Text("Other")
                    .font(.title)
                Text("""
                • Game matching and cover downloading are provided thanks to [OpenVGDB](https://github.com/OpenVGDB/OpenVGDB)
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
