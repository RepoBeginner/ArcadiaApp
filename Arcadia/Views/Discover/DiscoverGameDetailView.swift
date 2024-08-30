//
//  DiscoverGameDetailView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 28/08/24.
//

import SwiftUI

struct DiscoverGameDetailView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    private var game: ArcadiaFeaturedContent
    init(game: ArcadiaFeaturedContent) {
        self.game = game
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Image(game.game.coverImageAssetName)
                        .resizable()
                        .frame(width: 80, height: 80)
                    VStack(alignment: .leading) {
                        Text(game.game.name)
                            .font(.title)
                        Text(game.game.shortDescription)
                    }
                    Spacer()
                    Button(action: {}) {
                        Text("Add to library")
                    }
                }
                Divider()
                ScrollView(.horizontal) {
                    HStack {
                        VStack {
                            Text("Developer")
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                            Text(game.author.name)
                        }
                        
                        if let itchURL = game.author.itchURL {
                            Link(destination: itchURL) {
                                VStack {
                                    Text("Itch.io")
                                    Image(colorScheme == .dark ? "ItchLogoWhite" : "ItchLogoBlack")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                    Text("s")
                                        .hidden()
                                }
                            }
                            .foregroundStyle(.foreground)
                        }
                        if let instagramURL = game.author.instagramURL {
                            Link(destination: instagramURL) {
                                VStack {
                                    Text("Instagram")
                                    Image(colorScheme == .dark ? "InstagramLogoWhite" : "InstagramLogoBlack")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                    Text("s")
                                        .hidden()
                                }
                            }
                            .foregroundStyle(.foreground)
                        }
                        
                        Spacer()
                    }
                }
                Divider()
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(game.game.screenshotsAssetName, id: \.self) { screenshotName in
                            if screenshotName != "" {
                                Image(screenshotName)
                                    .resizable()
                                    .frame(width: 200, height: 200)
                            }
                        }
                    }
                }
                Divider()
                Text(game.game.longDescription)
                if let itchURL = game.game.itchURL {
                    Divider()
                    Link(destination: itchURL) {
                        VStack(alignment: .leading) {
                            Text("Find out more on the game's page")
                            Image(colorScheme == .dark ? "ItchLogoTextWhite" : "ItchLogoTextBlack")
                                .resizable()
                                .frame(width: 100, height: 25)
                        }
                    }
                    .foregroundStyle(.foreground)
                }
                Divider()
                Text("This game was provided for free by its author, but if you want to support their work you should consider following them on social media and donating through the links on this page.")
            }
            .padding()
        }
    }
}

#Preview {
    DiscoverGameDetailView(game: ArcadiaFeaturedContent(game: ArcadiaFeaturedGame(id: 0, name: "Awesome game", gameType: .gameBoyGame, shortDescription: "This game is awesome", longDescription: """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent ac dolor luctus, mollis enim congue, venenatis dui. Nunc tincidunt diam nec dui elementum viverra. Pellentesque bibendum bibendum justo. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur in est lectus. Vestibulum mauris justo, dignissim quis nisi sit amet, sodales varius est. Nunc sed blandit mauris, vitae finibus sapien. Aliquam feugiat ligula eget rhoncus eleifend. Morbi et bibendum dui. Ut sit amet neque in diam maximus commodo. Integer ut venenatis eros. Praesent ipsum enim, aliquam sed turpis non, pellentesque tempor urna. Maecenas a lectus vel sem luctus iaculis. Phasellus leo sapien, semper a ante id, molestie euismod sem. Nunc convallis gravida sodales. Nulla facilisi.

        Integer bibendum gravida suscipit. Vestibulum in felis ornare, dapibus sapien ac, consequat ligula. Fusce in tristique diam. Sed pharetra, nisi id blandit dignissim, urna ex condimentum tortor, nec sodales purus augue ac enim. Aliquam sit amet varius sem. In eu luctus ante, sed feugiat justo. Quisque sapien nisl, condimentum sit amet semper et, lacinia sit amet felis. Sed molestie lacus eu est finibus, et dapibus mauris tincidunt. Donec vitae purus ut risus suscipit sodales.

        Quisque vel urna in sapien aliquam semper. Fusce dapibus neque pharetra, accumsan metus quis, pulvinar nulla. Nam tristique ultricies pellentesque. Nulla ac tellus et dolor hendrerit rhoncus. Sed a ex mi. Suspendisse potenti. Nunc dapibus a massa id porttitor. Cras scelerisque massa sed felis auctor finibus. Curabitur at condimentum augue, sit amet interdum purus. Donec ornare ante tortor, quis tincidunt augue rutrum vel. Nulla tincidunt vitae magna non pellentesque. Aenean aliquam sapien eu risus commodo scelerisque. Maecenas vitae erat sodales eros aliquam pharetra eu porttitor lectus. Nullam sed efficitur dolor, id congue urna.

        Donec nisl mi, pharetra sit amet lacinia quis, efficitur in dui. Suspendisse consequat id nisl id luctus. Maecenas vitae sem laoreet, cursus sapien a, condimentum ligula. In eu volutpat arcu. Pellentesque egestas quam sed urna aliquam pellentesque. Donec metus tortor, varius vel tortor nec, bibendum pulvinar ante. Ut posuere lacinia risus non cursus. Morbi viverra, nunc sit amet sodales vehicula, ex leo dignissim risus, venenatis pharetra tellus sapien varius tortor. Sed felis sem, elementum quis turpis id, ullamcorper posuere velit. Praesent id pharetra massa. Curabitur vitae urna vel orci malesuada molestie sit amet sit amet nunc.

""", developerId: 0, coverImageAssetName: "gbc_icon", itchURL: URL(string: "http://instagram.com")!, screenshotsAssetName: []), author: ArcadiaGameDeveloper(id: 0, name: "Awesome developer", bio: "", instagramURL: nil, itchURL: nil, threadsURL: nil, twitterURL: nil)))
    .frame(height: 700)
}
