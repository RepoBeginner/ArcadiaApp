//
//  HelpView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 25/05/24.
//

import SwiftUI
import ArcadiaCore

struct ArcadiaButtonMapping: Identifiable {
    let id: Int
    let systemImageName: String
    let explanation: String
}

struct HelpView: View {
    @State private var people = [
        ArcadiaButtonMapping(id: 0, systemImageName: "a.circle.fill", explanation: "Test"),
        ArcadiaButtonMapping(id: 0, systemImageName: "b.circle.fill", explanation: "Test"),
        ArcadiaButtonMapping(id: 0, systemImageName: "y.circle.fill", explanation: "Test"),
        ArcadiaButtonMapping(id: 0, systemImageName: "x.circle.fill", explanation: "Test"),
    ]
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Help")
                    .font(.largeTitle)
                Text("""
                In this section you'll find many tips that will help you navigate the interface and use the app at its best.
                """)
                Text("Introduction")
                    .font(.title)
                Text("""
                Arcadia is, simply put, a frontend for multiple emulators (also called cores), each of which corresponds to a game system.
                To be more specific, Arcadia is a frontend for the Libretro API, as it is using the libretro version of the cores. It is intended to be a simple and accessible way to enjoy retro game systems, not a RetroArch rewrite. If you are tech savy and want more control over everything, you should definitely check out the RetroArch app.
                In Arcadia you'll find only one core for game system, selected by me based on many different parameters, and you will not have the possibility to customize core options (even though that's probably going to change in a future version).
                """)
                Text("Games")
                    .font(.title)
                Text("Organization")
                    .font(.title2)
                Text("""
                The first time it starts Arcadia will create a folder to store all the documents, you can find it inside the Document's folder if you're on a mac or in the Files app if you're on iPhone.
                In here you'll find a Games folder, a Saves folder and a States folder; the app's game library will show all the files present in the Games folder with their respective name.
                Arcadia relies on the fact that each game has one save and one state and all files have the same name. If you rename the games through the app everything will be taken care of for you, if you rename them manually from the folder just remember to rename the saves and states as well.
                """)
                Text("Where to find games?")
                    .font(.title2)
                Text("""
                I cannot include games with Arcadia for obvious legal reasons, but there are many different resources online that will guide you through the process of dumping game cartridges into roms, acquiring roms or homebrew games.
                """)
                Text("Controls")
                    .font(.title)
                Text("""
                For controls, I pondered a lot about whether to choose a customized interface for each system, where the buttons's appearance would mimick the original system, or a standard interface common to all cores.
                In the end, I've choosen the second option for two reasons:
                
                • developing a custom interface for each system would be very time consuming, each asset would have to be manually crafted, be it in Inkscape or SwiftUI
                • a standardized button appearance should make the app more cohesive and should make it easier to adapt to the different systems
                
                Choosing the second options means that I've had to make some choices for a general button appearance, so below you'll find the mappings that apply to all systems.
                """)
                // TODO: Fix the list not showing (options: make scrollview into list and this list into a foreach, but I don't like the page inset)
                List(ArcadiaCoreButton.allCases) {item in
                    HStack {
                        Image(systemName: item.systemImageName)
                        Text(item.buttonName)
                        Text(item.mappingExplanation)
                    }
                    
                }
                /*
                Table(ArcadiaCoreButton.allCases) {
                    TableColumn("Button image") { item in
                        Image(systemName: item.systemImageName)
                    }
                    TableColumn("Name", value: \.buttonName)
                    TableColumn("Mapping", value: \.mappingExplanation)
                }
                .frame(minWidth: 100, minHeight: 400)
                 */
                Text("I'm not saying that I'll never go into route one, just not as of right now.")
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    HelpView()
}
