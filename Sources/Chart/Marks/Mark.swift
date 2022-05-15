//
//  Mark.swift
//
//
//  Created by Joseph Heck on 3/25/22.
//
import SwiftUI
import SwiftVizScale

/// A type that represents one or more visual symbols displays in a chart.
///
/// A mark describes the configuration of how data is mapped to visual properties relevant to the type of mark.
public protocol Mark {
    // exposed via the protocol to allow a protocol extension to access and use
    // the scale to fully configure an Axis object
    var xPropertyScale: VisualPropertyScale { get }
    var yPropertyScale: VisualPropertyScale { get }

    /// Creates a list of symbols to render into a rectangular drawing area that you specify.
    /// - Parameter in: The rectangle into which to scale and draw the symbols.
    /// - Returns: A list of symbol data structures with the information needed to draw them onto a canvas or into CoreGraphics context.
    func symbolsForMark(in: CGRect) -> [MarkSymbol]

    /// Returns the set of axis configurations that have been enabled for the mark
    /// - Parameter in: The rectangle into which to scale and draw axis.
    /// - Returns: A dictionary of Axis keyed by the axis location.
    func axisForMark(in: CGRect) -> [Axis]

    func getXAxis() -> Axis?
    func getYAxis() -> Axis?
}

extension Mark {
    /// Returns the set of axis configurations that have been enabled for the mark
    /// - Parameter in: The rectangle into which to scale and draw axis.
    /// - Returns: A dictionary of Axis keyed by the axis location.
    ///
    /// The default implementation for a ``Chart/Mark`` returns an empty dictionary.
    /// Conform a mark that should return a ``Chart/Axis`` definitions to ``Chart/MarkAxis``, or provide
    /// your own implementation the returns a dictionary of configured Axis declarations.
    func axisForMark(in _: CGRect) -> [Axis.AxisLocation: Axis] {
        [:]
    }
}

/// A type of mark that supports defining an Axis and providing configured Axis definitions to render on a chart.
public protocol MarkAxis: Mark {
    // really kind of wishing that protocols could define 'internal' properties that were accessible
    // to the protocol default implementations...
    var _xAxis: Axis? { get set }
    var _yAxis: Axis? { get set }

    /// Draws an X axis on the chart.
    func xAxis() -> Self

    /// Draws an X axis on the chart.
    func yAxis() -> Self
}

public extension MarkAxis {
    /// Draws an X axis on the chart.
    func xAxis() -> Self {
        var newMark = self
        newMark._xAxis = Axis(.bottom, scale: xPropertyScale)
        return newMark
    }

    /// Draws an X axis on the chart.
    func yAxis() -> Self {
        var newMark = self
        newMark._yAxis = Axis(.leading, scale: yPropertyScale)
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
