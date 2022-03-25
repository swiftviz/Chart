//
//  Mark.swift
//  
//
//  Created by Joseph Heck on 3/25/22.
//
import SwiftUI

public protocol Mark {
//    var x: CGFloat { get } // mapping for data -> X value for the mark
//    var y: CGFloat { get }
    
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
struct MarkBuilder {
    static func buildBlock(_ components: VisualChannel<<#InstanceType: TypeOfVisualProperty#>>...) -> [VisualChannel<<#InstanceType: TypeOfVisualProperty#>>]  {
        return []
    }
    
}
