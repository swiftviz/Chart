//
//  VisualProperties.swift
//

import Foundation
import SwiftVizScale
#if canImport(CoreGraphics)
    // enables referencing CGFloat for iOS
    import CoreGraphics
#endif

/// A type that represents the scale associated with a visual property.
public enum VisualPropertyScale {
    /// A continuous scale.
    case continuous(AnyContinuousScale<Double, CGFloat>)
    /// A discrete scale that returns a band as an output value.
    case band(BandScale<String, CGFloat>)
    /// A discrete scale that returns a point as an output value.
    case point(PointScale<String, CGFloat>)
    //    case ordinal // (Int) - n/a yet
    //    case temporal // (Date) - n/a yet

    // seems like we want another method here to just get the values of the tick labels
    func tickLabels(values: [Double] = []) -> [String] {
        switch self {
        case let .continuous(anyContinuousScale):
            if values.isEmpty {
                return anyContinuousScale.defaultTickValues()
            } else {
                return anyContinuousScale.validTickValues(values)
            }
        case let .band(bandScale):
            return bandScale.defaultTickValues()
        case let .point(pointScale):
            return pointScale.defaultTickValues()
        }
    }

    func tickValuesFromScale(lower: CGFloat, higher: CGFloat, values: [Double] = []) -> [Tick<CGFloat>] {
        switch self {
        case let .continuous(scale):
            if values.isEmpty {
                return scale.ticks(rangeLower: lower, rangeHigher: higher)
            } else {
                return scale.ticksFromValues(values, from: lower, to: higher)
            }
        case let .band(scale):
            return scale.ticks(rangeLower: lower, rangeHigher: higher)
        case let .point(scale):
            return scale.ticks(rangeLower: lower, rangeHigher: higher)
        }
    }
}
