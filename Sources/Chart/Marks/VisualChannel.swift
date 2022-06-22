//
//  VisualChannel.swift
//

import CoreGraphics
import Foundation
import SwiftVizScale

// MARK: - Visual Channel - Continuous/Quantitative

/// A channel that provides a mapping from an object's property to a visual property.
///
/// This visual channel converts the value you provide into the type Double, and returns a final
/// value as `CGFloat` scaled to the range you provide.
public struct QuantitativeVisualChannel<SomeDataType> {
    /// The type that is presented after scaling or transforming the value referenced by the channel.
    public typealias OutputPropertyType = CGFloat

    internal let valueProvider: (SomeDataType) -> Double
    // The `valueProvider` captures the specifics of the type being provided within its closure
    // so the overall VisualChannel doesn't need to expose that detail as an additional generic
    // type. This lets us initialize the visual channel with a keypath, constant, or a closure
    // that ultimately converts to a Double type, which this channel uses internally to then
    // scale and apply to the range later provided.

    var scale = ContinuousScale<Double, OutputPropertyType>()
    // a scale has an InputType and OutputType - and we need InputType to match 'PropertyType'
    // from above. And OutputType should probably just be CGFloat since we'll be using it in
    // that context.

    /// Creates a new visual channel that references a property using the key-path you provide.
    /// - Parameter dataProperty: the key-path to the property to use for the visual channel.
    ///
    /// example: `VisualChannel<SomeDataType>(\.node)`
    public init<T: ConvertibleWithDouble>(_ dataProperty: KeyPath<SomeDataType, T>) {
        valueProvider = { dataSource in
            dataSource[keyPath: dataProperty].toDouble()
        }
    }

    /// Creates a new visual channel that returns a constant value that you provide.
    /// - Parameter value: The constant value to use for the visual channel.
    ///
    /// example: `VisualChannel(13.0)`
    public init<T: ConvertibleWithDouble>(_ value: T) {
        valueProvider = { _ in
            value.toDouble()
        }
    }

    /// Creates a new visual channel that returns a value using the closure that you provide.
    /// - Parameter closure: A closure that accepts the data provided to the visual channel and returns a value to use for the visual channel.
    public init<T: ConvertibleWithDouble>(_ closure: @escaping (SomeDataType) -> T) {
        valueProvider = { dataSource in
            closure(dataSource).toDouble()
        }
    }

    /// Returns a new visual channel with the domain for its scale set using the series of values provided to the channel.
    /// - Parameter values: The list of values to use to infer a domain.
    public func applyDomain(_ values: [SomeDataType]) -> Self {
        let listOfValues = values.map(valueProvider)
        var copyOfSelf = self
        copyOfSelf.scale = scale.domain(listOfValues, nice: true)
        return copyOfSelf
    }

    /// Returns a new visual channel with the range for its scale set using the values you provide.
    /// - Parameters:
    ///   - rangeLower: The lower value for the range.
    ///   - rangeHigher: The higher value for the range.
    public func range(reversed: Bool = false, rangeLower: OutputPropertyType, rangeHigher: OutputPropertyType) -> Self {
        var copyOfSelf = self
        copyOfSelf.scale = scale.range(reversed: reversed, lower: rangeLower, higher: rangeHigher)
        return copyOfSelf
    }

