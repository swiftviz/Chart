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

    func symbolsForMark(rangeLower: CGFloat, rangeHigher: CGFloat) -> [MarkSymbol]
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

/// A type-erased Mark.
public struct AnyMark: Mark {
    private let wrappedSymbolsForMark: (_ rangeLower: CGFloat, _ rangeHigher: CGFloat) -> [MarkSymbol]

    public init<T: Mark>(_ specificMark: T) {
        wrappedSymbolsForMark = specificMark.symbolsForMark(rangeLower:rangeHigher:)
    }

    public func symbolsForMark(rangeLower: CGFloat, rangeHigher: CGFloat) -> [MarkSymbol] {
        wrappedSymbolsForMark(rangeLower, rangeHigher)
    }
}
