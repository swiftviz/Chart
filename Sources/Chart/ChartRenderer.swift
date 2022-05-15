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

class ChartRenderer {
    func createView(_ specification: ChartSpec) -> some View {
        // init(opaque: Bool = false,
        //      colorMode: ColorRenderingMode = .nonLinear,
        //      rendersAsynchronously: Bool = false,
        //      renderer: @escaping (inout GraphicsContext, CGSize) -> Void,
        //      symbols: () -> Symbols
        // )
        Canvas { context, size in
            // pre-process the collection of marks provided to determine what, if any, axis
            // and margins need to be accounted for in rendering out the view.

            var xAxisList: [Axis] = []
            var yAxisList: [Axis] = []
            for mark in specification.marks {
                if let xAxis = mark.getXAxis() {
                    xAxisList.append(xAxis)
                }
                if let yAxis = mark.getYAxis() {
                    yAxisList.append(yAxis)
                }
            }

            let maxXAxisHeight: CGFloat = xAxisList.reduce(0.0) { partialResult, currentAxis in
                let tickLabels: [String] = currentAxis.scale.tickLabels(values: currentAxis.requestedTickValues)
                let maxResolvedLabelHeight = tickLabels.reduce(0.0) { partialResult, label in
                    let captionedTextSampleSize: CGSize = context.resolve(Text(label).font(.caption)).measure(in: size)
                    return max(captionedTextSampleSize.height, partialResult)
                }
                return max(partialResult, currentAxis.tickLength + currentAxis.tickPadding + maxResolvedLabelHeight)
            }
            print(maxXAxisHeight)

            let maxYAxisWidth: CGFloat = yAxisList.reduce(0.0) { partialResult, currentAxis in
                let tickLabels: [String] = currentAxis.scale.tickLabels(values: currentAxis.requestedTickValues)
                let maxResolvedLabelWidth = tickLabels.reduce(0.0) { partialResult, label in
                    let captionedTextSampleSize: CGSize = context.resolve(Text(label).font(.caption)).measure(in: size)
                    return max(captionedTextSampleSize.width, partialResult)
                }
                return max(partialResult, currentAxis.tickLength + currentAxis.tickPadding + maxResolvedLabelWidth)
            }
            print(maxYAxisWidth)

            // foreach Mark, get the (partial) axis configurations and generate the labels
            // using `func axisForMark(in: CGRect) -> [Axis]`, passing in a guesstimate CGRect
            // of the available space inset with the combination of 'margin' and 'inset' defined
            // in the ChartSpec.
            // In particular, we need to get the tick *values* so that we can calculate the maximum
            // width for Y-axis ticks, and maximum height for X-axis ticks - and that along with the
            // axis configuration (tick length, direction, label offset) can be used to compute
            // a real working size for the interior drawing area of the chart itself.
            // The value, in turn, can be used with `func axisForMark(in: CGRect) -> [Axis]`
            // to get the full tick values along with their location.

            // leaning into VisualPropertyScale method: `func tickLabels(values: [Double] = []) -> [String]`
            // and if the visual property is continuous, then it values the values as within the domain
            // of the underlying scale, then converts them into strings and returns the list of strings.
            // If no values are provided, or it's a discrete scale, then it returns the strings of the
            // tick values from the underlying scale.

            // walk the collection of marks (`AnyMark`)
            // - first determine any insets needed for axis defined within them (TBD)

            let fullDrawArea = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
            let drawArea: CGRect = fullDrawArea.inset(amount: 5) ?? fullDrawArea

            let captionedTextSampleSize: CGSize = context.resolve(Text("250").font(.caption)).measure(in: CGSize(width: 50, height: 50))
            print(captionedTextSampleSize.height)
            // - then calculate the marks for the provided drawing area

            for mark in specification.marks {
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
                        self.drawRect(bar: individualRect, context: &context)
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

    private func drawLine(line: IndividualLine, context: inout GraphicsContext) {
        let linePath = Path { p in
            p.move(to: line.startPoint)
            p.addLine(to: line.endPoint)
        }
        context.stroke(linePath, with: .color(line.strokeColor), style: line.style)
    }

    private func drawRect(bar: IndividualRect, context: inout GraphicsContext) {
        let rectPath = Path(bar.rect)
        switch bar.mode {
        case .stroke:
            context.stroke(rectPath, with: .color(bar.strokeColor), style: bar.style)
        case .fill:
            context.fill(rectPath, with: .color(bar.strokeColor))
        }
    }
}
