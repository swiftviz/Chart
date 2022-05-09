//
//  BarMark.swift
//
//
//  Created by Joseph Heck on 3/25/22.
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
public struct BarMark<DataSource>: Mark {
    let data: [DataSource]
    let value: QuantitativeVisualChannel<DataSource>
    let category: BandVisualChannel<DataSource>
    let orientation: ChartOrientation

    public init(orientation: ChartOrientation = .vertical, data: [DataSource], value: QuantitativeVisualChannel<DataSource>, category: BandVisualChannel<DataSource>) {
        self.data = data
        self.value = value.applyDomain(data)
        self.category = category.applyDomain(data)
        self.orientation = orientation
    }

    /// Creates a list of symbols to render into a rectangular drawing area that you specify.
    /// - Parameter in: The rectangle into which to scale and draw the symbols.
    /// - Returns: A list of symbol data structures with the information needed to draw them onto a canvas or into CoreGraphics context.
    public func symbolsForMark(in rect: CGRect) -> [MarkSymbol] {
        // - apply the range onto the various VisualChannel scales, or pass it along when creating
        //   the symbols with final values. (from VisualChannel.provideScaledValue()
        var symbols: [MarkSymbol] = []
        print("Creating symbols within rect: \(rect)")
        switch orientation {
        case .vertical:
            let xScale = category.range(rangeLower: rect.origin.x, rangeHigher: rect.origin.x + rect.size.width)
            let yScale = value.range(rangeLower: rect.origin.y, rangeHigher: rect.origin.y + rect.size.height)
            print("X scale: \(xScale)")
            print("Y scale: \(yScale)")
            for pointData in data {
                if let xBand = xScale.scaledValue(data: pointData),
                   let yValue = yScale.scaledValue(data: pointData)
                {
                    let symbolRect = CGRect(x: xBand.lower + rect.origin.x, y: rect.height - yValue + rect.origin.y, width: xBand.higher - xBand.lower, height: yValue)
                    let barSymbol = IndividualRect(rect: symbolRect, category: xBand.value)
                    symbols.append(.rect(barSymbol))
                    print(" .. \(barSymbol)")
                }
            }

        case .horizontal:
            let xScale = value.range(rangeLower: rect.origin.x, rangeHigher: rect.origin.x + rect.size.width)
            let yScale = category.range(rangeLower: rect.origin.y, rangeHigher: rect.origin.y + rect.size.height)
            print("X scale: \(xScale)")
            print("Y scale: \(yScale)")
            for pointData in data {
                if let xValue = xScale.scaledValue(data: pointData),
                   let yBand = yScale.scaledValue(data: pointData)
                {
                    let symbolRect = CGRect(x: rect.origin.x, y: rect.height - yBand.higher + rect.origin.y, width: xValue, height: yBand.higher - yBand.lower)
                    let barSymbol = IndividualRect(rect: symbolRect, category: yBand.value)
                    symbols.append(.rect(barSymbol))
                    print(" .. \(barSymbol)")
                }
            }
        case .depth:
            fatalError("Not yet implemented")
        }

        return symbols
    }
}
