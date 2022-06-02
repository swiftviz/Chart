//
//  GraphicsContext+drawRotated.swift
//  
//
//  Created by Joseph Heck on 6/2/22.
//

import SwiftUI

extension GraphicsContext {
    func drawRotatedText(_ text: Text, at: CGPoint, rotatedBy: Angle, fromCorner: UnitPoint = .topLeading) {
        // make a copy of the drawing context
        var localContext = self
        // assemble a transform that first rotates, then translates, to the location desired
        localContext.transform = CGAffineTransform(rotationAngle: rotatedBy.radians)
            .concatenating(CGAffineTransform(translationX: at.x, y: at.y))
        // draw the text at .zero referencing the provided UnitPoint corner
        localContext.draw(text, at: .zero, anchor: fromCorner)
    }
}
