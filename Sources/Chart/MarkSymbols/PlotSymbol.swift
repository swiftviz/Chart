//
//  PlotSymbol.swift
//  
//
//  Created by Joseph Heck on 4/28/22.
//

import SwiftUI

/// A type-erased shape used to plot individual symbols for a mark.
public struct PlotSymbol: Shape {
    var toPath: (CGRect) -> Path
    let fill: SwiftUI.Color // (https://developer.apple.com/documentation/swiftui/color)
    let stroke: SwiftUI.Color // ? (https://developer.apple.com/documentation/coregraphics/cgcolor)
    let style: SwiftUI.StrokeStyle

    /// Creates a PlotSymbol  from the shape you provide.
    /// - Parameter shape: The shape of the symbol.
    public init<T: Shape>(
        _ shape: T,
        fill: Color = Color.clear,
        stroke: Color = Color.black,
        style: StrokeStyle = StrokeStyle(lineWidth: 1)
    ) {
        toPath = shape.path(in:)
        self.fill = fill
        self.stroke = stroke
        self.style = style
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
        return toPath(rect).strokedPath(style)
    }

}
