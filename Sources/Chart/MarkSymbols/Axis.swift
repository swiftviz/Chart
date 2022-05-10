//
//  Axis.swift
//
//
//  Created by Joseph Heck on 5/9/22.
//

import SwiftUI

/// The declaration for how to draw an axis for a chart.
public struct Axis {
    /// The direction a tick is draw from an axis.
    public enum TickOrientation {
        /// The tick is drawn from the axis inward towards the chart.
        case inner
        /// The tick is drawn from the axis outward from the chart.
        case outer
    }

    /// The edge of the chart to draw the axis.
    public enum AxisLocation: Hashable {
        // implies ChartOrientation -  but maybe associated value to the type and specific scale?
        case top
        case bottom
        case leading
        case trailing
        case foreground(VisualPropertyType)
        case background //
    }

    let orientation: ChartOrientation
    let domainPropertyType: VisualPropertyType
    let axisLocation: AxisLocation
    let rule: Bool
    let nice: Bool
    let requestedTicks: Int
    let tickLength: CGFloat
    let tickOrientation: TickOrientation
    let tickPadding: CGFloat
    let tickRules: Bool
    let label: String
    let labelAlignment: Alignment
    let labelOffset: CGFloat

    /// A declaration of how to draw an axis for a chart.
    /// - Parameters:
    ///   - orientation: The directional orientation of the axis.
    ///   - axisLocation: The location of the axis compared to the chart.
    ///   - rule: A Boolean value that indicates the axis should be drawn on the edge of the chart.
    ///   - nice: A Boolean value that indicates that the ticks should be placed at nice values.
    ///   - ticks: The number of ticks to request to be displayed along the axis.
    ///   - tickLength: The length of the ticks.
    ///   - tickOrientation: The direction the tick is drawn from the axis.
    ///   - tickPadding: The amount of padding between the end of a tick and its value.
    ///   - tickRules: A Boolean value that indicates that the tick values should be used to draw rules across the background of the chart.
    ///   - label: The label for the axis.
    ///   - labelAlignment: The alignment of the label for the axis
    ///   - labelOffset: The offset for the label away from the axis.
    public init(_ orientation: ChartOrientation,
                domainPropertyType: VisualPropertyType,
                axisLocation: AxisLocation? = nil,
                rule: Bool = true,
                nice: Bool,
                ticks: Int,
                tickLength: CGFloat = 3,
                tickOrientation: TickOrientation = .outer,
                tickPadding: CGFloat = 5,
                tickRules: Bool = false,
                label: String = "",
                labelOffset: CGFloat = 0,
                labelAlignment: Alignment = .center)
    {
        self.orientation = orientation
        self.domainPropertyType = domainPropertyType
        if let axisLocation = axisLocation {
            switch orientation {
            case .vertical:
                precondition([AxisLocation.leading, AxisLocation.trailing].contains(axisLocation),
                             "Invalid vertical axis location")
            case .horizontal:
                precondition([AxisLocation.top, AxisLocation.bottom].contains(axisLocation),
                             "Invalid horizontal axis location")
            case .depth:
                precondition([AxisLocation.foreground, AxisLocation.background].contains(axisLocation),
                             "Invalid depth axis location")
            }
            self.axisLocation = axisLocation
        } else {
            switch orientation {
            case .vertical:
                self.axisLocation = .bottom
            case .horizontal:
                self.axisLocation = .leading
            case .depth:
                self.axisLocation = .foreground
            }
        }
        self.nice = nice
        requestedTicks = ticks
        self.tickLength = tickLength
        self.tickPadding = tickPadding
        self.tickOrientation = tickOrientation
        self.rule = rule
        self.tickRules = tickRules
        self.label = label
        self.labelOffset = labelOffset
        self.labelAlignment = labelAlignment
    }
}
