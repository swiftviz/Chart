//
//  Mark.swift
//
//
//  Created by Joseph Heck on 4/20/22.
//

import CoreGraphics
import Foundation

/// A type-erased Mark.
public struct AnyMark: Mark {
    public var xPropertyScale: VisualPropertyScale
    public var yPropertyScale: VisualPropertyScale

    private let wrappedSymbolsForMark: (_: CGRect) -> [MarkSymbol]
    private let wrappedAxisForMark: (_: CGRect) -> [Axis]
    private let wrappedXAxis: () -> Axis?
    private let wrappedYAxis: () -> Axis?

    public init<T: Mark>(_ specificMark: T) {
        wrappedSymbolsForMark = specificMark.symbolsForMark(in:)
        xPropertyScale = specificMark.xPropertyScale
        yPropertyScale = specificMark.yPropertyScale
        wrappedAxisForMark = specificMark.axisForMark(in:)
        wrappedXAxis = specificMark.getXAxis
        wrappedYAxis = specificMark.getYAxis
    }

    public func getXAxis() -> Axis? {
        wrappedXAxis()
    }

    public func getYAxis() -> Axis? {
        wrappedYAxis()
    }

    public func axisForMark(in rect: CGRect) -> [Axis] {
        wrappedAxisForMark(rect)
    }

    public func symbolsForMark(in rect: CGRect) -> [MarkSymbol] {
        wrappedSymbolsForMark(rect)
    }
}
