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
    public var axis: [Axis.AxisLocation: Axis]

    private let wrappedSymbolsForMark: (_: CGRect) -> [MarkSymbol]

    public init<T: Mark>(_ specificMark: T) {
        wrappedSymbolsForMark = specificMark.symbolsForMark(in:)
        axis = specificMark.axis
    }

    public func symbolsForMark(in rect: CGRect) -> [MarkSymbol] {
        wrappedSymbolsForMark(rect)
    }
}
