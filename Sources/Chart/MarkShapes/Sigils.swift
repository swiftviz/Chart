import SwiftUI

public struct Line {
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
public struct Point {
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

public struct Bar {
    let category: String
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
