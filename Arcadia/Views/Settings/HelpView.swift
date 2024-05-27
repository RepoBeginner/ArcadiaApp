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
                Text("Controls")
                    .font(.title)
                Text("""
                For controls, I pondered a lot about whether to choose a customized interface for each system, where the buttons's appearance would mimick the original system, or a standard interface common to all cores.
                In the end, I've choosen the second option for two reasons:
                
                • developing a custom interface for each system would be very time consuming, each asset would have to be manually crafted, be it in Inkscape or SwiftUI
                • a standardized button appearance should make the app more cohesive and should make it easier to adapt to the different systems
                
                Choosing the second options means that I've had to make some choices for a general button appearance, so below you'll find the mappings that apply to all systems.
                """)
                Table(ArcadiaCoreButton.allCases) {
                    TableColumn("Button image") { item in
                        Image(systemName: item.systemImageName)
                    }
                    TableColumn("Name", value: \.buttonName)
                    TableColumn("Mapping", value: \.mappingExplanation)
                }
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
