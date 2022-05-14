//
//  VisualProperties.swift
//
//
//  Created by Joseph Heck on 3/25/22.
//

import Foundation
import SwiftVizScale
#if canImport(CoreGraphics)
    // enables referencing CGFloat for iOS
    import CoreGraphics
#endif
/// A type that can be encoded into the visual property of a mark.
// public protocol TypeOfVisualProperty {
//    /// The kind of visual property this property maps into by default.
//    var visualPropertyType: VisualPropertyType { get }
// }

/// A type that represents a kind of visual property.
///
/// The types include the following continuous types:
/// - `quantitative`, typically represented by `Double`
/// - `temporal`, typically represented by `Date`
///
/// And discrete types:
/// - `ordinal`, typically represented by `Int`
/// - `categorical`, typically represented by `String`
// public enum VisualPropertyType {
//    case quantitative // (Double)
//    case ordinal // (Int)
//    case temporal // (Date)
//    case categorical // (String)
// }

/// A type that represents the scale associated with a visual property.
public enum VisualPropertyScale {
    case continuous(AnyContinuousScale<Double, CGFloat>) // continuous
    case band(BandScale<String, CGFloat>) // discrete
    case point(PointScale<String, CGFloat>) // discrete

    // seems like we want another method here to just get the values of the tick labels
    func tickLabels(values _: [Double] = []) -> [String] {
        []
    }

    func tickValuesFromScale(lower: CGFloat, higher: CGFloat, values: [Double] = []) -> [Tick<CGFloat>] {
        switch self {
        case let .continuous(scale):
            if values.isEmpty {
                return scale.ticks(rangeLower: lower, rangeHigher: higher)
            } else {
                return scale.tickValues(values, from: lower, to: higher)
            }
        case let .band(scale):
            return scale.ticks(rangeLower: lower, rangeHigher: higher)
        case let .point(scale):
            return scale.ticks(rangeLower: lower, rangeHigher: higher)
        }
    }
}

//    case ordinal // (Int) - n/a yet
//    case temporal // (Date) - n/a yet

// MARK: - protocol conformance on types that can represent Visual Properties

// visual property type of 'Quantitative' accepts value types of 'Double'
// visual property type of 'Ordinal' accepts value types of 'Int'
// visual property type of 'Categorical' accepts value types of 'String'
// visual property type of 'Temporal' accepts value types of 'Date'

// extension Double: TypeOfVisualProperty {
//    public var visualPropertyType: VisualPropertyType {
//        .quantitative
//    }
// }
//
// extension Int: TypeOfVisualProperty {
//    public var visualPropertyType: VisualPropertyType {
//        .ordinal
//    }
// }
//
// extension String: TypeOfVisualProperty {
//    public var visualPropertyType: VisualPropertyType {
//        .categorical
//    }
// }
//
// extension Date: TypeOfVisualProperty {
//    public var visualPropertyType: VisualPropertyType {
//        .temporal
//    }
// }