    /// Returns the value referenced from the data you provide by the channel, scaled into the range previously set on the channel.
    /// - Parameters:
    ///   - data: The instance of the data to process through the visual channel.
    /// - Returns: The scaled value, or `nil` if the scaled value is not-a-number, or the scale is set to drop values scaled outside of the range defined.
    ///
    /// Set the range for the visual channel's scale using ``range(rangeLower:rangeHigher:)`` before using this method to retrieve a scaled value.
    public func scaledValue(data: SomeDataType) -> OutputPropertyType? {
        scale.scale(valueProvider(data))
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
///
/// This visual channel converts the value you provide into the type String to represent a category,
/// and returns a final value as a `Band` with values scaled to the range you provide.
public struct BandVisualChannel<SomeDataType> {
    private let valueProvider: (SomeDataType) -> String

    var scale = BandScale<String, CGFloat>()

    /// Creates a new visual channel that references a property using the key-path you provide.
    /// - Parameter dataProperty: the key-path to the property to use for the visual channel.
    ///
    /// example: `VisualChannel<SomeDataType>(\.node)`
    public init(_ dataProperty: KeyPath<SomeDataType, String>) {
        valueProvider = { dataSource in
            dataSource[keyPath: dataProperty]
        }
    }

    /// Creates a new visual channel that returns a constant value that you provide.
    /// - Parameter value: The constant value to use for the visual channel.
    ///
    /// example: `BandVisualChannel("sixth")`
    public init(_ value: String) {
        valueProvider = { _ in
            value
        }
    }

    /// Creates a new visual channel that returns a value using the closure that you provide.
    /// - Parameter closure: A closure that accepts the data provided to the visual channel and returns a value to use for the visual channel.
    public init(_ closure: @escaping (SomeDataType) -> String) {
        valueProvider = { dataSource in
            closure(dataSource)
        }
    }

    /// Returns a new visual channel with the domain for its scale set using the series of values provided to the channel.
    /// - Parameter values: The list of values to use to infer a domain.
    public func applyDomain(_ values: [SomeDataType]) -> Self {
        let listOfValues = values.map { valueProvider($0) }
        var copyOfSelf = self
        copyOfSelf.scale = scale.domain(listOfValues)
        return copyOfSelf
    }

    /// Returns a new visual channel with the range for its scale set using the values you provide.
    /// - Parameters:
    ///   - rangeLower: The lower value for the range.
    ///   - rangeHigher: The higher value for the range.
    public func range(reversed: Bool = false, rangeLower: CGFloat, rangeHigher: CGFloat) -> Self {
        var copyOfSelf = self
        copyOfSelf.scale = scale.range(reversed: reversed, lower: rangeLower, higher: rangeHigher)
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
        return scale.scale(valueProvider(data))
    }
}

// MARK: - Visual Channel - Discrete/Point

/// A channel that provides a mapping from an object's property to a visual property.
///
/// This visual channel converts the value you provide into the type String to represent a category,
/// and returns a final value as `CGFloat` scaled to the range you provide.
public struct DiscreteVisualChannel<SomeDataType> {
    /// The type that is presented after scaling or transforming the value referenced by the channel.
    public typealias OutputPropertyType = CGFloat

    private let valueProvider: (SomeDataType) -> String

    var scale = PointScale<String, OutputPropertyType>()

    /// Creates a new visual channel that references a property using the key-path you provide.
    /// - Parameter dataProperty: the key-path to the property to use for the visual channel.
    ///
    /// example: `VisualChannel<SomeDataType>(\.node)`
    public init(_ dataProperty: KeyPath<SomeDataType, String>) {
        valueProvider = { dataSource in
            dataSource[keyPath: dataProperty]
        }
    }

    /// Creates a new visual channel that returns a constant value that you provide.
    /// - Parameter value: The constant value to use for the visual channel.
    ///
    /// example: `BandVisualChannel("sixth")`
    public init(_ value: String) {
        valueProvider = { _ in
            value
        }
    }

    /// Creates a new visual channel that returns a value using the closure that you provide.
    /// - Parameter closure: A closure that accepts the data provided to the visual channel and returns a value to use for the visual channel.
    public init(_ closure: @escaping (SomeDataType) -> String) {
        valueProvider = { dataSource in
            closure(dataSource)
        }
    }

    /// Returns a new visual channel with the domain for its scale set using the series of values provided to the channel.
    /// - Parameter values: The list of values to use to infer a domain.
    public func applyDomain(_ values: [SomeDataType]) -> Self {
        let listOfValues = values.map { valueProvider($0) }
        var copyOfSelf = self
        copyOfSelf.scale = scale.domain(listOfValues)
        return copyOfSelf
    }

    /// Returns a new visual channel with the range for its scale set using the values you provide.
    /// - Parameters:
    ///   - rangeLower: The lower value for the range.
    ///   - rangeHigher: The higher value for the range.
    public func range(reversed: Bool = false, rangeLower: OutputPropertyType, rangeHigher: OutputPropertyType) -> Self {
        var copyOfSelf = self
        copyOfSelf.scale = scale.range(reversed: reversed, lower: rangeLower, higher: rangeHigher)
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
        return scale.scale(valueProvider(data))
    }
}

// MARK: - Visual Channel - Discrete/Color

// MARK: - Visual Channel - Continuous/Color

// MARK: - Visual Channel - Discrete/Shape

// TBD: need channels to provide Color, and another to provide a Shape for symbols (DotMark)
