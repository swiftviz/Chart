//
//  LineMark.swift
//

import CoreGraphics
import SwiftUI
import SwiftVizScale

/// A type that represents a series of bars.
///
/// The type infers the number and visual properties of the bars from the data you provide to the visual channels when declaring a bar mark.
public struct LineMark<DataSource>: Mark, MarkAxis {
    let data: [DataSource]
    let x: QuantitativeVisualChannel<DataSource>
    let y: QuantitativeVisualChannel<DataSource>
    public var xPropertyScale: VisualPropertyScale {
        .continuous(x.scale)
    }

    public var yPropertyScale: VisualPropertyScale {
        .continuous(y.scale)
    }

    public var _xAxis: Axis?
    public var _yAxis: Axis?

    public init(data: [DataSource],
                x xChannel: QuantitativeVisualChannel<DataSource>,
                y yChannel: QuantitativeVisualChannel<DataSource>)
    {
        self.data = data
        x = xChannel.applyDomain(data)
        y = yChannel.applyDomain(data)
        _xAxis = nil
        _yAxis = nil
    }

    /// Creates a list of symbols to render into a rectangular drawing area that you specify.
    /// - Parameter in: The rectangle into which to scale and draw the symbols.
    /// - Returns: A list of symbol data structures with the information needed to draw them onto a canvas or into CoreGraphics context.
    public func symbolsForMark(in rect: CGRect) -> [Sigil] {
        // - apply the range onto the various VisualChannel scales, or pass it along when creating
        //   the symbols with final values. (from VisualChannel.provideScaledValue()
        let xScale = x.range(rangeLower: rect.origin.x,
                             rangeHigher: rect.origin.x + rect.size.width)
        let yScale = y.range(reversed: true,
                             rangeLower: rect.origin.y,
                             rangeHigher: rect.origin.y + rect.size.height)
        var symbols: [Sigil] = []

        var previousData: DataSource?
        for pointData in data {
            if let xValue = xScale.scaledValue(data: pointData),
               let yValue = yScale.scaledValue(data: pointData)
            {
                let newPoint = IndividualPoint(
                    x: xValue,
                    y: yValue,
                    shape: PlotShape(Circle()), size: 5
                )
                symbols.append(.point(newPoint))
                // There won't be a line for the first point, but all following points
                // include a line from the current point back to the previous point.
                if let previousData = previousData,
                   let x2Value = xScale.scaledValue(data: previousData),
                   let y2Value = yScale.scaledValue(data: previousData)
                {
                    let lineBack = IndividualLine(
                        x1: xValue,
                        y1: yValue,
                        x2: x2Value,
                        y2: y2Value,
                        size: 1
                    )
                    symbols.append(.line(lineBack))
                }
            }
            previousData = pointData
        }
        return symbols
    }
}
