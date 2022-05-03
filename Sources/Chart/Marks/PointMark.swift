//
//  DotMark.swift
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
public struct PointMark<DataSource>: Mark {
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

    public func symbolsForMark(in rect: CGRect) -> [MarkSymbol] {
        let xScale = x.range(rangeLower: rect.origin.x, rangeHigher: rect.origin.x + rect.size.width)
        let yScale = y.range(rangeLower: rect.origin.y, rangeHigher: rect.origin.y + rect.size.height)
        var symbols: [MarkSymbol] = []
        print("Creating symbols within rect: \(rect)")
        print("X scale: \(xScale)")
        print("Y scale: \(yScale)")
        for pointData in data {
            if let xValue = xScale.scaledValue(data: pointData),
               let yValue = yScale.scaledValue(data: pointData)
            {
                let newPoint = IndividualPoint(x: xValue, y: yValue, shape: PlotShape(Circle()), size: 5)
                symbols.append(.point(newPoint))
                print(" .. \(newPoint)")
            }
        }
        return symbols
    }
}
