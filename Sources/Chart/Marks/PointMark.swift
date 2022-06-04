//
//  DotMark.swift
//

import CoreGraphics
import SwiftUI
import SwiftVizScale

/// A type that represents a series of bars.
///
/// The type infers the number and visual properties of the bars from the data you provide to the visual channels when declaring a bar mark.
public struct PointMark<DataSource>: Mark, MarkAxis {
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

    private var sizeChannel: QuantitativeVisualChannel<DataSource>

    public init(data: [DataSource],
                x xChannel: QuantitativeVisualChannel<DataSource>,
                y yChannel: QuantitativeVisualChannel<DataSource>)
    {
        self.data = data
        x = xChannel.applyDomain(data)
        y = yChannel.applyDomain(data)
        _xAxis = nil
        _yAxis = nil
        sizeChannel = QuantitativeVisualChannel<DataSource>(5)
    }

    /// Creates a list of symbols to render into a rectangular drawing area that you specify.
    /// - Parameter in: The rectangle into which to scale and draw the symbols.
    /// - Returns: A list of symbol data structures with the information needed to draw them onto a canvas or into CoreGraphics context.
    public func symbolsForMark(in rect: CGRect) -> [Sigil] {
        let xScale = x.range(rangeLower: rect.origin.x,
                             rangeHigher: rect.size.width + rect.origin.x)
        let yScale = y.range(reversed: true,
                             rangeLower: rect.origin.y,
                             rangeHigher: rect.size.height + rect.origin.y)
        var symbols: [Sigil] = []
        for pointData in data {
            if let xValue = xScale.scaledValue(data: pointData),
               let yValue = yScale.scaledValue(data: pointData)
            {
                let newPoint = IndividualPoint(
                    x: xValue,
                    y: yValue,
                    shape: PlotShape(Circle()),
                    size: sizeChannel.valueProvider(pointData)
                )
                symbols.append(.point(newPoint))
            }
        }
        return symbols
    }

    // MARK: - PointMark Modifier Methods

    public func size(_ constantValue: CGFloat) -> Self {
        var copyOfSelf = self
        copyOfSelf.sizeChannel = QuantitativeVisualChannel<DataSource>(constantValue)
        return copyOfSelf
    }

    public func size(_ channel: QuantitativeVisualChannel<DataSource>) -> Self {
        var copyOfSelf = self
        copyOfSelf.sizeChannel = channel
        return copyOfSelf
    }
}
