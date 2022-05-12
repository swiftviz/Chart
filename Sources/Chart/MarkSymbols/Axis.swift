//
//  Axis.swift
//
//
//  Created by Joseph Heck on 5/9/22.
//

import SwiftUI
import SwiftVizScale

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
        case top
        case bottom
        case leading
        case trailing
    }

    // need a list of tick values (String) and their location (CGFloat) along the axis
    // default should be the default set of ticks generated from the Scale associated with
    // the visual channel for that axis on the mark.

    // the extra generic bits inside Scale's Tick don't end up helping me - in fact, they make it
    // worse, since I could have a variety of different generators...

    // If the user provides a list of tick values, they'll be in the "incoming" domain value and need to be
    // converted to the appropriate label and assigned a CGFloat location, again through that scale, and
    // some of them might even be dropped if they range off the end of the scale.

    let axisLocation: AxisLocation
    let rule: Bool
    let ticks: [Tick<CGFloat>]
    let tickLength: CGFloat
    let tickOrientation: TickOrientation
    let tickPadding: CGFloat
    let tickRules: Bool // aka 'grid', but only for one direction
    let label: String
    let labelAlignment: Alignment
    let labelOffset: CGFloat

    /// A declaration of how to draw an axis for a chart.
    /// - Parameters:
    ///   - axisLocation: The location of the axis for the chart.
    ///   - rule: A Boolean value that indicates the axis should be drawn on the edge of the chart.
    ///   - ticks: A list of tick values and locations to present on the axis.
    ///   - tickLength: The length of the ticks.
    ///   - tickOrientation: The direction the tick is drawn from the axis.
    ///   - tickPadding: The amount of padding between the end of a tick and its value.
    ///   - tickRules: A Boolean value that indicates that the tick values should be used to draw rules across the background of the chart.
    ///   - label: The label for the axis.
    ///   - labelAlignment: The alignment of the label for the axis
    ///   - labelOffset: The offset for the label away from the axis.
    public init(_ axisLocation: AxisLocation,
                rule: Bool = true,
                ticks: [Tick<CGFloat>], // cant' get to the final values for CGFloat until we know the size of the area...
                tickLength: CGFloat = 3,
                tickOrientation: TickOrientation = .outer,
                tickPadding: CGFloat = 5,
                tickRules: Bool = false,
                label: String = "",
                labelOffset: CGFloat = 0,
                labelAlignment: Alignment = .center)
    {
        self.axisLocation = axisLocation
        self.ticks = ticks
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
