//
//  BarMark.swift
//
//
//  Created by Joseph Heck on 3/25/22.
//
import SwiftUI

enum Orientation {
    case vertical
    case horizontal
    case depth
}

/// A type that represents a series of bars.
///
/// The type infers the number and visual properties of the bars from the data you provide to the visual channels when declaring a bar mark.
public struct BarMark: Mark {
    public typealias DataType = Any
    public var mappings: [AnyVisualChannel<BarMark, Any>]
    
    public typealias MarkType = Self
    
    var orientation: Orientation = .vertical

    let value: Double // ? value cast from with quantitative (Double) or Ordinal (Int) type

    let category: String // ? value cast from the mapping to width, which could be from a categorical (String) or ordinal (Int) type.
    // The actual width for an individual bar as displayed on the Canvas
    // can be inferred if the mapped property is categorical by dividing
    // the available space among the # of categories being displayed with
    // accommodation for optional spacing between the bars.

    public init(_ value: Double, _ category: String) {
        self.value = value
        self.category = category
        self.mappings = []
    }

//    public init(@MarkBuilder<BarMark> ) {
//
//    }
}
