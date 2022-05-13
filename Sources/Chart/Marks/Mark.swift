//
//  Mark.swift
//
//
//  Created by Joseph Heck on 3/25/22.
//
import SwiftUI

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
    func axisForMark(in: CGRect) -> [Axis.AxisLocation: Axis]
}

extension Mark {
    func axisForMark(in _: CGRect) -> [Axis.AxisLocation: Axis] {
        // The default response provides *no* axis information for a Mark
        // Conform/implement the mark to MarkAxis to get its default implementation
        [:]
    }
}

public protocol MarkAxis: Mark {
    // really kind of wishing that protocols could define 'internal' properties that were accessible
    // to the protocol default implementations...
    var _xAxis: Axis? { get set }
    var _yAxis: Axis? { get set }

    func xAxis() -> Self
    func yAxis() -> Self
}

public extension MarkAxis {
    func xAxis() -> Self {
        var newMark = self
        newMark._xAxis = Axis(.bottom)
        return newMark
    }

    func yAxis() -> Self {
        var newMark = self
        newMark._yAxis = Axis(.leading)
        return newMark
    }

    /// Returns the set of axis configurations that have been enabled for the mark
    /// - Parameter in: The rectangle into which to scale and draw axis.
    /// - Returns: A dictionary of Axis keyed by the axis location.
    func axisForMark(in rect: CGRect) -> [Axis.AxisLocation: Axis] {
        var axisSet: [Axis.AxisLocation: Axis] = [:]
        if let _xAxis = _xAxis {
            let ticks = xPropertyScale.tickValuesFromScale(lower: rect.origin.x, higher: rect.origin.x + rect.width)
            axisSet[_xAxis.axisLocation] = _xAxis.addingTicks(ticks)
        }
        if let _yAxis = _yAxis {
            let ticks = yPropertyScale.tickValuesFromScale(lower: rect.origin.y, higher: rect.origin.y + rect.height)
            axisSet[_yAxis.axisLocation] = _yAxis.addingTicks(ticks)
        }
        return axisSet
    }
}
