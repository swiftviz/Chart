//
//  ChartRenderer.swift
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

            // create a list of axis specs that have been defined on the marks

            // TODO(heckj): need to break this up even further - there could be an X axis on top and bottom
            // and a Y axis on leading and trailing. Should be 4 lists, not 2.
            var xAxisList: [Axis] = []
            var yAxisList: [Axis] = []
            for mark in specification.marks {
                if let xAxis = mark._xAxis {
                    xAxisList.append(xAxis)
                }
                if let yAxis = mark._yAxis {
                    yAxisList.append(yAxis)
                }
            }

            // get the maximum height of the set of Axis. In a perfect world, there would only
            // be one axis for which we need to calculate this, but the DSL result builder
            // mechanism doesn't allow for errors - so there's no easy way to provide feedback
            // that you've specified `.xAxis()` on two different marks - so we keep to the
            // pathological case and compute it assuming that _every_ mark has an X, and Y, axis
            // defined.
            let maxXAxisHeight: CGFloat = xAxisList.reduce(0.0) { partialResult, currentAxis in
                // for the current axis, get the labels for the ticks that are associated
                // with the scale for that axis.
                let tickLabels: [String] = currentAxis.scale.tickLabels(values: currentAxis.requestedTickValues)
                // from the labels, resolve a Text() field in the current GraphicsContext
                // so that we can get the label's size. Right now this is presuming that the
                // font of the tick label is using `.caption`. Once we have the CGSize sets,
                // reduce that into a single (max) height value.
                let maxResolvedLabelHeight = tickLabels.reduce(0.0) { partialResult, label in
                    let captionedTextSampleSize: CGSize = context.resolve(Text(label).font(.caption)).measure(in: size)
                    return max(captionedTextSampleSize.height, partialResult)
                }
                // use the tick length, padding, and the max label height to determine a maximum
                // axis height
                return max(partialResult, currentAxis.tickLength + currentAxis.tickPadding + maxResolvedLabelHeight)
            }
//            print(maxXAxisHeight)

            let maxYAxisWidth: CGFloat = yAxisList.reduce(0.0) { partialResult, currentAxis in
                // for the current axis, get the labels for the ticks that are associated
                // with the scale for that axis.
                let tickLabels: [String] = currentAxis.scale.tickLabels(values: currentAxis.requestedTickValues)
                // from the labels, resolve a Text() field in the current GraphicsContext
                // so that we can get the label's size. Right now this is presuming that the
                // font of the tick label is using `.caption`. Once we have the CGSize sets,
                // reduce that into a single (max) width value.
                let maxResolvedLabelWidth = tickLabels.reduce(0.0) { partialResult, label in
                    let captionedTextSampleSize: CGSize = context.resolve(Text(label).font(.caption)).measure(in: size)
                    return max(captionedTextSampleSize.width, partialResult)
                }
                // use the tick length, padding, and the max label width to determine a maximum
                // axis width
                return max(partialResult, currentAxis.tickLength + currentAxis.tickPadding + maxResolvedLabelWidth)
            }
//            print(maxYAxisWidth)

            // With the X axis height, and Y axis width, we can calculate a proper internal
            // CGRect that is the inset area into which we want to draw the marks, as well
            // as the locations into which we want to draw the X and Y axis, if they've been
            // specified.

            // The width of any X axis is determined by that internal size, as is the height
            // for any Y axis.

            let fullDrawArea = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
            let drawArea: CGRect = fullDrawArea.inset(amount: 5) ?? fullDrawArea

            // - then calculate the marks for the provided drawing area

            for mark in specification.marks {
                // print("Mark: \(mark)")
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
