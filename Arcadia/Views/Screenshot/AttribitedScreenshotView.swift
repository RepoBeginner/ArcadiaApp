//
//  AttribitedScreenshotView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 23/07/24.
//

import SwiftUI

struct AttribitedScreenshotView: View {
    
    @State private var screenshotImage: CGImage
    
    init(screenshotImage: CGImage) {
        self.screenshotImage = screenshotImage
    }
    
    var body: some View {
        #if os(macOS)
        let image = Image(nsImage: NSImage(cgImage: screenshotImage, size: NSSize(width: screenshotImage.width, height: screenshotImage.height)))
        #elseif os(iOS)
        let image = Image(uiImage: UIImage(cgImage: screenshotImage))
        #endif
        ZStack {
            image
                .resizable()
                .scaledToFill()
                .frame(width: 1080 / 4, height: 1920 / 4)
                .clipped()
                .blur(radius: 15)
            VStack {
                Spacer()
                image
                    .resizable()
                    .scaledToFit()
                Spacer()
                HStack {
                    Image("AppIcon_colored_asset")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    Text("Playing with Arcadia")
                    Spacer()
                }
            }
            .frame(width: 1080 / 4, height: 1920 / 4)
        }
    }
}

/*
#Preview {
    AttribitedScreenshotView()
}
*/
