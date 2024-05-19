//
//  Trapezoid.swift
//  Arcadia
//
//  Created by Davide Andreoli on 17/05/24.
//

import Foundation
import SwiftUI


struct Trapezoid: Shape, InsettableShape {
    var insetAmount: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        let midHeight = height / 3 * 2
        
        // Adjust the dimensions by the inset amount
        let insetRect = rect.insetBy(dx: insetAmount, dy: insetAmount)
        let insetWidth = insetRect.size.width
        let insetHeight = insetRect.size.height
        let insetMidHeight = insetHeight / 3 * 2
        
        path.move(to: CGPoint(x: insetRect.minX, y: insetRect.minY))
        path.addLine(to: CGPoint(x: insetRect.minX, y: insetMidHeight))
        path.addLine(to: CGPoint(x: insetRect.minX + insetWidth * 0.5, y: insetRect.maxY))
        path.addLine(to: CGPoint(x: insetRect.maxX, y: insetMidHeight))
        path.addLine(to: CGPoint(x: insetRect.maxX, y: insetRect.minY))
        path.closeSubpath()
        
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var insettedShape = self
        insettedShape.insetAmount += amount
        return insettedShape
    }
}




