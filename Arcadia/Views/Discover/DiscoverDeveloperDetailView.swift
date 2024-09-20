//
//  DiscoverDeveloperDetailView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 30/08/24.
//

import SwiftUI

struct DiscoverDeveloperDetailView: View {
    
    private var developer: ArcadiaGameDeveloper
    @Environment(\.colorScheme) var colorScheme
    
    init(developer: ArcadiaGameDeveloper) {
        self.developer = developer
    }
    
    var body: some View {
        List {
            HStack {
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text(developer.name)
                    .font(.title)
                }
            VStack(alignment: .leading) {
                Text("Socials")
                    .font(.headline)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(developer.socials, id: \.self) { social in
                            Link(destination: social.link!) {
                                VStack {
                                    Text(social.name)
                                        .font(.subheadline)
                                    Image(colorScheme == .dark ? social.whiteLogoAssetName : social.blackLogoAssetName)
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                }
                            }
                            .foregroundStyle(.foreground)
                            Divider()
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            if developer.bio != "" {
                VStack(alignment: .leading) {
                    Text("Bio")
                        .font(.headline)
                    Text(developer.bio)
                }
            }
            Text("This developer has generously made their games available for free, allowing more people to enjoy retro gaming with ease. If you appreciate their work, consider showing your support through the links above.")
            }
        .navigationTitle("Developer")
            
        }
        
    }


#Preview {
    DiscoverDeveloperDetailView(developer: ArcadiaGameDeveloper(id: 0, name: "Awesome developer", bio: "Bio", socials: [ArcadiaDeveloperSocialLink(name: "Itch", link: URL(string: "http://")!)]))
}
