//
//  VisualChannel.swift
//
//
//  Created by Joseph Heck on 3/25/22.
//

import Foundation
import SwiftViz

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

public struct MappedVisualChannel<SomeDataType, ScaleType: Scale, DataPropertyType, PropertyType: TypeOfVisualProperty>: VisualChannel where ScaleType.InputType == DataPropertyType, ScaleType.OutputType == PropertyType {
    let dataProperty: KeyPath<SomeDataType, DataPropertyType>

    var scale: ScaleType // input=Double, output=Float
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
    public init(_ dataProperty: KeyPath<SomeDataType, DataPropertyType>) {
        self.dataProperty = dataProperty
        scale = LinearScale.create(0.0 ... 1.0) as! ScaleType
        // We need the at least the domain to create it - so we need to know the range of values
        // before we can instantiate a scale if it's not explicitly declared
        
        // It might be nice to have the specific scales Type Erased so that we can
        // store the scale reference as AnyScaleType<InputType, OutputType>: Scale
        // and have a super-optimized `.identity` type that does a 1:1 pass through
        // with no computation on the value.
    }

    func provideScaledValue(d: SomeDataType) -> PropertyType? {
        let valueFromData: DataPropertyType = d[keyPath: dataProperty]
        return scale.scale(valueFromData, from: 0, to: 1)
    }
    
    // modifier type - generics, no impl:
    
    func scale<NewScaleType: Scale>(newScale: NewScaleType) where NewScaleType.InputType == DataPropertyType, NewScaleType.OutputType == PropertyType {
        
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
