//
//  EmptyButtonView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 06/08/24.
//

import SwiftUI

struct EmptyButtonView: View {
    private var size: CGFloat
    
    init(size: CGFloat) {
        self.size = size
    }
    
    var body: some View {
        Image(systemName: "arrow.up.backward.and.arrow.down.forward.circle.fill")
            .resizable()
            .frame(width: size, height: size)
            .opacity(0)
    }
}

#Preview {
    EmptyButtonView(size: 50)
}
