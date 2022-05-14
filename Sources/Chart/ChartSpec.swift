//
//  File.swift
//
//
//  Created by Joseph Heck on 5/9/22.
//

import Foundation
import SwiftUI
import SwiftVizScale

/// A declarative chart specification.
public struct ChartSpec {
    // The marks that make up the symbols of the chart
    let marks: [AnyMark]
    var margin: EdgeInsets
    var inset: EdgeInsets

    /// Creates a new, default chart declaration.
    public init() {
        marks = []
        margin = EdgeInsets()
        inset = EdgeInsets()
    }

    /// Creates a new chart declaration with a mark you provide.
    /// - Parameter mark: A mark declaration.
    public init(mark: AnyMark, margin: EdgeInsets = EdgeInsets(), inset: EdgeInsets = EdgeInsets()) {
        marks = [mark]
        self.margin = margin
        self.inset = inset
    }

    /// Creates a new chart declaration with the marks you provide.
    /// - Parameter marks: A list of mark declarations.
    public init(marks: [AnyMark], margin: EdgeInsets = EdgeInsets(), inset: EdgeInsets = EdgeInsets()) {
        self.marks = marks
        self.margin = margin
        self.inset = inset
    }

    /// Returns a new chart declaration that adds the marks from the specification you provide to the current specification.
    /// - Parameter spec: A chart specification to merge.
    public func merging(_ spec: ChartSpec) -> ChartSpec {
        var combinedMarks: [AnyMark] = marks
        combinedMarks.append(contentsOf: spec.marks)
        return ChartSpec(marks: combinedMarks, margin: spec.margin, inset: spec.inset)
    }
}
