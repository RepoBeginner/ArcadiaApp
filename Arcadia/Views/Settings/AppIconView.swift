//
//  AppIconView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 20/06/24.
//

import SwiftUI

struct AppIcon: Hashable {
    var iconName: String?
    var displayName: String
    var assetName: String
    var description: String
    
    init(iconName: String? = nil, displayName: String, assetName: String, description: String) {
        self.iconName = iconName
        self.displayName = displayName
        self.assetName = assetName
        self.description = description
    }
}

struct AppIconView: View {
    
    @State private var icons: [String] = [
        "AppIcon_colored",
        "AppIcon_dark",
        "AppIcon_light",
        "AppIcon_pink"
    ]
    
    @State private var defaultIcons: [AppIcon] = [
        AppIcon(iconName: nil, displayName: "Colored", assetName: "AppIcon_colored_asset", description: "Default colored version"),
        AppIcon(iconName: "AppIcon_dark", displayName: "Dark", assetName: "AppIcon_dark_asset", description: "Default dark version"),
        AppIcon(iconName: "AppIcon_light", displayName: "Light", assetName: "AppIcon_light_asset", description: "Default light version"),
        AppIcon(iconName: "AppIcon_pink", displayName: "Pink", assetName: "AppIcon_pink_asset", description: "Pink version"),
        AppIcon(iconName: "AppIcon_green", displayName: "Green", assetName: "AppIcon_greeen_asset", description: "Green version, dedicated to the houseplant from which this app takes its name")
    ]
    
    var body: some View {
        List {
            ForEach(defaultIcons, id: \.self) {icon in
                HStack {
                    Button(action: {
                        #if os(iOS)
                        UIApplication.shared.setAlternateIconName(icon.iconName) { (error) in
                            if let error = error {
                                print("Failed request to update the app’s icon with \(icon.assetName): \(error)")
                            }
                        }
                        #endif
                    }) {
                        Image(icon.assetName)
                            .resizable()
                            .frame(maxWidth: 80, maxHeight: 80)
                    }
                    Text("\(icon.displayName)")
                }
            }
        }
    }
}

#Preview {
    AppIconView()
}
