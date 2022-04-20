//
//  VisualProperties.swift
//
//
//  Created by Joseph Heck on 3/25/22.
//

import Foundation

/// A type that can be encoded into the visual property of a mark.
public protocol TypeOfVisualProperty {
    /// The kind of visual property this property maps into by default.
    var visualPropertyType: VisualPropertyType { get }
}

/// A type that represents a kind of visual property.
///
/// The types include the following continuous types:
/// - `quantitative`, typically represented by `Double`
/// - `temporal`, typically represented by `Date`
///
/// And discrete types:
/// - `ordinal`, typically represented by `Int`
/// - `categorical`, typically represented by `String`
public enum VisualPropertyType {
    case quantitative // (Double)
    case ordinal // (Int)
    case temporal // (Date)
    case categorical // (String)
}

// MARK: - protocol conformance on types that can represent Visual Properties

// visual property type of 'Quantitative' accepts value types of 'Double'
// visual property type of 'Ordinal' accepts value types of 'Int'
// visual property type of 'Categorical' accepts value types of 'String'
// visual property type of 'Temporal' accepts value types of 'Date'

extension Double: TypeOfVisualProperty {
    public var visualPropertyType: VisualPropertyType {
        .quantitative
    }
}

extension Int: TypeOfVisualProperty {
    public var visualPropertyType: VisualPropertyType {
        .ordinal
    }
}

extension String: TypeOfVisualProperty {
    public var visualPropertyType: VisualPropertyType {
        .categorical
    }
}

extension Date: TypeOfVisualProperty {
    public var visualPropertyType: VisualPropertyType {
        .temporal
    }
}
