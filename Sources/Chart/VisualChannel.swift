//
//  VisualChannel.swift
//
//
//  Created by Joseph Heck on 3/25/22.
//

import Foundation

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

// MARK: - Visual Channel and Type Erasure Constructs

protocol VisualChannel {
    associatedtype MarkType: Mark
    associatedtype DataType

    func writeScaledValue(d: DataType, m: inout MarkType)
}

// fatal error function (with line numbers to debug) that shows when you've accidentally
// called a function on what should be an abstract base class.
internal func _abstract(
    file: StaticString = #file,
    line: UInt = #line
) -> Never {
    fatalError("Method must be overridden", file: file, line: line)
}

// the abstract base class, implementing the base methods
internal class _AnyVisualChannelBox<MarkType: Mark, DataType: Any>: VisualChannel {
    func writeScaledValue(d _: DataType, m _: inout MarkType) {
        _abstract()
    }
}

// the "Any" class to hold a reference to a specific type, and forward invocations from
// the (partially) type-erased class into the concrete, specific class that it holds
// (which is how we achieve type-erasure)
internal final class _VisualChannel<VisualChannelType: VisualChannel>: _AnyVisualChannelBox<VisualChannelType.MarkType, VisualChannelType.DataType> {
    private var _base: VisualChannelType

    init(_ base: VisualChannelType) {
        _base = base
    }
}

// Partially type erased visual channel, with internals (including the type of property that
// it maps) hidden.
/// A partially type-erased visual channel that maps properties from data into a mark.
public struct AnyVisualChannel<MarkStorage: Mark, DataStorage>: VisualChannel {
    private let _box: _AnyVisualChannelBox<MarkStorage, DataStorage>

    init<VC: VisualChannel>(_ base: VC) where VC.MarkType == MarkStorage, VC.DataType == DataStorage {
        _box = _VisualChannel(base)
    }

    func writeScaledValue(d: DataStorage, m: inout MarkStorage) {
        _box.writeScaledValue(d: d, m: &m)
    }
}

// MARK: - Concrete Visual Channel Types

enum RefOfConstant {
    case reference
    case constant
}

/// A type that provides a mapping to link a property or value to a visual property of a mark.
///
/// A ``Mark`` has a number of visual properties that it needs to resolve in order to generate visual symbols on a canvas.
/// Each property has an associated channel declaration, which indicates that the default value for the mark should be
/// overridden by the mapping that the channel provides. Some `Mark` properties don't have defaults, in which case they are
/// required to have a visual channel declaration.
///
public struct CombinedVisualChannel<MarkType: Mark, DataType, PropertyType: TypeOfVisualProperty>: VisualChannel {
    let markProperty: WritableKeyPath<MarkType, PropertyType>
    let dataProperty: KeyPath<DataType, PropertyType>?
    let constantValue: PropertyType?
    let kindOfChannel: RefOfConstant

    // var scale: Scale?

    // something like `VisualChannel(\BarMark.width, \.node)` or `VisualChannel(y, 13)`
    // maybe `VisualChannel(\.width, from: \.name)` - does the `from: ` add meaningful semantic context?
    public init(_ markProperty: WritableKeyPath<MarkType, PropertyType>,
                from dataProperty: KeyPath<DataType, PropertyType>)
    {
        self.markProperty = markProperty
        kindOfChannel = .reference
        self.dataProperty = dataProperty
        constantValue = nil
        // self.scale = LinearScale(domain: 0...1)
        // We need the at least the domain to create it - so we need to know the range of values
        // before we can instantiate a scale if it's not explicitly declared
    }

    // something like `VisualChannel(\BarMark.width, \.node)` or `VisualChannel(y, 13)`
    // maybe `VisualChannel(\.width, from: \.name)` - does the `from: ` add meaningful semantic context?
    public init(_ markProperty: WritableKeyPath<MarkType, PropertyType>,
                value: PropertyType)
    {
        self.markProperty = markProperty
        kindOfChannel = .constant
        constantValue = value
        dataProperty = nil
        // self.scale = LinearScale(domain: 0...1)
        // We need the at least the domain to create it - so we need to know the range of values
        // before we can instantiate a scale if it's not explicitly declared
    }

    func writeScaledValue(d: DataType, m: inout MarkType) {
        let valueFromData: PropertyType
        switch kindOfChannel {
        case .reference:
            guard let dataProperty = dataProperty else {
                preconditionFailure("keypath for a reference visual channel was null")
            }
            valueFromData = d[keyPath: dataProperty]
        case .constant:
            guard let constantValue = constantValue else {
                preconditionFailure("keypath for a reference visual channel was null")
            }
            valueFromData = constantValue
        }
        // scale the value here...
        m[keyPath: markProperty] = valueFromData
    }
}

public struct MappedVisualChannel<MarkType: Mark, DataType, PropertyType: TypeOfVisualProperty>: VisualChannel {
    let markProperty: WritableKeyPath<MarkType, PropertyType>
    let dataProperty: KeyPath<DataType, PropertyType>

    // var scale: Scale?

    // something like `VisualChannel(\BarMark.width, \.node)`
    // maybe `VisualChannel(\.width, from: \.name)` - does the `from: ` add meaningful semantic context?
    public init(_ markProperty: WritableKeyPath<MarkType, PropertyType>,
                from dataProperty: KeyPath<DataType, PropertyType>)
    {
        self.markProperty = markProperty

        self.dataProperty = dataProperty
        // self.scale = LinearScale(domain: 0...1)
        // We need the at least the domain to create it - so we need to know the range of values
        // before we can instantiate a scale if it's not explicitly declared
    }

    func writeScaledValue(d: DataType, m: inout MarkType) {
        let valueFromData: PropertyType = d[keyPath: dataProperty]
        // scale the value here...
        m[keyPath: markProperty] = valueFromData
    }
}

public struct ConstantVisualChannel<MarkType: Mark, DataType, PropertyType: TypeOfVisualProperty> {
    let markProperty: WritableKeyPath<MarkType, PropertyType>
    let constantValue: PropertyType

    // var scale: Scale?

    // something like `VisualChannel(\.y, 13)`
    public init(_ markProperty: WritableKeyPath<MarkType, PropertyType>,
                value: PropertyType)
    {
        self.markProperty = markProperty
        constantValue = value
        // self.scale = LinearScale(domain: 0...1)
        // We need the at least the domain to create it - so we need to know the range of values
        // before we can instantiate a scale if it's not explicitly declared
    }

    func writeScaledValue(d _: DataType, m: inout MarkType) {
        let valueFromConstant = constantValue
        // scale the value here...
        m[keyPath: markProperty] = valueFromConstant
    }
}

// MARK: ChannelBuilder

@resultBuilder
struct ChannelBuilder<MarkType: Mark, DataType> {
    // allows an empty list build block - no variables passed
    static func buildBlock() -> [AnyVisualChannel<MarkType, DataType>] {
        []
    }

    // combines a list of provided channels - all of the same type - into the array
    static func buildBlock(_ channels: AnyVisualChannel<MarkType, DataType>...) -> [AnyVisualChannel<MarkType, DataType>] {
        channels
    }
    // I think I want a variant that takes a specific Types of channel, converts it into the partially type
    // erased variant, and stores it into the array
//    static func buildBlock(_ channels: ConstantVisualChannel<MarkType, Any, Any: TypeOfVisualProperty>) -> [AnyVisualChannel<MarkType, Any>] {
//        channels.map { c in
//            AnyVisualChannel(c)
//        }
//    }
}
