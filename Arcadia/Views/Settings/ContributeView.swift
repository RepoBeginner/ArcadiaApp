//
//  ContributeView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 20/06/24.
//

import SwiftUI
import StoreKit

struct ContributeView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("""
                Arcadia is a labor of love, born from my passion for Apple and my desire to learn new things. As such, it is an imperfect product developed in my free time. If you enjoy the app and would like to contribute to its development, here are some ways you can help:
                • Report any bugs you find, including steps to reproduce them.
                • Share any ideas for new features or improvements to enhance the user experience.
                • I am not a designer, so if you'd like to submit a custom app icon, I would love to include it in the app with credits to you.
                • Currently, Arcadia is closed source, but I plan to make it open source once I organize the repository better. When that happens, you'll be able to contribute directly to the code if you wish.

                Finally, Arcadia is a free app and will remain so, as it is based on open source projects. However, maintaining an Apple Developer account incurs costs. If you'd like to support with a monetary donation, I will include some in-app purchases below.
                """)

                
                ProductView(id: "com.davideandreoli.Arcadia.coffee") {
                    Text("☕️")
                }
                    .productViewStyle(.compact)
                    .padding()
                ProductView(id: "com.davideandreoli.Arcadia.sandwich") {
                    Text("🥪")
                }
                    .productViewStyle(.compact)
                    .padding()
                ProductView(id: "com.davideandreoli.Arcadia.pizza") {
                    Text("🍕")
                }
                    .productViewStyle(.compact)
                    .padding()
            }
            .padding()
        }
        .navigationTitle("Contribute")
    }
}

#Preview {
    ContributeView()
}
