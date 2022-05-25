//
//  Mark.swift
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
    var _xAxis: Axis? { get }
    var _yAxis: Axis? { get }

    /// Creates a list of symbols to render into a rectangular drawing area that you specify.
    /// - Parameter in: The rectangle into which to scale and draw the symbols.
    /// - Returns: A list of symbol data structures with the information needed to draw them onto a canvas or into CoreGraphics context.
    func symbolsForMark(in: CGRect) -> [Sigil]
}
