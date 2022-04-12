//
//  Chart.swift
//
//
//  Created by Joseph Heck on 3/25/22.
//

import SwiftUI

public struct Chart<Content: View>: View {
    var chartRenderer = ChartRenderer()
    var markCollection: [MarkType]

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
        chartRenderer.createView(markCollection)
    }

    // classic 'container view' structure
//    var content: () -> Content
//    some View {
//        content()
//        // if Mark returns a view, then we'll likely assemble these
//        // as a ZStack, otherwise we'll need to update the generic signature
//        // to accept a list of [Mark] instances that we compose directly
//        // onto an instance of Canvas()
//    }

//    public init(@ViewBuilder _ content: @escaping () -> Content) {
//        self.content = content
//    }

    public init(@MarkBuilder _ markdecl: @escaping () -> [MarkType]) {
        // somehow convert markdecl into the MarkCollection...
        markCollection = markdecl()
    }
}

class ChartRenderer {
    // pre-process the collection of marks provided to determine what, if any, axis
    // and margins need to be accounted for in rendering out the view.
    func createView(_: [MarkType]) -> some View {
        Canvas { context, size in
            // walk the collection of marks
            // - first determine any insets needed for axis defined within them
            // - then iterate through the whole set, provide the range available, and get
            //   the marks (symbolsForMark), which in turns needs to pass through or use
            //   the range provided with the visualChannel's internal scale to get the
            //   explicit values from the data.
            context.stroke(
                Path(ellipseIn: CGRect(origin: .zero, size: size)),
                with: .color(.green),
                lineWidth: 4
            )
        }
    }
}
