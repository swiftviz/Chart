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

    func inset(leading: CGFloat = 0, top: CGFloat = 0, trailing: CGFloat = 0, bottom: CGFloat = 0) -> CGRect {
        CGRect(x: origin.x + leading,
               y: origin.y + top,
               width: size.width - (leading + trailing),
               height: size.height - (top + bottom))
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

            var xAxisTopList: [Axis] = []
            var xAxisBottomList: [Axis] = []
            var yAxisLeadingList: [Axis] = []
            var yAxisTrailingList: [Axis] = []
            for mark in specification.marks {
                if let xAxis = mark._xAxis {
                    switch xAxis.axisLocation {
                    case .top:
                        xAxisTopList.append(xAxis)

                    default:
                        xAxisBottomList.append(xAxis)
                    }
                }
                if let yAxis = mark._yAxis {
                    switch yAxis.axisLocation {
                    case .trailing:
                        yAxisTrailingList.append(yAxis)

                    default:
                        yAxisLeadingList.append(yAxis)
                    }
                }
            }

            // get the maximum height of the set of Axis. In a perfect world, there would only
            // be one axis for which we need to calculate this, but the DSL result builder
            // mechanism doesn't allow for errors - so there's no easy way to provide feedback
            // that you've specified `.xAxis()` on two different marks - so we keep to the
            // pathological case and compute it assuming that _every_ mark has an X, and Y, axis
            // defined.
            let maxXAxisBottomHeight: CGFloat = xAxisBottomList.reduce(0.0) { partialResult, currentAxis in
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

            let maxXAxisTopHeight: CGFloat = xAxisTopList.reduce(0.0) { partialResult, currentAxis in
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

            let maxYAxisLeadingWidth: CGFloat = yAxisLeadingList.reduce(0.0) { partialResult, currentAxis in
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

            let maxYAxisTrailingWidth: CGFloat = yAxisTrailingList.reduce(0.0) { partialResult, currentAxis in
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

            let insetLeading = specification.margin.leading + maxYAxisLeadingWidth + specification.inset.leading
            let insetTrailing = specification.margin.trailing + maxYAxisTrailingWidth + specification.inset.trailing

            let insetTop = specification.margin.top + maxXAxisTopHeight + specification.inset.top
            let insetBottom = specification.margin.bottom + maxXAxisBottomHeight + specification.inset.bottom

            let chartDataDrawArea = CGRect(origin: CGPoint.zero, size: size)
                .inset(leading: insetLeading, top: insetTop, trailing: insetTrailing, bottom: insetBottom)

            // With the X axis height, and Y axis width, we can calculate a proper internal
            // CGRect that is the inset area into which we want to draw the marks, as well
            // as the locations into which we want to draw the X and Y axis, if they've been
            // specified.

            // The width of any X axis is determined by that internal size, as is the height
            // for any Y axis.

            // ?? How to draw the axis themselves - I have a rectangular area (or can calculate it
            // pretty quick - for each potential axis area.
            // leading - drawing from right side, trailing - drawing from left side,
            // bottom - drawing from top, top - drawing from bottom. So do I set up a method where
            // I hand in a rect into which to draw, and then pass that (origin + size) along with
            // the axis definition to a drawing method?

            if !xAxisTopList.isEmpty {
                // calculate top area rect and draw it
                let axisOrigin = CGPoint(x: specification.margin.leading + maxYAxisLeadingWidth + specification.inset.leading, y: specification.margin.top)
                let axisSize = CGSize(width: chartDataDrawArea.size.width, height: maxXAxisTopHeight)
                for topAxis in xAxisTopList {
                    self.drawAxis(axis: topAxis, within: CGRect(origin: axisOrigin, size: axisSize), context: &context)
                }
            }

            if !xAxisBottomList.isEmpty {
                // calculate bottom area rect and draw it
                let axisOrigin = CGPoint(x: specification.margin.leading + maxYAxisLeadingWidth + specification.inset.leading, y: size.height - (specification.margin.bottom + maxXAxisBottomHeight))
                let axisSize = CGSize(width: chartDataDrawArea.size.width, height: maxXAxisBottomHeight)
                for bottomAxis in xAxisBottomList {
                    self.drawAxis(axis: bottomAxis, within: CGRect(origin: axisOrigin, size: axisSize), context: &context)
                }
            }

            if !yAxisLeadingList.isEmpty {
                // calculate leading area rect and draw it
                let axisOrigin = CGPoint(x: specification.margin.leading, y: specification.margin.top + maxXAxisTopHeight + specification.inset.top)
                let axisSize = CGSize(width: maxYAxisLeadingWidth, height: chartDataDrawArea.size.height)
                for leadingAxis in yAxisLeadingList {
                    self.drawAxis(axis: leadingAxis, within: CGRect(origin: axisOrigin, size: axisSize), context: &context)
                }
            }

            if !yAxisTrailingList.isEmpty {
                // calculate trailing area rect and draw it
                let axisOrigin = CGPoint(x: size.width - (specification.margin.trailing + maxYAxisTrailingWidth), y: specification.margin.top + maxXAxisTopHeight + specification.inset.top)
                let axisSize = CGSize(width: maxYAxisTrailingWidth, height: chartDataDrawArea.size.height)
                for trailingAxis in yAxisTrailingList {
                    self.drawAxis(axis: trailingAxis, within: CGRect(origin: axisOrigin, size: axisSize), context: &context)
                }
            }

            // - then calculate the marks for the provided drawing area

            for mark in specification.marks {
                // print("Mark: \(mark)")
                // - and iterate through each of the individual symbols
                // - render them into the canvas based on the mode of the shape
                for marksymbol in mark.symbolsForMark(in: chartDataDrawArea) {
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

    private func drawAxis(axis _: Axis, within _: CGRect, context _: inout GraphicsContext) {}

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
