//
//  Mark.swift
//

import CoreGraphics
import Foundation

/// A type-erased Mark.
public struct AnyMark: Mark {
    public var xPropertyScale: VisualPropertyScale
    public var yPropertyScale: VisualPropertyScale
    public var _yAxis: Axis?
    public var _xAxis: Axis?

    private let wrappedSymbolsForMark: (_: CGRect) -> [Sigil]
    private let wrappedAxisForMark: (_: CGRect) -> [Axis]

    public init<T: Mark>(_ specificMark: T) {
        wrappedSymbolsForMark = specificMark.symbolsForMark(in:)
        xPropertyScale = specificMark.xPropertyScale
        yPropertyScale = specificMark.yPropertyScale
        wrappedAxisForMark = specificMark.axisForMark(in:)
        _xAxis = specificMark._xAxis
        _yAxis = specificMark._yAxis
    }

    public func axisForMark(in rect: CGRect) -> [Axis] {
        wrappedAxisForMark(rect)
    }

    public func symbolsForMark(in rect: CGRect) -> [Sigil] {
        wrappedSymbolsForMark(rect)
    }
}
