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
                Arcadia is a labor of love, born from my passion for Apple and for my desire to learn new things, and as such it is an imperfect product developed in my free time.
                If you like the product and would like to contribute to the development, here are some things that you could do:
                • signal any bug that you find, with a list of steps that will allow me to reproduce it
                • share any idea that you have for features that you think the app should have or improvements that could make the experience better
                • as you might have guessed I'm not a designer, so if you'd like to submit a custom app icon I would love to include it in the app so that everyone can use it, with credits of course
                • as of right now Arcadia is closed source, but I plan on making it open source as soon as I manage to organize the repository in a better way, and when that will happen you'll be able to contribute directly to the code if you are so inclined.
                
                Finally, Arcadia is a free app and will forever be as it is based on open source projects, but having an Apple Developer account is a cost for which I have no return. If you'd like to contribute with a monetary donation, I'll leave some in app purchases down below.
                """)
                
                ProductView(id: "com.davideandreoli.Arcadia.coffee") {
                    Text("☕️")
                }
                    .productViewStyle(.compact)
                    .padding()
                ProductView(id: "com.davideandreoli.Arcadia.sandwhich") {
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
