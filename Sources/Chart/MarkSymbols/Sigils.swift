import SwiftUI

/// A type that represents an individual symbol to draw within a chart context.
///
/// `MarkSymbol` provides a single type collection point to gather the individual symbols
/// for use by ``Chart/ChartRenderer`` to draw those symbols at the appropriate location
/// for chart visualization.
public enum MarkSymbol {
    case point(IndividualPoint)
    case line(IndividualLine)
    case rect(IndividualRect)
    case rule(IndividualRule)
    case text(Text)
    case image(Image)
}

///// A type that represents an individual data point symbol for a mark can render itself into a graphics context.
// protocol RenderableSymbol {
//    func render(mark: MarkSymbol, in context: inout GraphicsContext)
// }

// Do we separate out data and rendering, or include the rendering capability into
// the individual data mark kind of thing?

public struct IndividualLine {
    let x1: CGFloat
    let y1: CGFloat

    let x2: CGFloat
    let y2: CGFloat

    let shape: PlotSymbol
    // var title: String { get } ?
}


// ?? make generic versions of this that can draw their "shape" into the space provided?
public struct IndividualPoint {
    let x: CGFloat
    let y: CGFloat

    let shape: PlotSymbol
    // var title: String { get } ?
}

public struct IndividualRect {
    let category: String
    let x: CGFloat
    let y: CGFloat

    let width: CGFloat
    let height: CGFloat

    var cornerRadius: CGFloat?
    var cornerRadiusTopLeft: CGFloat?
    var cornerRadiusTopRight: CGFloat?
    var cornerRadiusBottomLeft: CGFloat?
    var cornerRadiusBottomRight: CGFloat?

    let shape: PlotSymbol
    // var title: String { get } ?
}

public struct IndividualRule {
    let start: CGFloat
    let end: CGFloat
    let orientationVertical: Bool
}

// symbol - square, circle, diamond, cross - and insettable to mix
// text
// image
