//
//  DotMark.swift
//
//
//  Created by Joseph Heck on 3/25/22.
//

import SwiftUI
import SwiftVizScale

/// A type that represents a series of bars.
///
/// The type infers the number and visual properties of the bars from the data you provide to the visual channels when declaring a bar mark.
public struct DotMark<DataSource>: Mark {
    var data: [DataSource]
    let x: QuantitativeVisualChannel<DataSource, Double>
    let y: QuantitativeVisualChannel<DataSource, Double>

    public func symbolsForMark(rangeLower _: CGFloat, rangeHigher _: CGFloat) -> [MarkSymbol] {
        // - apply the range onto the various VisualChannel scales, or pass it along when creating
        //   the symbols with final values. (from VisualChannel.provideScaledValue()
        []
    }

    public typealias MarkType = Self
    public init(data: [DataSource],
                x xChannel: QuantitativeVisualChannel<DataSource, Double>,
                y yChannel: QuantitativeVisualChannel<DataSource, Double>)
    {
        self.data = data
        x = xChannel
        y = yChannel
    }
}
