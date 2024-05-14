//
//  CurrentFrameView.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 07/05/24.
//

import SwiftUI

struct CurrentFrameView: View {
    @Binding var currentFrame: CGImage?

    init(currentFrame: Binding<CGImage?>) {
        self._currentFrame = currentFrame
    }
    
    var body: some View {
        #if os(macOS)
        if let image = currentFrame {
            Image(nsImage: NSImage(cgImage: image, size: NSSize(width: image.width, height: image.height)))
                .aspectRatio(contentMode: .fit)
        } else {
            //TODO: render a placeholder image
            Text("No Image")
        }
        #else
        if let image = currentFrame {
            Image(uiImage: UIImage(cgImage: image))
                    .aspectRatio(contentMode: .fit)
                    
        } else {
            //TODO: render a placeholder image
            Text("No Image")
        }
        #endif


    }

}


#Preview {
    CurrentFrameView(currentFrame: Binding.constant(nil))
}

