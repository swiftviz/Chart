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
    associatedtype MarkType: Mark

    // let visibleAxis: [AxisDefn]

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

    func symbolsForMark() -> [MarkSymbol]
}

// MARK: - default values for common Mark properties

public extension Mark {
    var fill: Color {
        Color.black
    }

    var stroke: Color {
        Color.black
    }

    var title: String {
        ""
    }
}
