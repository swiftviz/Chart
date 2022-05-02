//
//  ChartRenderer.swift
//
//
//  Created by Joseph Heck on 4/20/22.
//
import SwiftUI

public class ChartRenderer {
    // pre-process the collection of marks provided to determine what, if any, axis
    // and margins need to be accounted for in rendering out the view.

    public func createView(_ marks: [AnyMark]) -> some View {
        // init(opaque: Bool = false,
        //      colorMode: ColorRenderingMode = .nonLinear,
        //      rendersAsynchronously: Bool = false,
        //      renderer: @escaping (inout GraphicsContext, CGSize) -> Void,
        //      symbols: () -> Symbols
        // )
        Canvas { context, size in
            // walk the collection of marks (`AnyMark`)
            // - first determine any insets needed for axis defined within them (TBD)

            // - then calculate the marks for the provided drawing area
            let drawArea = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
            for mark in marks {
                // - and iterate through each of the individual symbols
                // - render them into the canvas based on the mode of the shape
                for marksymbol in mark.symbolsForMark(in: drawArea) {
                    switch marksymbol {
                    case let .point(individualPoint):
                        let symbolRect: CGRect = .init(origin: CGPoint(x: individualPoint.x, y: individualPoint.y), size: individualPoint.size)
                        switch individualPoint.shape.mode {
                        case .stroke:
                            context.stroke(
                                individualPoint.shape.toPath(symbolRect),
                                with: .color(individualPoint.shape.strokeColor),
                                style: individualPoint.shape.style
                            )
                        case .fill:
                            context.fill(
                                individualPoint.shape.toPath(symbolRect),
                                with: .color(individualPoint.shape.fillColor)
                            )
                        }
                    case let .line(individualLine):
                        fatalError("not yet implemented: \(individualLine)")
                    case let .rect(individualRect):
                        fatalError("not yet implemented: \(individualRect)")
                    case let .rule(individualRule):
                        fatalError("not yet implemented: \(individualRule)")
                    case let .text(text):
                        fatalError("not yet implemented: \(text)")
                    case let .image(image):
                        fatalError("not yet implemented: \(image)")
                    }
                }
            }
//            context.stroke(
//                Path(ellipseIn: CGRect(origin: .zero, size: size)),
//                with: .color(.green),
//                lineWidth: 4
//            )
        }
    }
}
