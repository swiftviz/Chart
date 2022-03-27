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
    case quantitative //(Double)
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

//public struct VisualPropertyInstance<UnderlyingType> {
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
//}

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
public struct VisualChannel<MarkType: Mark, DataType, PropertyType: TypeOfVisualProperty>: TypeOfVisualChannel {
    let markProperty: WritableKeyPath<MarkType, PropertyType>
    let dataProperty: KeyPath<DataType, PropertyType>?
    let constantValue: PropertyType?
    let kindOfChannel: RefOfConstant
    
    //var scale: Scale?
    func partiallyErasedVisualChannel() -> some TypeOfVisualChannel {
        return self
    }
    
    // something like `VisualChannel(\BarMark.width, \.node)` or `VisualChannel(y, 13)`
    // maybe `VisualChannel(\.width, from: \.name)` - does the `from: ` add meaningful semantic context?
    public init(_ markProperty: WritableKeyPath<MarkType, PropertyType>,
                from dataProperty: KeyPath<DataType, PropertyType>) {
        self.markProperty = markProperty
        self.kindOfChannel = .reference
        self.dataProperty = dataProperty
        self.constantValue = nil
        // self.scale = LinearScale(domain: 0...1)
        // We need the at least the domain to create it - so we need to know the range of values
        // before we can instantiate a scale if it's not explicitly declared
    }

    // something like `VisualChannel(\BarMark.width, \.node)` or `VisualChannel(y, 13)`
    // maybe `VisualChannel(\.width, from: \.name)` - does the `from: ` add meaningful semantic context?
    public init(_ markProperty: WritableKeyPath<MarkType, PropertyType>,
                value: PropertyType) {
        self.markProperty = markProperty
        self.kindOfChannel = .constant
        self.constantValue = value
        self.dataProperty = nil
        // self.scale = LinearScale(domain: 0...1)
        // We need the at least the domain to create it - so we need to know the range of values
        // before we can instantiate a scale if it's not explicitly declared
    }

    func writeScaledValue(d: DataType, m: inout MarkType) {
        let valueFromData: PropertyType
        switch kindOfChannel {
        case .reference:
            guard let dataProperty =  self.dataProperty else {
                preconditionFailure("keypath for a reference visual channel was null")
//                return
            }
            valueFromData = d[keyPath: dataProperty]
        case .constant:
            guard let constantValue = constantValue else {
                preconditionFailure("keypath for a reference visual channel was null")
//                return
            }
            valueFromData = constantValue
        }
        // scale the value here...
        m[keyPath: self.markProperty] = valueFromData
    }
}

struct ErasedVisualChannel<DataType, MarkType> {
    let boxedType: some VisualChannel<<#MarkType: Mark#>, Any, <#PropertyType: TypeOfVisualProperty#>>
    let kindOfChannel: RefOfConstant
    func writeScaledValue(d: DataType, m: inout MarkType)
}
