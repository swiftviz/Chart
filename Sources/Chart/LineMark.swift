//
//  LineMark.swift
//
//
//  Created by Joseph Heck on 3/25/22.
//

import SwiftUI
import SwiftVizScale

/// A type that represents a series of bars.
///
/// The type infers the number and visual properties of the bars from the data you provide to the visual channels when declaring a bar mark.
public struct LineMark<DataSource>: Mark {
    var data: [DataSource]
    public func symbolsForMark(rangeLower _: CGFloat, rangeHigher _: CGFloat) -> [MarkSymbol] {
        []
    }

    public typealias DataType = Any
//    public var mappings: [AnyVisualChannel<LineMark, Any>]

    public typealias MarkType = Self
    public init(data: [DataSource],
                x _: QuantitativeVisualChannel<DataSource, Double>,
                y _: QuantitativeVisualChannel<DataSource, Double>)
    {
        self.data = data
    }
}
