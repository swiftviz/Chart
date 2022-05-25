//
//  ChartRenderer.swift
//

import SwiftUI

public struct DebugRendering: OptionSet {
    public let rawValue: Int

    public static let frame = DebugRendering(rawValue: 1 << 0)
    public static let axis = DebugRendering(rawValue: 1 << 1)
    public static let chartarea = DebugRendering(rawValue: 1 << 2)
    // static let standard    = DebugRendering(rawValue: 1 << 3)

    public static let all: DebugRendering = [.frame, .axis, .chartarea]

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

class ChartRenderer {
    func createView(_ specification: ChartSpec, opts: DebugRendering = []) -> some View {
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

            let axisCollection = specification.compileAxis()

            // get the maximum height of the set of Axis. In a perfect world, there would only
            // be one axis for which we need to calculate this, but the DSL result builder
            // mechanism doesn't allow for errors - so there's no easy way to provide feedback
            // that you've specified `.xAxis()` on two different marks - so we keep to the
            // pathological case and compute it assuming that _every_ mark has an X, and Y, axis
            // defined.
            let maxXAxisBottomHeight = self.heightFromListOfAxis(axisCollection.xAxisBottomList, with: context, size: size)
            let maxXAxisTopHeight = self.heightFromListOfAxis(axisCollection.xAxisTopList, with: context, size: size)
            let maxYAxisLeadingWidth = self.widthFromListOfAxis(axisCollection.yAxisLeadingList, with: context, size: size)
            let maxYAxisTrailingWidth = self.widthFromListOfAxis(axisCollection.yAxisTrailingList, with: context, size: size)

            let insetLeading = specification.margin.leading + maxYAxisLeadingWidth + specification.inset.leading
            let insetTrailing = specification.margin.trailing + maxYAxisTrailingWidth + specification.inset.trailing

            let insetTop = specification.margin.top + maxXAxisTopHeight + specification.inset.top
            let insetBottom = specification.margin.bottom + maxXAxisBottomHeight + specification.inset.bottom

            if opts.contains(.frame) {
                self.frameArea(CGRect(origin: CGPoint.zero, size: size), context: &context)
            }
            // With the X axis height, and Y axis width, we can calculate a proper internal
            // CGRect that is the inset area into which we want to draw the marks.
            let chartDataDrawArea = CGRect(origin: CGPoint.zero, size: size)
                .inset(leading: insetLeading, top: insetTop, trailing: insetTrailing, bottom: insetBottom)

            if opts.contains(.chartarea) {
                self.chartArea(chartDataDrawArea, context: &context)
            }
            // The size calculation also plays into describing the rectangles for drawing the axis.
            // The width of any X axis is determined by that internal size, as is the height
            // for any Y axis.

            if !axisCollection.xAxisTopList.isEmpty {
                // calculate area rect for top axis and draw it
                let axisOrigin = CGPoint(x: specification.margin.leading + maxYAxisLeadingWidth + specification.inset.leading, y: specification.margin.top)
                let axisSize = CGSize(width: chartDataDrawArea.size.width, height: maxXAxisTopHeight)
                for topAxis in axisCollection.xAxisTopList {
                    if opts.contains(.axis) {
                        self.fillArea(CGRect(origin: axisOrigin, size: axisSize), context: &context)
                    }
                    self.drawAxis(axis: topAxis, within: CGRect(origin: axisOrigin, size: axisSize), context: &context)
                }
            }

            if !axisCollection.xAxisBottomList.isEmpty {
                // calculate area rect for bottom axis and draw it
                let axisOrigin = CGPoint(x: specification.margin.leading + maxYAxisLeadingWidth + specification.inset.leading, y: size.height - (specification.margin.bottom + maxXAxisBottomHeight))
                let axisSize = CGSize(width: chartDataDrawArea.size.width, height: maxXAxisBottomHeight)
                for bottomAxis in axisCollection.xAxisBottomList {
                    if opts.contains(.axis) {
                        self.fillArea(CGRect(origin: axisOrigin, size: axisSize), context: &context)
                    }

                    self.drawAxis(axis: bottomAxis, within: CGRect(origin: axisOrigin, size: axisSize), context: &context)
                }
            }

            if !axisCollection.yAxisLeadingList.isEmpty {
                // calculate leading area rect and draw it
                let axisOrigin = CGPoint(x: specification.margin.leading, y: specification.margin.top + maxXAxisTopHeight + specification.inset.top)
                let axisSize = CGSize(width: maxYAxisLeadingWidth, height: chartDataDrawArea.size.height)
                for leadingAxis in axisCollection.yAxisLeadingList {
                    if opts.contains(.axis) {
                        self.fillArea(CGRect(origin: axisOrigin, size: axisSize), context: &context)
                    }

                    self.drawAxis(axis: leadingAxis, within: CGRect(origin: axisOrigin, size: axisSize), context: &context)
                }
            }

            if !axisCollection.yAxisTrailingList.isEmpty {
                // calculate trailing area rect and draw it
                let axisOrigin = CGPoint(x: size.width - (specification.margin.trailing + maxYAxisTrailingWidth), y: specification.margin.top + maxXAxisTopHeight + specification.inset.top)
                let axisSize = CGSize(width: maxYAxisTrailingWidth, height: chartDataDrawArea.size.height)
                for trailingAxis in axisCollection.yAxisTrailingList {
                    if opts.contains(.axis) {
                        self.fillArea(CGRect(origin: axisOrigin, size: axisSize), context: &context)
                    }

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

    // MARK: - internal calculations using GraphicsContext

    internal func heightFromListOfAxis(_ axisList: [Axis], with context: GraphicsContext, size: CGSize) -> CGFloat {
        axisList.reduce(0.0) { partialResult, currentAxis in
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
    }

    internal func widthFromListOfAxis(_ axisList: [Axis], with context: GraphicsContext, size: CGSize) -> CGFloat {
        axisList.reduce(0.0) { partialResult, currentAxis in
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
    }

    // MARK: - debug rendering methods

    private func frameArea(_ rect: CGRect, context: inout GraphicsContext) {
        let lightgrey = GraphicsContext.Shading.color(.sRGB, red: 0.2, green: 0.2, blue: 0.2, opacity: 0.1)
        context.fill(Path(rect), with: lightgrey)
    }

    private func chartArea(_ rect: CGRect, context: inout GraphicsContext) {
        let yeller = GraphicsContext.Shading.color(.sRGB, red: 0.9, green: 0.9, blue: 0.4, opacity: 0.2)
        context.fill(Path(rect), with: yeller)
    }

    private func fillArea(_ rect: CGRect, context: inout GraphicsContext) {
        let paleblue = GraphicsContext.Shading.color(.sRGB, red: 0.05, green: 0.1, blue: 0.8, opacity: 0.3)
        context.fill(Path(rect), with: paleblue)
    }

    // MARK: - drawing methods

    private func drawAxis(axis: Axis, within rect: CGRect, context: inout GraphicsContext) {
        let ruleStart: CGPoint
        let ruleEnd: CGPoint
        switch axis.axisLocation {
        case .leading:
            ruleStart = CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y)
            ruleEnd = CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height)
        case .top:
            ruleStart = CGPoint(x: rect.origin.x, y: rect.origin.y + rect.size.height)
            ruleEnd = CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height)
        case .bottom:
            ruleStart = CGPoint(x: rect.origin.x, y: rect.origin.y)
            ruleEnd = CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y)
        case .trailing:
            ruleStart = CGPoint(x: rect.origin.x, y: rect.origin.y)
            ruleEnd = CGPoint(x: rect.origin.x, y: rect.origin.y + rect.size.height)
        }
        if axis.rule {
            let linePath = Path { p in
                p.move(to: ruleStart)
                p.addLine(to: ruleEnd)
            }
            let ruleStyle = StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round, miterLimit: 1)
            context.stroke(linePath, with: .color(.primary), style: ruleStyle)
        }

        for aTick in axis.ticks {
            let tickStart: CGPoint
            let tickEnd: CGPoint
            switch (axis.axisLocation, axis.tickOrientation) {
            case (.leading, .inner):
                tickStart = CGPoint(x: ruleStart.x, y: aTick.rangeLocation)
                tickEnd = CGPoint(x: ruleStart.x + axis.tickLength, y: aTick.rangeLocation)
            case (.leading, .outer):
                tickStart = CGPoint(x: ruleStart.x, y: aTick.rangeLocation)
                tickEnd = CGPoint(x: ruleStart.x - axis.tickLength, y: aTick.rangeLocation)
            case (.top, .inner):
                tickStart = CGPoint(x: aTick.rangeLocation, y: ruleStart.y)
                tickEnd = CGPoint(x: aTick.rangeLocation, y: ruleStart.y + axis.tickLength)
            case (.top, .outer):
                tickStart = CGPoint(x: aTick.rangeLocation, y: ruleStart.y)
                tickEnd = CGPoint(x: aTick.rangeLocation, y: ruleStart.y - axis.tickLength)
            case (.bottom, .inner):
                tickStart = CGPoint(x: aTick.rangeLocation, y: ruleStart.y)
                tickEnd = CGPoint(x: aTick.rangeLocation, y: ruleStart.y - axis.tickLength)
            case (.bottom, .outer):
                tickStart = CGPoint(x: aTick.rangeLocation, y: ruleStart.y)
                tickEnd = CGPoint(x: aTick.rangeLocation, y: ruleStart.y + axis.tickLength)
            case (.trailing, .inner):
                tickStart = CGPoint(x: ruleStart.x, y: aTick.rangeLocation)
                tickEnd = CGPoint(x: ruleStart.x - axis.tickLength, y: aTick.rangeLocation)
            case (.trailing, .outer):
                tickStart = CGPoint(x: ruleStart.x, y: aTick.rangeLocation)
                tickEnd = CGPoint(x: ruleStart.x + axis.tickLength, y: aTick.rangeLocation)
            }

            let tickStyle = StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round, miterLimit: 1)
            let tickPath = Path { p in
                p.move(to: tickStart)
                p.addLine(to: tickEnd)
            }
            context.stroke(tickPath, with: .color(.primary), style: tickStyle)
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
