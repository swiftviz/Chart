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

    /// Returns the set of axis configurations that have been enabled for the mark
    /// - Parameter in: The rectangle into which to scale and draw axis.
    /// - Returns: A dictionary of Axis keyed by the axis location.
    func axisForMark(in rect: CGRect) -> [Axis] {
        var axisSet: [Axis] = []
        if let _xAxis = _xAxis {
            let ticks = xPropertyScale.tickValuesFromScale(lower: rect.origin.x, higher: rect.origin.x + rect.width, values: _xAxis.requestedTickValues)
            axisSet.append(_xAxis.addingTicks(ticks))
        }
        if let _yAxis = _yAxis {
            let ticks = yPropertyScale.tickValuesFromScale(lower: rect.origin.y, higher: rect.origin.y + rect.height, values: _yAxis.requestedTickValues)
            axisSet.append(_yAxis.addingTicks(ticks))
        }
        return axisSet
    }
}
