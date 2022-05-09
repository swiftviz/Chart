//
//  File.swift
//
//
//  Created by Joseph Heck on 5/9/22.
//

import Foundation

/// A declarative chart specification.
public struct ChartSpec {
    // The marks that make up the symbols of the chart
    let marks: [AnyMark]
    let axis: [Axis.AxisLocation: Axis]

    /// Creates a new, default chart declaration.
    public init() {
        marks = []
        axis = [:]
    }

    /// Creates a new chart declaration with a mark you provide.
    /// - Parameter mark: A mark declaration.
    public init(mark: AnyMark) {
        marks = [mark]
        axis = [:]
    }

    /// Creates a new chart declaration with the marks you provide.
    /// - Parameter marks: A list of mark declarations.
    public init(marks: [AnyMark]) {
        self.marks = marks
        axis = [:]
    }

    /// Returns a new chart declaration that is the combination of the original specification and the specification you provide.
    /// - Parameter spec: A chart specification to merge.
    public func merging(_ spec: ChartSpec) -> ChartSpec {
        var combinedMarks: [AnyMark] = marks
        combinedMarks.append(contentsOf: spec.marks)
        return ChartSpec(marks: combinedMarks)
    }
}
