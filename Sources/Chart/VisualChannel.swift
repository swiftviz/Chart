//
//  VisualChannel.swift
//
//
//  Created by Joseph Heck on 3/25/22.
//

import Foundation
import SwiftVizScale

/// A type that can be encoded into the visual property of a mark.
public protocol TypeOfVisualProperty {
    var visualPropertyType: VisualPropertyType { get }
}

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

// public struct VisualPropertyInstance<UnderlyingType> {
//    let type: VisualPropertyType
//    let value: UnderlyingType
//
//    public init(_ type: VisualPropertyType, _ value: UnderlyingType) {
//        self.type = type
//        switch type {
//        case .quantitative:
//            self.value = value
//        case .ordinal:
//            self.value = value
//        case .temporal:
//            self.value = value
//        case .categorical:
//            self.value = value
//        }
//    }
// }

// MARK: - Visual Channel - Continuous/Quantitative

/// A value that indicates the how the visual channel provides its value.
public enum KindOfVisualChannel {
    /// The visual channel uses a constant value that you provide.
    case constant
    /// The visual channel uses a key path to reference a property on the objects that you provide.
    case reference
    /// The visual channel uses a closure that provides a value when provided with the associated data type.
    case map
}

/// A channel that provides a mapping from an object's property to a visual property.
public struct QuantitativeVisualChannel<
    SomeDataType,
    InputPropertyType: ConvertibleWithDouble & NiceValue & TypeOfVisualProperty & Comparable
        ,
    OutputPropertyType: ConvertibleWithDouble
> {
    typealias OutputPropertyType = CGFloat

    let visualChannelType: KindOfVisualChannel
    let constantValue: InputPropertyType?
    let dataProperty: KeyPath<SomeDataType, InputPropertyType>?
    let closure: ((SomeDataType) -> OutputPropertyType)?

    public var scale: AnyContinuousScale<InputPropertyType, OutputPropertyType>
    // a scale has an InputType and OutputType - and we need InputType to match 'PropertyType'
    // from above. And OutputType should probably just be CGFloat since we'll be using it in
    // that context.

    // Since the property types could be one of Double, Date, Int, or String - we need scales
    // that take all of those kinds of values as input types so that we can appropriately constrain
    // the generics.

    // The two "OutputTypes" that are relevant for our use cases are "CGFloat" for drawing stuff
    // in a GraphicsContext and Color - or some color representation anyway - that can be converted
    // or cast into to a SwiftUI color instance. Since we're doing CoreGraphics dependencies anyway,
    // then maybe CGColor.
    // https://github.com/swiftviz/SwiftViz/issues/11, partially noted earlier as improvement in
    // https://github.com/swiftviz/SwiftViz/issues/8 as well.

    // something like `VisualChannel<SomeDataType>(\.node)`
    public init(_ dataProperty: KeyPath<SomeDataType, InputPropertyType>) {
        typealias ScaleType = AnyContinuousScale<InputPropertyType, OutputPropertyType>
        self.dataProperty = dataProperty
        constantValue = nil
        closure = nil
        scale = AnyContinuousScale<InputPropertyType, OutputPropertyType>(LinearScale())
        visualChannelType = .reference
        // We need the at least the domain to create it - so we need to know the range of values
        // before we can instantiate a scale if it's not explicitly declared

        // It might be nice to have the specific scales Type Erased so that we can
        // store the scale reference as AnyScaleType<InputType, OutputType>: Scale
        // and have a super-optimized `.identity` type that does a 1:1 pass through
        // with no computation on the value.
    }

    // something like `VisualChannel(13.0)`
    public init(_ value: InputPropertyType) {
        constantValue = value
        dataProperty = nil
        closure = nil
        scale = AnyContinuousScale(LinearScale())
        visualChannelType = .constant
    }

    public init(_ closure: @escaping (SomeDataType) -> OutputPropertyType) {
        constantValue = nil
        dataProperty = nil
        self.closure = closure
        scale = AnyContinuousScale(LinearScale())
        visualChannelType = .map
    }

    public func provideScaledValue(d: SomeDataType, rangeLower: OutputPropertyType, rangeHigher: OutputPropertyType) -> OutputPropertyType? {
        switch visualChannelType {
        case .reference:
            guard let dataProperty = dataProperty else {
                preconditionFailure("reference link for the requested value is nil")
            }
            let valueFromData: InputPropertyType = d[keyPath: dataProperty]
            return scale.scale(valueFromData, from: rangeLower, to: rangeHigher)
        case .constant:
            guard let constantValue = constantValue else {
                preconditionFailure("constant value is nil")
            }
            return scale.scale(constantValue, from: rangeLower, to: rangeHigher)
        case .map:
            preconditionFailure("not yet implemented")
        }
    }

    public mutating func scale(_ kind: ContinuousScaleType) {
        scale = scale.scaleType(kind)
    }
}

