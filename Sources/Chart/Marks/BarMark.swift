//
//  BarMark.swift
//

import SwiftUI
import SwiftVizScale

/// The orientation of the quantitative value for a bar chart.
public enum ChartOrientation {
    /// The bar represents value vertically on a chart.
    case vertical
    /// The bar represents value horizontally on a chart.
    case horizontal
    /// The bar represents value depth within a chart.
    case depth
}

/// A type that represents a series of bars.
///
/// The type infers the number and visual properties of the bars from the data you provide to the visual channels when declaring a bar mark.
public struct BarMark<DataSource>: Mark, MarkAxis {
    let data: [DataSource]
    let value: QuantitativeVisualChannel<DataSource>
    let category: BandVisualChannel<DataSource>
    let orientation: ChartOrientation

    public var _xAxis: Axis?
    public var _yAxis: Axis?

    public var xPropertyScale: VisualPropertyScale {
        switch orientation {
        case .vertical:
            return .band(category.scale)
        case .horizontal:
            return .continuous(value.scale)
        case .depth:
            fatalError("Not yet implemented")
        }
    }

    public var yPropertyScale: VisualPropertyScale {
        switch orientation {
        case .vertical:
            return .continuous(value.scale)
        case .horizontal:
            return .band(category.scale)
        case .depth:
            fatalError("Not yet implemented")
        }
    }

    public init(orientation: ChartOrientation = .vertical, data: [DataSource], value: QuantitativeVisualChannel<DataSource>, category: BandVisualChannel<DataSource>) {
        self.data = data
        self.value = value.applyDomain(data)
        self.category = category.applyDomain(data)
        self.orientation = orientation
        _xAxis = nil
        _yAxis = nil
    }

    /// Creates a list of symbols to render into a rectangular drawing area that you specify.
    /// - Parameter in: The rectangle into which to scale and draw the symbols.
    /// - Returns: A list of symbol data structures with the information needed to draw them onto a canvas or into CoreGraphics context.
    public func symbolsForMark(in rect: CGRect) -> [Sigil] {
        // - apply the range onto the various VisualChannel scales, or pass it along when creating
        //   the symbols with final values. (from VisualChannel.provideScaledValue()
        var symbols: [Sigil] = []

        switch orientation {
        case .vertical:
            let xScale = category.range(rangeLower: rect.origin.x, rangeHigher: rect.origin.x + rect.size.width)
            let yScale = value.range(reversed: true, rangeLower: rect.origin.y, rangeHigher: rect.origin.y + rect.size.height)

            for pointData in data {
                if let xBand = xScale.scaledValue(data: pointData),
                   let yValue = yScale.scaledValue(data: pointData)
                {
                    let symbolRect = CGRect(x: xBand.lower + rect.origin.x, y: yValue, width: xBand.higher - xBand.lower, height: rect.height - yValue)
                    let barSymbol = IndividualRect(rect: symbolRect, category: xBand.value)
                    symbols.append(.rect(barSymbol))
                }
            }

        case .horizontal:
            let xScale = value.range(rangeLower: rect.origin.x, rangeHigher: rect.origin.x + rect.size.width)
            let yScale = category.range(rangeLower: rect.origin.y, rangeHigher: rect.origin.y + rect.size.height)

            for pointData in data {
                if let xValue = xScale.scaledValue(data: pointData),
                   let yBand = yScale.scaledValue(data: pointData)
                {
                    let symbolRect = CGRect(x: rect.origin.x, y: rect.height - yBand.higher + rect.origin.y, width: xValue, height: yBand.higher - yBand.lower)
                    let barSymbol = IndividualRect(rect: symbolRect, category: yBand.value)
                    symbols.append(.rect(barSymbol))
                }
            }
        case .depth:
            fatalError("Not yet implemented")
        }

        return symbols
    }
}
