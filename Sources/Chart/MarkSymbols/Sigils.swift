import SwiftUI

/// A type that represents an individual symbol to draw within a chart context.
///
/// `MarkSymbol` provides a single type collection point to gather the individual symbols
/// for use by `ChartRenderer` to draw those symbols at the appropriate location
/// for chart visualization.
public enum MarkSymbol {
    case point(IndividualPoint)
    case line(IndividualLine)
    case rect(IndividualRect)
    case rule(IndividualRule)
    case text(Text)
    case image(Image)
}

public struct IndividualLine {
    let x1: CGFloat
    let y1: CGFloat

    let x2: CGFloat
    let y2: CGFloat

    var startPoint: CGPoint {
        CGPoint(x: x1, y: y1)
    }

    var endPoint: CGPoint {
        CGPoint(x: x2, y: y2)
    }

    // var title: String { get } ?
    let strokeColor: SwiftUI.Color // ? (https://developer.apple.com/documentation/coregraphics/cgcolor)
    let style: SwiftUI.StrokeStyle // line-width, cap, join, miter, dash, and dash-phase

    init(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat, size _: CGFloat, color: SwiftUI.Color = .primary, style: SwiftUI.StrokeStyle = StrokeStyle()) {
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
        strokeColor = color
        self.style = style
    }

    init(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat, color: SwiftUI.Color = .primary, style: SwiftUI.StrokeStyle = StrokeStyle()) {
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
        strokeColor = color
        self.style = style
    }
}

// ?? make generic versions of this that can draw their "shape" into the space provided?
public struct IndividualPoint {
    let x: CGFloat
    let y: CGFloat

    // var title: String { get } ?
    let shape: PlotShape
    let size: CGSize

    init(x: CGFloat, y: CGFloat, shape: PlotShape, size: CGFloat) {
        self.x = x
        self.y = y
        self.shape = shape
        self.size = CGSize(width: size, height: size)
    }

    init(x: CGFloat, y: CGFloat, shape: PlotShape, size: CGSize) {
        self.x = x
        self.y = y
        self.shape = shape
        self.size = size
    }
}

public struct IndividualRect {
    let category: String

    let rect: CGRect
    let mode: DrawingMode
    var cornerRadius: CGFloat?

    var cornerRadiusTopLeft: CGFloat?
    var cornerRadiusTopRight: CGFloat?
    var cornerRadiusBottomLeft: CGFloat?
    var cornerRadiusBottomRight: CGFloat?

    let strokeColor: SwiftUI.Color // ? (https://developer.apple.com/documentation/coregraphics/cgcolor)
    let fillColor: SwiftUI.Color // ? (https://developer.apple.com/documentation/coregraphics/cgcolor)
    let style: SwiftUI.StrokeStyle // linewidth, cap, join, miter, dash, and dash-phase

    init(rect: CGRect, category: String, cornerRadius: CGFloat? = nil, mode: DrawingMode = .fill, strokeColor: SwiftUI.Color = .primary, fillColor: SwiftUI.Color = .primary, style: SwiftUI.StrokeStyle = StrokeStyle()) {
        self.rect = rect
        self.category = category
        self.mode = mode
        self.cornerRadius = cornerRadius
        self.strokeColor = strokeColor
        self.fillColor = fillColor
        self.style = style
    }
    // let shape: PlotShape ? do we want to plot a symbol
    // - in the middle of the rect perhaps, or at the corner or edge?

    // var title: String { get } ?
}

public struct IndividualRule {
    let start: CGFloat
    let end: CGFloat
    let orientationVertical: Bool
    let style: SwiftUI.StrokeStyle // linewidth, cap, join, miter, dash, and dash-phase
}

// symbol - square, circle, diamond, cross - and insettable to mix
// text
// image
