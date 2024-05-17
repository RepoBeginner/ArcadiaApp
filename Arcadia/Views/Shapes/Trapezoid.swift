//
//  Trapezoid.swift
//  Arcadia
//
//  Created by Davide Andreoli on 17/05/24.
//

import Foundation
import SwiftUI

struct Trapezoid: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        let midHeight = height * 0.7
        

        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: width * 0.05, y: midHeight))
        path.addLine(to: CGPoint(x: width * 0.5, y: height))
        path.addLine(to: CGPoint(x: width * 0.95, y: midHeight))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()

        return path
    }
}
