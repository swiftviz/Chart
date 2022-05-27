//
//  ChartSpec.swift
//

import Foundation
import SwiftUI
import SwiftVizScale

struct AxisLists {
    var xAxisTopList: [Axis] = []
    var xAxisBottomList: [Axis] = []
    var yAxisLeadingList: [Axis] = []
    var yAxisTrailingList: [Axis] = []

    var yAxisList: [Axis] {
        var list: [Axis] = []
        list.append(contentsOf: yAxisLeadingList)
        list.append(contentsOf: yAxisTrailingList)
        return list
    }

    var xAxisList: [Axis] {
        var list: [Axis] = []
        list.append(contentsOf: xAxisTopList)
        list.append(contentsOf: xAxisBottomList)
        return list
    }
}

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

    func compileAxis() -> AxisLists {
        var axisCollection = AxisLists()
        for mark in marks {
            if let xAxis = mark._xAxis {
                switch xAxis.axisLocation {
                case .top:
                    axisCollection.xAxisTopList.append(xAxis)

                default:
                    axisCollection.xAxisBottomList.append(xAxis)
                }
            }
            if let yAxis = mark._yAxis {
                switch yAxis.axisLocation {
                case .trailing:
                    axisCollection.yAxisTrailingList.append(yAxis)

                default:
                    axisCollection.yAxisLeadingList.append(yAxis)
                }
            }
        }
        return axisCollection
    }
}
