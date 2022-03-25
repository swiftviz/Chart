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


// struct vs. enum?
public struct VisualProperty<InstanceType: TypeOfVisualProperty> {
    let name: String
    let value: InstanceType
    
    // Nope: Static stored properties not supported in generic types,
    // plus this means we need to know the value as we're defining it,
    // and we won't at that point.
    //static var x = VisualProperty(name: "x", typeAndValue: .quantitative(0))
}

/// A type that provides a the channel mapping to link a property or value to a visual property of a mark.
public struct VisualChannel<InstanceType: TypeOfVisualProperty> {
    // visual property type of 'Quantitative' accepts value types of 'Double'
    // visual property type of 'Ordinal' accepts value types of 'Int'
    // visual property type of 'Categorical' accepts value types of 'String'
    // visual property type of 'Temporal' accepts value types of 'Date'
    
    
    // something like `VisualChannel(width, \.node)` or `VisualChannel(y, 13)`
    // What's the type of 'width' and/or 'y' in this case? An enumeration case?
    // A string literal that's converted to a specific mark property?
    // Is what we're creating a concrete visual property that evaluates the mapping and can be immediately used, or has the mapping properties that something else can use?
    
    // The plan is for whatever this struct is and does to be consumed by
    // a result builder that creates an instance of a Mark. Does that change
    // what type a VisualChannel is and what it's responsible for?
    
    public init(_ channelName: String, _ value: InstanceType) {
        
    }
    
}
