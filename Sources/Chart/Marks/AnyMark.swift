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
    public var xPropertyType: VisualPropertyType
    public var yPropertyType: VisualPropertyType

    private let wrappedSymbolsForMark: (_: CGRect) -> [MarkSymbol]
    private let wrappedAxisForMark: (_: CGRect) -> [Axis.AxisLocation: Axis]

    public init<T: Mark>(_ specificMark: T) {
        wrappedSymbolsForMark = specificMark.symbolsForMark(in:)
        wrappedAxisForMark = specificMark.axisFromMark(in:)
        xPropertyType = specificMark.xPropertyType
        yPropertyType = specificMark.yPropertyType
    }

    public func axisFromMark(in rect: CGRect) -> [Axis.AxisLocation: Axis] {
        wrappedAxisForMark(rect)
    }

    public func symbolsForMark(in rect: CGRect) -> [MarkSymbol] {
        wrappedSymbolsForMark(rect)
    }
}
