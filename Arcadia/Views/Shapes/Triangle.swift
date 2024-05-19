//
//  Triangle.swift
//  Arcadia
//
//  Created by Davide Andreoli on 19/05/24.
//

import Foundation
import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Start from the bottom left
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        // Add line to the top middle
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        // Add line to the bottom right
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        // Close the path to create the third side of the triangle
        path.closeSubpath()

        return path
    }
}


