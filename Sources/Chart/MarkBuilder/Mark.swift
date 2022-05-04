//
//  Mark.swift
//
//
//  Created by Joseph Heck on 3/25/22.
//
import SwiftUI

/// A type that represents one or more visual symbols displays in a chart.
///
/// A mark describes the configuration of how data is mapped to visual properties relevant to the type of mark.
public protocol Mark {
    var fill: Color { get }
    var stroke: Color { get } // ? (https://developer.apple.com/documentation/coregraphics/cgcolor)
    var title: String { get }

    // maybe use/infer from https://developer.apple.com/documentation/swiftui/strokestyle
    // - lineWidth: CGFloat
    // - lineCap: CGLineCap (https://developer.apple.com/documentation/coregraphics/cglinecap)
    // - lineJoin: CGLineJoin (https://developer.apple.com/documentation/coregraphics/cglinejoin)
    // - miterLimit: CGFloat
    // - dash: [CGFloat]
    // - dashPhase: CGFloat

    /// Creates a list of symbols to render into a rectangular drawing area that you specify.
    /// - Parameter in: The rectangle into which to scale and draw the symbols.
    /// - Returns: A list of symbol data structures with the information needed to draw them onto a canvas or into CoreGraphics context.
    func symbolsForMark(in: CGRect) -> [MarkSymbol]
}

// MARK: - default values for common Mark properties

public extension Mark {
    var fill: Color {
        Color.primary
    }

    var stroke: Color {
        Color.primary
    }

    var title: String {
        ""
    }
}
