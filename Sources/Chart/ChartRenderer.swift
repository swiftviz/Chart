//
//  ChartRenderer.swift
//
//
//  Created by Joseph Heck on 4/20/22.
//
import SwiftUI

extension CGRect {
    /// Returns a new CGRect with the values inset evenly by the value you provide.
    /// - Parameter amount: The amount to inset the edges of the rect.
    func inset(amount: CGFloat) -> CGRect? {
        if size.width <= amount * 2 || size.height <= amount * 2 {
            return nil
        }
        return CGRect(x: origin.x + amount,
                      y: origin.y + amount,
                      width: size.width - (2 * amount),
                      height: size.height - (2 * amount))
    }
}

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

            let fullDrawArea = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
            let drawArea: CGRect = fullDrawArea.inset(amount: 5) ?? fullDrawArea

            // - then calculate the marks for the provided drawing area

            for mark in marks {
//                print("Mark: \(mark)")
                // - and iterate through each of the individual symbols
                // - render them into the canvas based on the mode of the shape
                for marksymbol in mark.symbolsForMark(in: drawArea) {
                    switch marksymbol {
                    case let .point(individualPoint):
                        self.drawPoint(point: individualPoint, context: &context)
                    case let .line(individualLine):
                        self.drawLine(line: individualLine, context: &context)
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
        }
    }

    private func drawLine(line: IndividualLine, context: inout GraphicsContext) {
        let linePath = Path { p in
            p.move(to: line.startPoint)
            p.addLine(to: line.endPoint)
        }
        context.stroke(linePath, with: .color(line.strokeColor), style: line.style)
    }

    private func drawPoint(point: IndividualPoint, context: inout GraphicsContext) {
        // explicitly offset so the center of the shape is at the point.x, point.y location
        let origin = CGPoint(x: point.x - point.size.width / 2, y: point.y - point.size.height / 2)
        let symbolRect: CGRect = .init(origin: origin, size: point.size)
        switch point.shape.mode {
        case .stroke:
            context.stroke(
                point.shape.toPath(symbolRect),
                with: .color(point.shape.strokeColor),
                style: point.shape.style
            )
        case .fill:
            context.fill(
                point.shape.toPath(symbolRect),
                with: .color(point.shape.fillColor)
            )
        }
    }
}
