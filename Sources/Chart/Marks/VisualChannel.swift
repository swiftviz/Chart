//
//  VisualChannel.swift
//
//
//  Created by Joseph Heck on 3/25/22.
//

import CoreGraphics
import Foundation
import SwiftVizScale

// MARK: - Visual Channel - Continuous/Quantitative

/// A value that indicates the how the visual channel provides its value.
internal enum KindOfVisualChannel {
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
    InputPropertyType: ConvertibleWithDouble & NiceValue & Comparable
> {
    /// The type that is presented after scaling or transforming the value referenced by the channel.
    public typealias OutputPropertyType = CGFloat

//    public typealias InputPropertyType =
    /// The reference mechanism used to provide the value for the channel.
    private let visualChannelType: KindOfVisualChannel
    private let constantValue: InputPropertyType?
    private let dataProperty: KeyPath<SomeDataType, InputPropertyType>?
    private let closure: ((SomeDataType) -> InputPropertyType)?

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

    /// Creates a new visual channel that references a property using the key-path you provide.
    /// - Parameter dataProperty: the key-path to the property to use for the visual channel.
    ///
    /// example: `VisualChannel<SomeDataType>(\.node)`
    public init(_ dataProperty: KeyPath<SomeDataType, InputPropertyType>) {
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

    /// Creates a new visual channel that returns a constant value that you provide.
    /// - Parameter value: The constant value to use for the visual channel.
    ///
    /// example: `VisualChannel(13.0)`
    public init(_ value: InputPropertyType) {
        constantValue = value
        dataProperty = nil
        closure = nil
        scale = AnyContinuousScale(LinearScale().domain([value]))
        visualChannelType = .constant
    }

    /// Creates a new visual channel that returns a value using the closure that you provide.
    /// - Parameter closure: A closure that accepts the data provided to the visual channel and returns a value to use for the visual channel.
    public init(_ closure: @escaping (SomeDataType) -> InputPropertyType) {
        constantValue = nil
        dataProperty = nil
        self.closure = closure
        scale = AnyContinuousScale(LinearScale())
        visualChannelType = .map
    }

    /// Returns a new visual channel with the domain for its scale set using the series of values provided to the channel.
    /// - Parameter values: The list of values to use to infer a domain.
    public func applyDomain(_ values: [SomeDataType]) -> Self {
        switch visualChannelType {
        case .constant:
            return self
        case .reference:
            guard let path = dataProperty else {
                preconditionFailure("Attempted to apply domain for a reference channel with a null key path.")
            }
            let listOfValues = values.map { data in
                data[keyPath: path]
            }
            var copyOfSelf = self
            copyOfSelf.scale = scale.domain(listOfValues, nice: true)
            return copyOfSelf
        case .map:
            guard let closure = closure else {
                preconditionFailure("Attempted to apply domain for a map channel with a null closure.")
            }
            let listOfValues = values.map { closure($0) }
            var copyOfSelf = self
            copyOfSelf.scale = scale.domain(listOfValues, nice: true)
            return copyOfSelf
        }
    }

    /// Returns a new visual channel with the range for its scale set using the values you provide.
    /// - Parameters:
    ///   - rangeLower: The lower value for the range.
    ///   - rangeHigher: The higher value for the range.
    public func range(rangeLower: OutputPropertyType, rangeHigher: OutputPropertyType) -> Self {
        var copyOfSelf = self
        copyOfSelf.scale = scale.range(lower: rangeLower, higher: rangeHigher)
        return copyOfSelf
    }

    /// Returns the value referenced from the data you provide by the channel, scaled into the range previously set on the channel.
    /// - Parameters:
    ///   - data: The instance of the data to process through the visual channel.
    /// - Returns: The scaled value, or `nil` if the scaled value is not-a-number, or the scale is set to drop values scaled outside of the range defined.
    ///
    /// Set the range for the visual channel's scale using ``range(rangeLower:rangeHigher:)`` before using this method to retrieve a scaled value.
    public func scaledValue(data: SomeDataType) -> OutputPropertyType? {
        precondition(scale.rangeLower != nil && scale.rangeHigher != nil, "Unable to scale values to an unset range.")
        switch visualChannelType {
        case .reference:
            guard let dataProperty = dataProperty else {
                preconditionFailure("reference link for the requested value is nil")
            }
            let valueFromData: InputPropertyType = data[keyPath: dataProperty]
            return scale.scale(valueFromData)
        case .constant:
            guard let constantValue = constantValue else {
                preconditionFailure("constant value is nil")
            }
            return scale.scale(constantValue)
        case .map:
            preconditionFailure("not yet implemented")
        }
    }

    /// Returns the value referenced from the data you provide by the channel, scaled into the range defined by the range values you provide.
    /// - Parameters:
    ///   - data: The instance of the data to process through the visual channel.
    ///   - rangeLower: The lower value for the range.
    ///   - rangeHigher: The higher value for the range.
    /// - Returns: The scaled value, or `nil` if the scaled value is not-a-number, or the scale is set to drop values scaled outside of the range defined.
    ///
    /// This method is useful for a single lookup of a value, but for processing more than a handful of values it is more efficient to update the visual channel
    /// using ``range(rangeLower:rangeHigher:)``, then call ``scaledValue(data:)`` iteratively on the updated channel.
    public func scaledValue(data: SomeDataType, rangeLower: OutputPropertyType, rangeHigher: OutputPropertyType) -> OutputPropertyType? {
        switch visualChannelType {
        case .reference:
            guard let dataProperty = dataProperty else {
                preconditionFailure("reference link for the requested value is nil")
            }
            let valueFromData: InputPropertyType = data[keyPath: dataProperty]
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

    // MARK: - VisualChannel Modifier Methods

    public func scale(_ kind: ContinuousScaleType) -> Self {
        var copyOfSelf = self
        copyOfSelf.scale = scale.scaleType(kind)
        return copyOfSelf
    }
}

// MARK: - Visual Channel - Discrete/Band

/// A channel that provides a mapping from an object's property to a visual property.
public struct BandVisualChannel<SomeDataType> {
    private let visualChannelType: KindOfVisualChannel
    private let constantValue: String?
    private let dataProperty: KeyPath<SomeDataType, String>?
    private let closure: ((SomeDataType) -> String)?

    public var scale: BandScale<String, CGFloat>

    /// Creates a new visual channel that references a property using the key-path you provide.
    /// - Parameter dataProperty: the key-path to the property to use for the visual channel.
    ///
    /// example: `VisualChannel<SomeDataType>(\.node)`
    public init(_ dataProperty: KeyPath<SomeDataType, String>) {
        self.dataProperty = dataProperty
        constantValue = nil
        closure = nil
        scale = BandScale<String, CGFloat>()
        visualChannelType = .reference
    }

    /// Creates a new visual channel that returns a constant value that you provide.
    /// - Parameter value: The constant value to use for the visual channel.
    ///
    /// example: `BandVisualChannel("sixth")`
    public init(_ value: String) {
        constantValue = value
        dataProperty = nil
        closure = nil
        scale = BandScale<String, CGFloat>()
        visualChannelType = .constant
    }

    /// Creates a new visual channel that returns a value using the closure that you provide.
    /// - Parameter closure: A closure that accepts the data provided to the visual channel and returns a value to use for the visual channel.
    public init(_ closure: @escaping (SomeDataType) -> String) {
        constantValue = nil
        dataProperty = nil
        self.closure = closure
        scale = BandScale<String, CGFloat>()
        visualChannelType = .map
    }

    /// Returns a new visual channel with the domain for its scale set using the series of values provided to the channel.
    /// - Parameter values: The list of values to use to infer a domain.
    public func applyDomain(_ values: [SomeDataType]) -> Self {
        switch visualChannelType {
        case .constant:
            return self
        case .reference:
            guard let path = dataProperty else {
                preconditionFailure("Attempted to apply domain for a reference channel with a null key path.")
            }
            let listOfValues = values.map { data in
                data[keyPath: path]
            }
            var copyOfSelf = self
            copyOfSelf.scale = scale.domain(listOfValues)
            return copyOfSelf
        case .map:
            guard let closure = closure else {
                preconditionFailure("Attempted to apply domain for a map channel with a null closure.")
            }
            let listOfValues = values.map { closure($0) }
            var copyOfSelf = self
            copyOfSelf.scale = scale.domain(listOfValues)
            return copyOfSelf
        }
    }

    /// Returns a new visual channel with the range for its scale set using the values you provide.
    /// - Parameters:
    ///   - rangeLower: The lower value for the range.
    ///   - rangeHigher: The higher value for the range.
    public func range(rangeLower: CGFloat, rangeHigher: CGFloat) -> Self {
        var copyOfSelf = self
        copyOfSelf.scale = scale.range(lower: rangeLower, higher: rangeHigher)
        return copyOfSelf
    }

    /// Returns the value referenced from the data you provide by the channel, scaled into the range previously set on the channel.
    /// - Parameters:
    ///   - data: The instance of the data to process through the visual channel.
    /// - Returns: The scaled value, or `nil` if the scaled value is not-a-number, or the scale is set to drop values scaled outside of the range defined.
    ///
    /// Set the range for the visual channel's scale using ``range(rangeLower:rangeHigher:)`` before using this method to retrieve a scaled value.
    public func scaledValue(data: SomeDataType) -> Band<String, CGFloat>? {
        precondition(scale.rangeLower != nil && scale.rangeHigher != nil, "Unable to scale values to an unset range.")
        switch visualChannelType {
        case .reference:
            guard let dataProperty = dataProperty else {
                preconditionFailure("reference link for the requested value is nil")
            }
            let valueFromData: String = data[keyPath: dataProperty]
            return scale.scale(valueFromData)
        case .constant:
            guard let constantValue = constantValue else {
                preconditionFailure("constant value is nil")
            }
            return scale.scale(constantValue)
        case .map:
            preconditionFailure("not yet implemented")
        }
    }

    /// Returns the value referenced from the data you provide by the channel, scaled into the range defined by the range values you provide.
    /// - Parameters:
    ///   - data: The instance of the data to process through the visual channel.
    ///   - rangeLower: The lower value for the range.
    ///   - rangeHigher: The higher value for the range.
    /// - Returns: The scaled value, or `nil` if the scaled value is not-a-number, or the scale is set to drop values scaled outside of the range defined.
    ///
    /// This method is useful for a single lookup of a value, but for processing more than a handful of values it is more efficient to update the visual channel
    /// using ``range(rangeLower:rangeHigher:)``, then call ``scaledValue(data:)`` iteratively on the updated channel.
    public func scaledValue(data: SomeDataType, rangeLower: CGFloat, rangeHigher: CGFloat) -> Band<String, CGFloat>? {
        switch visualChannelType {
        case .reference:
            guard let dataProperty = dataProperty else {
                preconditionFailure("reference link for the requested value is nil")
            }
            let valueFromData: String = data[keyPath: dataProperty]
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
    InputPropertyType: ConvertibleWithDouble & NiceValue & TypeOfVisualProperty & Comparable
> {
    /// The type that is presented after scaling or transforming the value referenced by the channel.
    public typealias OutputPropertyType = CGFloat

    private let visualChannelType: KindOfVisualChannel
    private let constantValue: InputPropertyType?
    private let dataProperty: KeyPath<SomeDataType, InputPropertyType>?
    private let closure: ((SomeDataType) -> InputPropertyType)?

    public var scale: PointScale<InputPropertyType, OutputPropertyType>

    /// Creates a new visual channel that references a property using the key-path you provide.
    /// - Parameter dataProperty: the key-path to the property to use for the visual channel.
    ///
    /// example: `VisualChannel<SomeDataType>(\.node)`
    public init(_ dataProperty: KeyPath<SomeDataType, InputPropertyType>) {
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

    /// Creates a new visual channel that returns a constant value that you provide.
    /// - Parameter value: The constant value to use for the visual channel.
    ///
    /// example: `BandVisualChannel("sixth")`
    public init(_ value: InputPropertyType) {
        constantValue = value
        dataProperty = nil
        closure = nil
        scale = PointScale<InputPropertyType, OutputPropertyType>()
        visualChannelType = .constant
    }

    /// Creates a new visual channel that returns a value using the closure that you provide.
    /// - Parameter closure: A closure that accepts the data provided to the visual channel and returns a value to use for the visual channel.
    public init(_ closure: @escaping (SomeDataType) -> InputPropertyType) {
        constantValue = nil
        dataProperty = nil
        self.closure = closure
        scale = PointScale<InputPropertyType, OutputPropertyType>()
        visualChannelType = .map
    }

    /// Returns a new visual channel with the domain for its scale set using the series of values provided to the channel.
    /// - Parameter values: The list of values to use to infer a domain.
    public func applyDomain(_ values: [SomeDataType]) -> Self {
        switch visualChannelType {
        case .constant:
            return self
        case .reference:
            guard let path = dataProperty else {
                preconditionFailure("Attempted to apply domain for a reference channel with a null key path.")
            }
            let listOfValues = values.map { data in
                data[keyPath: path]
            }
            var copyOfSelf = self
            copyOfSelf.scale = scale.domain(listOfValues)
            return copyOfSelf
        case .map:
            guard let closure = closure else {
                preconditionFailure("Attempted to apply domain for a map channel with a null closure.")
            }
            let listOfValues = values.map { closure($0) }
            var copyOfSelf = self
            copyOfSelf.scale = scale.domain(listOfValues)
            return copyOfSelf
        }
    }

    /// Returns a new visual channel with the range for its scale set using the values you provide.
    /// - Parameters:
    ///   - rangeLower: The lower value for the range.
    ///   - rangeHigher: The higher value for the range.
    public func range(rangeLower: OutputPropertyType, rangeHigher: OutputPropertyType) -> Self {
        var copyOfSelf = self
        copyOfSelf.scale = scale.range(lower: rangeLower, higher: rangeHigher)
        return copyOfSelf
    }

    /// Returns the value referenced from the data you provide by the channel, scaled into the range previously set on the channel.
    /// - Parameters:
    ///   - data: The instance of the data to process through the visual channel.
    /// - Returns: The scaled value, or `nil` if the scaled value is not-a-number, or the scale is set to drop values scaled outside of the range defined.
    ///
    /// Set the range for the visual channel's scale using ``range(rangeLower:rangeHigher:)`` before using this method to retrieve a scaled value.
    public func scaledValue(data: SomeDataType) -> OutputPropertyType? {
        precondition(scale.rangeLower != nil && scale.rangeHigher != nil, "Unable to scale values to an unset range.")
        switch visualChannelType {
        case .reference:
            guard let dataProperty = dataProperty else {
                preconditionFailure("reference link for the requested value is nil")
            }
            let valueFromData: InputPropertyType = data[keyPath: dataProperty]
            return scale.scale(valueFromData)
        case .constant:
            guard let constantValue = constantValue else {
                preconditionFailure("constant value is nil")
            }
            return scale.scale(constantValue)
        case .map:
            preconditionFailure("not yet implemented")
        }
    }

    /// Returns the value referenced from the data you provide by the channel, scaled into the range defined by the range values you provide.
    /// - Parameters:
    ///   - data: The instance of the data to process through the visual channel.
    ///   - rangeLower: The lower value for the range.
    ///   - rangeHigher: The higher value for the range.
    /// - Returns: The scaled value, or `nil` if the scaled value is not-a-number, or the scale is set to drop values scaled outside of the range defined.
    ///
    /// This method is useful for a single lookup of a value, but for processing more than a handful of values it is more efficient to update the visual channel
    /// using ``range(rangeLower:rangeHigher:)``, then call ``scaledValue(data:)`` iteratively on the updated channel.
    public func scaledValue(data: SomeDataType, rangeLower: OutputPropertyType, rangeHigher: OutputPropertyType) -> OutputPropertyType? {
        switch visualChannelType {
        case .reference:
            guard let dataProperty = dataProperty else {
                preconditionFailure("reference link for the requested value is nil")
            }
            let valueFromData: InputPropertyType = data[keyPath: dataProperty]
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
