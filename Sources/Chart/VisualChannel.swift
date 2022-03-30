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
    associatedtype ValueType: TypeOfVisualProperty
    associatedtype SomeDataType: Any

    // var scale: Scale
    func provideScaledValue(d: SomeDataType) -> ValueType?
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
// internal class _AnyVisualChannelBox<MarkType: Mark, DataType: Any>: VisualChannel {
//    func writeScaledValue(d _: DataType, m _: inout MarkType) {
//        _abstract()
//    }
// }

// the "Any" class to hold a reference to a specific type, and forward invocations from
// the (partially) type-erased class into the concrete, specific class that it holds
// (which is how we achieve type-erasure)
// internal final class _VisualChannel<VisualChannelType: VisualChannel>: _AnyVisualChannelBox<VisualChannelType.MarkType, VisualChannelType.DataType> {
//    private var _base: VisualChannelType
//
//    init(_ base: VisualChannelType) {
//        _base = base
//    }
// }

// Partially type erased visual channel, with internals (including the type of property that
// it maps) hidden.
// A partially type-erased visual channel that maps properties from data into a mark.
// public struct AnyVisualChannel<MarkStorage: Mark, DataStorage>: VisualChannel {
//    private let _box: _AnyVisualChannelBox<MarkStorage, DataStorage>
//
//    init<VC: VisualChannel>(_ base: VC) where VC.MarkType == MarkStorage, VC.DataType == DataStorage {
//        _box = _VisualChannel(base)
//    }
//
//    func writeScaledValue(d: DataStorage, m: inout MarkStorage) {
//        _box.writeScaledValue(d: d, m: &m)
//    }
// }

// MARK: - Concrete Visual Channel Types

public struct MappedVisualChannel<SomeDataType, PropertyType: TypeOfVisualProperty>: VisualChannel {
    let dataProperty: KeyPath<SomeDataType, PropertyType>

    // var scale: Scale?

    // something like `VisualChannel<SomeDataType>(\.node)`
    public init(_ dataProperty: KeyPath<SomeDataType, PropertyType>) {
        self.dataProperty = dataProperty
        // self.scale = LinearScale(domain: 0...1)
        // We need the at least the domain to create it - so we need to know the range of values
        // before we can instantiate a scale if it's not explicitly declared
    }

    func provideScaledValue(d: SomeDataType) -> PropertyType? {
        let valueFromData: PropertyType = d[keyPath: dataProperty]
        // scale the value here...
        // ... return nil if scaling NaN's
        return valueFromData
    }
}

public struct ConstantVisualChannel<SomeDataType, PropertyType: TypeOfVisualProperty> {
    let constantValue: PropertyType

    // var scale: Scale?

    // something like `VisualChannel(13.0)`
    public init(value: PropertyType) {
        constantValue = value
        // self.scale = LinearScale(domain: 0...1)
        // We need the at least the domain to create it - so we need to know the range of values
        // before we can instantiate a scale if it's not explicitly declared
    }

    func provideScaledValue(d _: SomeDataType) -> PropertyType? {
        let valueFromConstant = constantValue
        // scale the value here...
        return valueFromConstant
    }
}
