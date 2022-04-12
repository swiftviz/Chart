//
//  BarMark.swift
//
//
//  Created by Joseph Heck on 3/25/22.
//
import SwiftUI
import SwiftVizScale

enum Orientation {
    case vertical
    case horizontal
    case depth
}

/// A type that represents a series of bars.
///
/// The type infers the number and visual properties of the bars from the data you provide to the visual channels when declaring a bar mark.
public struct BarMark<DataSource>: Mark {
    var data: [DataSource]
    let value: QuantitativeVisualChannel<DataSource, Double> //, CGFloat
    let category: BandVisualChannel<DataSource>

    public func symbolsForMark(rangeLower _: CGFloat, rangeHigher _: CGFloat) -> [MarkSymbol] {
        []
    }

    public typealias MarkType = Self

    var orientation: Orientation = .vertical

    public init(data: [DataSource], value: QuantitativeVisualChannel<DataSource, Double>, category: BandVisualChannel<DataSource>) {
        self.data = data
        self.value = value
        self.category = category
    }
}
