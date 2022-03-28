//
//  LineMark.swift
//
//
//  Created by Joseph Heck on 3/25/22.
//

import SwiftUI

/// A type that represents a series of bars.
///
/// The type infers the number and visual properties of the bars from the data you provide to the visual channels when declaring a bar mark.
public struct LineMark: Mark {
    public typealias DataType = Any
    public var mappings: [AnyVisualChannel<LineMark, Any>]

    public typealias MarkType = Self
    public init() {
        mappings = []
    }
}
