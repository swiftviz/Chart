//
//  PlotSymbol.swift
//

import SwiftUI

/// A type that determines how the path that makes up the plot shape is rendered.
public enum DrawingMode: Sendable {
    /// The path is drawn as a stroked line.
    case stroke
    /// The path is filled.
    case fill
}

/// A type-erased shape used to plot individual symbols for a mark.
public struct PlotShape: Shape {
    /// The mode use to render the path returned by the shape.
    let mode: DrawingMode

    var toPath: @Sendable (CGRect) -> Path
    // fillShading instead of fillColor? (https://developer.apple.com/documentation/swiftui/graphicscontext/shading)
    let fillColor: SwiftUI.Color // (https://developer.apple.com/documentation/swiftui/color)
    // strokeShading instead of strokeColor?
    let strokeColor: SwiftUI.Color // ? (https://developer.apple.com/documentation/coregraphics/cgcolor)
    let style: SwiftUI.StrokeStyle // linewidth, cap, join, miter, dash, and dash-phase

    // ?? Should this be an insettable-shape instead? Or in addition? Do I want or need to inset these shapes inside another?
    // base shapes available:
    // - Circle, Rectangle, Ellipse, Capsule, RoundedRectangle

    /// Creates a PlotSymbol  from the shape you provide.
    /// - Parameter shape: The shape of the symbol.
    public init<T: Shape>(
        _ shape: T,
        fillColor: Color = Color.primary,
        strokeColor: Color = Color.primary,
        style: StrokeStyle = StrokeStyle(lineWidth: 1),
        mode: DrawingMode = .fill
    ) {
        toPath = shape.path(in:)
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.style = style
        self.mode = mode
    }

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

    public func path(in rect: CGRect) -> Path {
        // return path based on role?
        toPath(rect)
    }
}
