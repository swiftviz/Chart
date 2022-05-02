//
//  LineMark.swift
//
//
//  Created by Joseph Heck on 3/25/22.
//

import CoreGraphics
import SwiftUI
import SwiftVizScale

/// A type that represents a series of bars.
///
/// The type infers the number and visual properties of the bars from the data you provide to the visual channels when declaring a bar mark.
public struct LineMark<DataSource>: Mark {
    let data: [DataSource]
    let x: QuantitativeVisualChannel<DataSource, Double>
    let y: QuantitativeVisualChannel<DataSource, Double>

    public init(data: [DataSource],
                x xChannel: QuantitativeVisualChannel<DataSource, Double>,
                y yChannel: QuantitativeVisualChannel<DataSource, Double>)
    {
        self.data = data
        x = xChannel.applyDomain(data)
        y = yChannel.applyDomain(data)
    }

    public func symbolsForMark(in _: CGRect) -> [MarkSymbol] {
        // - apply the range onto the various VisualChannel scales, or pass it along when creating
        //   the symbols with final values. (from VisualChannel.provideScaledValue()
        []
    }
}
