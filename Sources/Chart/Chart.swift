//
//  Chart.swift
//

import SwiftUI

public struct Chart: View {
    var chartRenderer = ChartRenderer()
    var specCollection: ChartSpec

    /* execution flow notes:

     Chart is initialized and creating within an enclosing ViewBuilder somewhere
     with the end goal of providing a view that shows the declared chart. As a starting
     point, there's no passed-in parameters to Chart - only a trailing closure which
     covers the declaration of what's inside the chart - a series of Mark's.

     The initialization of the marks needs to build up and store everything needed to
     allow a renderer to return a view - the idea being a `ChartRenderer` class that
     has the method `createView` that accepts a collection of the marks declared, and
     returns an instance conforming to a SwiftUI View.

     The trailing closure provided to the Chart initializer needs to get invoked - probably as
     a part of the initialization process, that builds up and stores the list of marks for the
     renderer to use.

     The domain (the array of values to be processed) is known within the MarkBuilder - the data
     to be used with each Mark is passed to it during its initialization. So it's inside the Mark
     building process that we'll be able to learn and set domains for any internal scales, which in
     turn defines values for any displayed Axis and labels, legend, etc.

     The *range*, however, isn't known until the renderer starts to do its work - in particular when
     the size available to the canvas is provided within a closure. That's where the the values from the marks
     can be transformed into explicit values that align on the canvas, and the relevant shapes drawn.
     As a result, the marks will need to carry along the declared scales and make them available,
     referenced to each relevant property, so that the range can be applied to them and they in turn used
     to get the final property values.

     */

    public var body: some View {
        chartRenderer.createView(specCollection)
    }

    @_disfavoredOverload
    public init(margin: EdgeInsets = EdgeInsets(),
                inset: EdgeInsets = EdgeInsets(),
                @ChartBuilder _ chartDecl: @escaping () -> ChartSpec)
    {
        // invoke the closure to get the declared sets of marks as a list of AnyMark
        // that we can pass into the renderer to evaluate into individual symbols.
        specCollection = chartDecl()
        specCollection.margin = margin
        specCollection.inset = inset
    }

    public init(margin: CGFloat = 0,
                inset: CGFloat = 0,
                @ChartBuilder _ chartDecl: @escaping () -> ChartSpec)
    {
        // invoke the closure to get the declared sets of marks as a list of AnyMark
        // that we can pass into the renderer to evaluate into individual symbols.
        specCollection = chartDecl()
        specCollection.margin = EdgeInsets(.all, margin)
        specCollection.inset = EdgeInsets(.all, inset)
    }

    // MARK: - Modifiers for chart

    public func margin(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> some View {
        Chart(margin: EdgeInsets(edges, length), inset: specCollection.inset) {
            specCollection
        }
    }

    public func inset(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> some View {
        Chart(margin: specCollection.margin, inset: EdgeInsets(edges, length)) {
            specCollection
        }
    }
}

extension EdgeInsets {
    init(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) {
        var top: CGFloat = 0
        var leading: CGFloat = 0
        var bottom: CGFloat = 0
        var trailing: CGFloat = 0
        if edges.contains(.leading) {
            leading = length ?? 0
        }
        if edges.contains(.trailing) {
            trailing = length ?? 0
        }
        if edges.contains(.top) {
            top = length ?? 0
        }
        if edges.contains(.bottom) {
            bottom = length ?? 0
        }
        self.init(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }

    init(_ length: CGFloat? = nil) {
        let value: CGFloat = length ?? 0
        self.init(top: value, leading: value, bottom: value, trailing: value)
    }
}
