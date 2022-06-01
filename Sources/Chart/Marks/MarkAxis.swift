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
    func xAxis(_ location: Axis.AxisLocation,
               rule: Bool,
               values: [Double],
               tickLength: CGFloat,
               tickOrientation: Axis.TickOrientation,
               tickPadding: CGFloat,
               tickAlignment: UnitPoint?,
               showTickLabels: Bool,
               chartRules: Bool,
               label: String,
               labelOffset: CGFloat,
               labelAlignment: Alignment) -> Self

    /// Draws an X axis on the chart.
    func yAxis(_ location: Axis.AxisLocation,
               rule: Bool,
               values: [Double],
               tickLength: CGFloat,
               tickOrientation: Axis.TickOrientation,
               tickPadding: CGFloat,
               tickAlignment: UnitPoint?,
               showTickLabels: Bool,
               chartRules: Bool,
               label: String,
               labelOffset: CGFloat,
               labelAlignment: Alignment) -> Self
}

public extension MarkAxis {
    /// Draws an X axis on the chart.
    func xAxis(_ location: Axis.AxisLocation = .bottom,
               rule: Bool = true,
               values: [Double] = [],
               tickLength: CGFloat = 3,
               tickOrientation: Axis.TickOrientation = .outer,
               tickPadding: CGFloat = 5,
               tickAlignment: UnitPoint? = nil,
               showTickLabels: Bool = true,
               chartRules: Bool = false,
               label: String = "",
               labelOffset: CGFloat = 0,
               labelAlignment: Alignment = .center) -> Self
    {
        precondition([.bottom, .top].contains(location), "An X axis can't be placed on leading or trailing edges")
        var newMark = self
        newMark._xAxis = Axis(location,
                              scale: xPropertyScale,
                              rule: rule,
                              requestedTickValues: values,
                              tickLength: tickLength,
                              tickOrientation: tickOrientation,
                              tickPadding: tickPadding,
                              tickAlignment: tickAlignment,
                              showTickLabels: showTickLabels,
                              chartRules: chartRules,
                              label: label,
                              labelOffset: labelOffset,
                              labelAlignment: labelAlignment)
        return newMark
    }

    /// Draws an X axis on the chart.
    func yAxis(_ location: Axis.AxisLocation = .leading,
               rule: Bool = true,
               values: [Double] = [],
               tickLength: CGFloat = 3,
               tickOrientation: Axis.TickOrientation = .outer,
               tickPadding: CGFloat = 5,
               tickAlignment: UnitPoint? = nil,
               showTickLabels: Bool = true,
               chartRules: Bool = false,
               label: String = "",
               labelOffset: CGFloat = 0,
               labelAlignment: Alignment = .center) -> Self
    {
        precondition([.leading, .trailing].contains(location), "A Y axis can't be placed on top or bottom edges")
        var newMark = self
        newMark._yAxis = Axis(location,
                              scale: yPropertyScale,
                              rule: rule,
                              requestedTickValues: values,
                              tickLength: tickLength,
                              tickOrientation: tickOrientation,
                              tickPadding: tickPadding,
                              tickAlignment: tickAlignment,
                              showTickLabels: showTickLabels,
                              chartRules: chartRules,
                              label: label,
                              labelOffset: labelOffset,
                              labelAlignment: labelAlignment)
        return newMark
    }
}
