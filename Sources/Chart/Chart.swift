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
        markCollection = []
    }
}

class ChartRenderer {
    // pre-process the collection of marks provided to determine what, if any, axis
    // and margins need to be accounted for in rendering out the view.
    func createView(_: [MarkType]) -> some View {
        Canvas { context, size in
            context.stroke(
                Path(ellipseIn: CGRect(origin: .zero, size: size)),
                with: .color(.green),
                lineWidth: 4
            )
        }
    }
}
