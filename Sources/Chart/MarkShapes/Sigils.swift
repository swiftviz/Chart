import SwiftUI

public enum MarkSymbol {
    case point(IndividualPoint)
    case line(IndividualLine)
    case rect(IndividualRect)
    case rule(IndividualRule)
    case text(Text)
    case image(Image)
}

/// A type that represents an individual data point symbol for a mark can render itself into a graphics context.
protocol RenderableSymbol {
    func render(mark: MarkSymbol, in context: inout GraphicsContext)
}

// Do we separate out data and rendering, or include the rendering capability into
// the individual data mark kind of thing?

public struct IndividualLine {
    let x1: CGFloat
    let y1: CGFloat

    let x2: CGFloat
    let y2: CGFloat

    let fill: SwiftUI.Color // (https://developer.apple.com/documentation/swiftui/color)
    let stroke: SwiftUI.Color // ? (https://developer.apple.com/documentation/coregraphics/cgcolor)
    let shape: CGPath
    // var title: String { get } ?
    let style: SwiftUI.StrokeStyle
}

// ?? make generic versions of this that can draw their "shape" into the space provided?
public struct IndividualPoint {
    let x: CGFloat
    let y: CGFloat

    let fill: SwiftUI.Color // (https://developer.apple.com/documentation/swiftui/color)
    let stroke: SwiftUI.Color // ? (https://developer.apple.com/documentation/coregraphics/cgcolor)
    let shape: CGPath
    // var title: String { get } ?
    let style: SwiftUI.StrokeStyle
    // maybe use/infer from https://developer.apple.com/documentation/swiftui/strokestyle
    // - lineWidth: CGFloat
    // - lineCap: CGLineCap (https://developer.apple.com/documentation/coregraphics/cglinecap)
    // - lineJoin: CGLineJoin (https://developer.apple.com/documentation/coregraphics/cglinejoin)
    // - miterLimit: CGFloat
    // - dash: [CGFloat]
    // - dashPhase: CGFloat

    // in SwiftUI, a Shape (derives from View) has:
    // - typeAlias Body -> from View
    // - typeAlias AnimatableData -> from Animatable
    //
    // but the real meat is:
    // - func path(in: CGRect) -> Path
    // I don't see a direct way to re-use SwiftUI Shape classes, but maybe there's something
    //
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

    let fill: SwiftUI.Color // (https://developer.apple.com/documentation/swiftui/color)
    let stroke: SwiftUI.Color // ? (https://developer.apple.com/documentation/coregraphics/cgcolor)
    let shape: CGPath
    // var title: String { get } ?
    let style: SwiftUI.StrokeStyle
}

public struct IndividualRule {
    let start: CGFloat
    let end: CGFloat
    let orientationVertical: Bool
}

// rule
// symbol - square, circle, diamond, cross - and insettable to mix
// text
// image
