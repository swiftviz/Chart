//
//  Axis.swift
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

    // An axis is partially defined as a declaration, but the final configuration
    // can't be determined until later when the rectangular area that you'll be drawing
    // the axis into can be used with scales to determine the ticks and their points.
    // When it *is* declared, the Mark is already fully described, including having the
    // data applied to the Mark, so the mark's scales (which are used to determine ticks)
    // have the relevant domain applied to them.
    //
    // Design wise, I'm a little unclear if I should have a copy of the either copied
    // or referenced from this struct, of it that's something that should be applied later
    // (as a closure? - either CGFloat range, CGRect, or scale + CGFloat range) that
    // generates the list of the ticks to be displayed.
    //
    // This needs a list of tick values (String) and their location (CGFloat) along the axis
    // default should be the default set of ticks generated from the Scale associated with
    // the visual channel for that axis on the mark.
    //
    // If the user provides a list of tick values, they'll be in the "incoming" domain value and need to be
    // converted to the appropriate label and assigned a CGFloat location, again through that scale, and
    // some of them might even be dropped if they range off the end of the scale.
    //
    // Current theory is a partial configuration, with the expectation that we'll invoke
    // a closure from the Mark (so it has access to the Mark's scales) that provides the completely
    // configured Axis (or two) for drawing: `func axisFromMark(in: CGRect) -> [Axis.AxisLocation: Axis]`

    let axisLocation: AxisLocation
    let scale: VisualPropertyScale
    let requestedTickValues: [Double]
    let rule: Bool
    let ruleStyle: StrokeStyle
    let ruleShading: GraphicsContext.Shading
    let tickLength: CGFloat
    let tickOrientation: TickOrientation
    let tickPadding: CGFloat
    let tickAlignment: UnitPoint
    let showTickLabels: Bool
    let chartRules: Bool // aka 'grid', but only for one direction
    let chartRuleStyle: StrokeStyle
    let chartRuleShading: GraphicsContext.Shading

    let tickStyle: StrokeStyle
    let tickShading: GraphicsContext.Shading

    let label: String
    let labelAlignment: Alignment
    let labelOffset: CGFloat
    let labelRotation: Angle

    // only available on a fully configured Axis specification
    // use `addingTicks()` to add on the configured values.
    var ticks: [Tick<CGFloat>]
    /// A declaration of how to draw an axis for a chart.
    /// - Parameters:
    ///   - axisLocation: The location of the axis for the chart.
    ///   - scale: The visual property scale to use with the axis.
    ///   - rule: A Boolean value that indicates the axis should be drawn on the edge of the chart.
    ///   - requestedTickValues: A list of tick values to present on the axis.
    ///   - ticks: A list of tick values and locations to present on the axis.
    ///   - tickLength: The length of the ticks.
    ///   - tickOrientation: The direction the tick is drawn from the axis.
    ///   - tickPadding: The amount of padding between the end of a tick and its value.
    ///   - tickAlignment: The edge of the tick label to align with the tick.
    ///   - chartRules: A Boolean value that indicates that the tick values should be used to draw rules across the background of the chart.
    ///   - label: The label for the axis.
    ///   - labelAlignment: The alignment of the label for the axis
    ///   - labelOffset: The offset for the label away from the axis.
    public init(_ axisLocation: AxisLocation,
                scale: VisualPropertyScale,
                rule: Bool = true,
                requestedTickValues: [Double] = [],
                tickLength: CGFloat = 3,
                tickOrientation: TickOrientation = .outer,
                tickPadding: CGFloat = 5,
                tickAlignment: UnitPoint? = nil,
                showTickLabels: Bool = true,
                chartRules: Bool = false,
                label: String = "",
                labelOffset: CGFloat = 0,
                labelAlignment: Alignment = .center,
                labelRotation: Angle? = nil)
    {
        self.scale = scale
        self.axisLocation = axisLocation
        // ticks
        self.tickLength = tickLength
        self.tickPadding = tickPadding
        self.tickOrientation = tickOrientation
        self.requestedTickValues = requestedTickValues
        self.showTickLabels = showTickLabels
        if let tickAlignment = tickAlignment {
            self.tickAlignment = tickAlignment
        } else {
            switch axisLocation {
            case .bottom:
                self.tickAlignment = .top
            case .top:
                self.tickAlignment = .bottom
            case .leading:
                self.tickAlignment = .trailing
            case .trailing:
                self.tickAlignment = .leading
            }
        }
        // rules
        self.rule = rule
        self.chartRules = chartRules
        // axis label
        self.label = label
        self.labelOffset = labelOffset
        self.labelAlignment = labelAlignment
        if let labelRotation = labelRotation {
            self.labelRotation = labelRotation
        } else {
            switch axisLocation {
            case .bottom, .top:
                self.labelRotation = .degrees(0)
            case .leading, .trailing:
                self.labelRotation = .degrees(-90)
            }
        }
        // style for the rule along the axis
        tickStyle = StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round, miterLimit: 1)
        // style for the ticks off that rule
        ruleStyle = tickStyle
        // color/shading for the ticks
        tickShading = .color(.primary)
        // color/shading for the rule
        ruleShading = tickShading

        chartRuleStyle = tickStyle
        chartRuleShading = ruleShading
        ticks = []
    }

    /// Resolves the ticks with labels and positions for the rectangular area that you provide.
    /// - Parameters:
    ///   - rect: The rectangle into which to scale and draw axis.
    ///   - invertX: A Boolean value that indicates the X values should be reversed.
    ///   - invertY: A Boolean value that indicates the Y values should be reversed.
    /// - Returns: A list of ticks derived from the scale associated with the axis.
    func resolveTicks(_ rect: CGRect, invertX: Bool = false, invertY: Bool = false) -> [Tick<CGFloat>] {
        switch axisLocation {
        case .top, .bottom:
            return scale.tickValuesFromScale(reversed: invertX, lower: rect.origin.x, higher: rect.origin.x + rect.width, values: requestedTickValues)
        case .leading, .trailing:
            return scale.tickValuesFromScale(reversed: invertY, lower: rect.origin.y, higher: rect.origin.y + rect.height, values: requestedTickValues)
        }
    }
}
