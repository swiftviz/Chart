//
//  Mark.swift
//  
//
//  Created by Joseph Heck on 3/25/22.
//
import SwiftUI

public protocol Mark {
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
