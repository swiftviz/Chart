//
//  Mark.swift
//  
//
//  Created by Joseph Heck on 3/25/22.
//
import SwiftUI

/// A type that represents one or more visual symbols displays in a chart.
///
/// A mark describes the configuration of how data is mapped to visual properties relevant to the type of mark.
public protocol Mark {
    // let mappings: [VisualChannel]
    // let visibleAxis: [AxisDefn]

    
    var fill: Color { get }
    var stroke: Color { get }
    var title: String { get }
}

// MARK: - default values for common Mark properties

public extension Mark {
    var fill: Color {
        return Color.black
    }

    var stroke: Color {
        return Color.black
    }

    var title: String {
        return ""
    }
}

// MARK: MarkBuilder

@resultBuilder
struct MarkBuilder<MarkType: Mark> {
    static func buildBlock(_ components: AnyVisualChannel<MarkType, Any>...) -> [AnyVisualChannel<MarkType, Any>]  {
        return []
    }
}
