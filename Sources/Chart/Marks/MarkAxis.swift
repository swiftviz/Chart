//
//  MarkAxis.swift
//

import SwiftUI
import SwiftVizScale

/// A type of mark that supports defining an Axis and providing configured Axis definitions to render on a chart.
public protocol MarkAxis: Mark {
    // really kind of wishing that protocols could define 'internal' properties that were accessible
    // to the protocol default implementations...
    var _xAxis: Axis? { get set }
    var _yAxis: Axis? { get set }

    /// Draws an X axis on the chart.
    func xAxis(_ location: Axis.AxisLocation) -> Self

    /// Draws an X axis on the chart.
    func yAxis(_ location: Axis.AxisLocation) -> Self
}

public extension MarkAxis {
    /// Draws an X axis on the chart.
    func xAxis(_ location: Axis.AxisLocation = .bottom) -> Self {
        precondition([.bottom, .top].contains(location), "An X axis can't be placed on leading or trailing edges")
        var newMark = self
        newMark._xAxis = Axis(location, scale: xPropertyScale)
        return newMark
    }

    /// Draws an X axis on the chart.
    func yAxis(_ location: Axis.AxisLocation = .leading) -> Self {
        precondition([.leading, .trailing].contains(location), "A Y axis can't be placed on top or bottom edges")
        var newMark = self
        newMark._yAxis = Axis(location, scale: yPropertyScale)
        return newMark
    }
}
