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

// MARK: - Visual Channel

/// A channel that provides a mapping from an object's property to a visual property.
public struct VisualChannel<
    SomeDataType,
    InputPropertyType: ConvertibleWithDouble & NiceValue & TypeOfVisualProperty,
    OutputPropertyType: ConvertibleWithDouble,
    ScaleType: Scale
> where ScaleType.InputType == InputPropertyType, ScaleType.OutputType == OutputPropertyType {
//    associatedtype SomeDataType: Any // type that holds the values we'll map from
//    associatedtype InputValueType: Any // scale input type
//    associatedtype OutputValueType: TypeOfVisualProperty // constrains to Double, Int, String, and Date
//    associatedtype ScaleType: Scale where ScaleType.OutputType == OutputValueType, ScaleType.InputType == InputValueType
    let visualChannelType: KindOfVisualChannel
    let constantValue: InputPropertyType?

    public enum KindOfVisualChannel {
        case constant // constant value
        case reference // keypath reference to incoming data
        case map // closure that provides a value when provided the incoming data type
    }

    let dataProperty: KeyPath<SomeDataType, InputPropertyType>?

    public var scale: AnyContinuousScale<InputPropertyType, OutputPropertyType> // input=Double, output=Float
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
        self.dataProperty = dataProperty
        constantValue = nil
        scale = AnyContinuousScale(LinearScale())
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
        scale = AnyContinuousScale(LinearScale())
        visualChannelType = .constant
    }

    public func provideScaledValue(d: SomeDataType) -> OutputPropertyType? {
        switch visualChannelType {
        case .reference:
            guard let dataProperty = dataProperty else {
                preconditionFailure("reference link for the requested value is nil")
            }
            let valueFromData: InputPropertyType = d[keyPath: dataProperty]
            return scale.scale(valueFromData, from: 0, to: 1)
        case .constant:
            guard let constantValue = constantValue else {
                preconditionFailure("constant value is nil")
            }
            return scale.scale(constantValue, from: 0, to: 1)
        case .map:
            preconditionFailure("not yet implemented")
        }
    }
}

extension VisualChannel where ScaleType == AnyContinuousScale<InputPropertyType, OutputPropertyType> {
    func scale<NewScaleType: Scale>(newScale _: NewScaleType) {}
}
