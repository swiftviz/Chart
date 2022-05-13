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
    var xPropertyType: VisualPropertyType { get }
    var yPropertyType: VisualPropertyType { get }

    /// Creates a list of symbols to render into a rectangular drawing area that you specify.
    /// - Parameter in: The rectangle into which to scale and draw the symbols.
    /// - Returns: A list of symbol data structures with the information needed to draw them onto a canvas or into CoreGraphics context.
    func symbolsForMark(in: CGRect) -> [MarkSymbol]

    /// Returns the set of axis configurations that have been enabled for the mark
    /// - Parameter in: The rectangle into which to scale and draw axis.
    /// - Returns: A dictionary of Axis keyed by the axis location.
    func axisForMark(in: CGRect) -> [Axis.AxisLocation: Axis]
}
