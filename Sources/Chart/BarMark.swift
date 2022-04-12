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
    let data: [DataSource]
    let value: QuantitativeVisualChannel<DataSource, Double>
    let category: BandVisualChannel<DataSource>
    let orientation: Orientation = .vertical

    public init(data: [DataSource], value: QuantitativeVisualChannel<DataSource, Double>, category: BandVisualChannel<DataSource>) {
        self.data = data
        self.value = value.applyDomain(data)
        self.category = category.applyDomain(data)
    }

    public func symbolsForMark(rangeLower _: CGFloat, rangeHigher _: CGFloat) -> [MarkSymbol] {
        []
    }
}