// MARK: - Visual Channel - Discrete/Band

/// A channel that provides a mapping from an object's property to a visual property.
public struct BandVisualChannel<
    SomeDataType
> {
    let visualChannelType: KindOfVisualChannel
    let constantValue: String?
    let dataProperty: KeyPath<SomeDataType, String>?
    let closure: ((SomeDataType) -> String)?

    public var scale: BandScale<String, CGFloat>

    // something like `VisualChannel<SomeDataType>(\.node)`
    public init(_ dataProperty: KeyPath<SomeDataType, String>) {
        self.dataProperty = dataProperty
        constantValue = nil
        closure = nil
        scale = BandScale<String, CGFloat>()
        visualChannelType = .reference
    }

    // something like `BandVisualChannel("sixth")`
    public init(_ value: String) {
        constantValue = value
        dataProperty = nil
        closure = nil
        scale = BandScale<String, CGFloat>()
        visualChannelType = .constant
    }

    public init(_ closure: @escaping (SomeDataType) -> String) {
        constantValue = nil
        dataProperty = nil
        self.closure = closure
        scale = BandScale<String, CGFloat>()
        visualChannelType = .map
    }

    public func provideScaledValue(d: SomeDataType, rangeLower: CGFloat, rangeHigher: CGFloat) -> Band<String, CGFloat>? {
        switch visualChannelType {
        case .reference:
            guard let dataProperty = dataProperty else {
                preconditionFailure("reference link for the requested value is nil")
            }
            let valueFromData: String = d[keyPath: dataProperty]
            return scale.scale(valueFromData, from: rangeLower, to: rangeHigher)
        case .constant:
            guard let constantValue = constantValue else {
                preconditionFailure("constant value is nil")
            }
            return scale.scale(constantValue, from: rangeLower, to: rangeHigher)
        case .map:
            preconditionFailure("not yet implemented")
        }
    }
}

// MARK: - Visual Channel - Discrete/Point

/// A channel that provides a mapping from an object's property to a visual property.
public struct DiscreteVisualChannel<
    SomeDataType,
    InputPropertyType: ConvertibleWithDouble & NiceValue & TypeOfVisualProperty & Comparable,
    OutputPropertyType: ConvertibleWithDouble
> {
    typealias OutputPropertyType = CGFloat

    let visualChannelType: KindOfVisualChannel
    let constantValue: InputPropertyType?
    let dataProperty: KeyPath<SomeDataType, InputPropertyType>?
    let closure: ((SomeDataType) -> OutputPropertyType)?

    public var scale: PointScale<InputPropertyType, OutputPropertyType>

    // something like `VisualChannel<SomeDataType>(\.node)`
    public init(_ dataProperty: KeyPath<SomeDataType, InputPropertyType>) {
        typealias ScaleType = AnyContinuousScale<InputPropertyType, OutputPropertyType>
        self.dataProperty = dataProperty
        constantValue = nil
        closure = nil
        scale = PointScale<InputPropertyType, OutputPropertyType>()
        visualChannelType = .reference
        // We need the at least the domain to create it - so we need to know the range of values
        // before we can instantiate a scale if it's not explicitly declared

        // It might be nice to have the specific scales Type Erased so that we can
        // store the scale reference as AnyScaleType<InputType, OutputType>: Scale
        // and have a super-optimized `.identity` type that does a 1:1 pass through
        // with no computation on the value.
    }

    // something like `VisualChannel(13.0)`
    public init(_ value: InputPropertyType) {
        constantValue = value
        dataProperty = nil
        closure = nil
        scale = PointScale<InputPropertyType, OutputPropertyType>()
        visualChannelType = .constant
    }

    public init(_ closure: @escaping (SomeDataType) -> OutputPropertyType) {
        constantValue = nil
        dataProperty = nil
        self.closure = closure
        scale = PointScale<InputPropertyType, OutputPropertyType>()
        visualChannelType = .map
    }

    public func provideScaledValue(d: SomeDataType, rangeLower: OutputPropertyType, rangeHigher: OutputPropertyType) -> OutputPropertyType? {
        switch visualChannelType {
        case .reference:
            guard let dataProperty = dataProperty else {
                preconditionFailure("reference link for the requested value is nil")
            }
            let valueFromData: InputPropertyType = d[keyPath: dataProperty]
            return scale.scale(valueFromData, from: rangeLower, to: rangeHigher)
        case .constant:
            guard let constantValue = constantValue else {
                preconditionFailure("constant value is nil")
            }
            return scale.scale(constantValue, from: rangeLower, to: rangeHigher)
        case .map:
            preconditionFailure("not yet implemented")
        }
    }
}

// MARK: - Visual Channel - Discrete/Color

// MARK: - Visual Channel - Continuous/Color

// MARK: - Visual Channel - Discrete/Shape

// TBD: need channels to provide Color, and another to provide a Shape for symbols (DotMark)
