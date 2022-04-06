//
//  DotMark.swift
//
//
//  Created by Joseph Heck on 3/25/22.
//

import SwiftUI
import SwiftVizScale

/// A type that represents a series of bars.
///
/// The type infers the number and visual properties of the bars from the data you provide to the visual channels when declaring a bar mark.
public struct DotMark<DataSource>: Mark {
    var data: DataSource
    public func symbolsForMark() -> [MarkSymbol] {
        return []
    }
    
    public typealias MarkType = Self
    public init(data: DataSource,
                x: AVisualChannel<DataSource, Double>) {
        self.data = data
    }
}
