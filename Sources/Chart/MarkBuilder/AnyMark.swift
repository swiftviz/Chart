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
    // TODO(heckj): Might need to change how this type-erasure mechanism is working, shifting to a fully
    // wrapped type erasure in order to allow underlying components to be manipulated in a consistent way.
    //
    // This closure-based type erasure hides everything except for the ability to get symbols out when
    // its provided with a range into which they can be drawn, but there's a use case where we want to
    // align the domains of multiple marks, with different data sets, into a single - broader and combined -
    // domain for the representation. Currently each mark is entirely encapsulated, and there's no way after
    // the type-erasure to "reach in" and manipulate the domains to allow them to be expanded and/or synchronized,
    // let alone read to determine a corrected domain for each symbol.

    private let wrappedSymbolsForMark: (_ rangeLower: CGFloat, _ rangeHigher: CGFloat) -> [MarkSymbol]

    public init<T: Mark>(_ specificMark: T) {
        wrappedSymbolsForMark = specificMark.symbolsForMark(rangeLower:rangeHigher:)
    }

    public func symbolsForMark(rangeLower: CGFloat, rangeHigher: CGFloat) -> [MarkSymbol] {
        wrappedSymbolsForMark(rangeLower, rangeHigher)
    }
}
