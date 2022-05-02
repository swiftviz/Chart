//
//  PlotSymbol.swift
//
//
//  Created by Joseph Heck on 4/28/22.
//

import SwiftUI

/// A type-erased shape used to plot individual symbols for a mark.
public struct PlotShape: Shape {
    // use our own enumeration, or leverage ShapeRole from SwiftUI (avail iOS 15/macOS 12)
    // ShapeRole. ShapeRole also has stroke and fill, but also includes `separator` without
    // a lot of detail of what that means. And there's nothing that explicitly says `do both`.
//    public enum DrawingMode {
//        case stroke
//        case fill
//        case both
//    }
    // shape's `role` seems to imply either stroked or filled, but not often both. I'm not sure
    // what 'separator' means in terms of role, and how SwiftUI interprets that.
    let mode: ShapeRole

    var toPath: (CGRect) -> Path
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
        fillColor: Color = Color.clear,
        strokeColor: Color = Color.black,
        style: StrokeStyle = StrokeStyle(lineWidth: 1),
        mode: ShapeRole = .fill
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
