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
        self.markCollection = []
    }
}

class ChartRenderer {
    
    // pre-process the collection of marks provided to determine what, if any, axis
    // and margins need to be accounted for in rendering out the view.
    func createView(_ marks: [MarkType]) -> some View {
        Canvas { context, size in
                context.stroke(
                    Path(ellipseIn: CGRect(origin: .zero, size: size)),
                    with: .color(.green),
                    lineWidth: 4)
        }
    }
}

// MARK: - collection access to different kinds of 'mark' templates

public enum MarkType {
    // holder for different kinds of marks so we can keep them in a single array as an ordered collection
    case bar(BarMark<Any>)
    case dot(DotMark<Any>)
    case line(LineMark<Any>)
}

@resultBuilder
public struct MarkBuilder {
    public static func buildBlock(_ components: BarMark<Any>...) -> [MarkType] {
        var marks: [MarkType] = []
        for bar in components {
            marks.append(MarkType.bar(bar))
        }
        return marks
    }
    public static func buildBlock(_ components: DotMark<Any>...) -> [MarkType] {
        var marks: [MarkType] = []
        for dot in components {
            marks.append(MarkType.dot(dot))
        }
        return marks
    }
    public static func buildBlock(_ components: LineMark<Any>...) -> [MarkType] {
        var marks: [MarkType] = []
        for line in components {
            marks.append(MarkType.line(line))
        }
        return marks
    }

}
