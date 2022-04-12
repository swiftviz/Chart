//
//  MarkBuilder.swift
//
//
//  Created by Joseph Heck on 4/7/22.
//

import Foundation

// MARK: - collection access to different kinds of 'mark' templates

public enum MarkType {
    // holder for different kinds of marks so we can keep them in a single array as an ordered collection
    case bar(BarMark<Any>)
    case dot(DotMark<Any>)
    case line(LineMark<Any>)
}

// reference for result builders:
// https://docs.swift.org/swift-book/ReferenceManual/Attributes.html
// https://docs.swift.org/swift-book/LanguageGuide/AdvancedOperators.html#ID630

@resultBuilder
public enum MarkBuilder {
    
    static func buildExpression(_ element: BarMark<Any>) -> MarkType {
        return MarkType.bar(element)
    }
    
    static func buildExpression(_ element: DotMark<Any>) -> MarkType {
        return MarkType.dot(element)
    }
    
    static func buildExpression(_ element: LineMark<Any>) -> MarkType {
        return MarkType.line(element)
    }

    public static func buildBlock(_ components: MarkType...) -> [MarkType] {
        var marks: [MarkType] = []
        for mark in components {
            marks.append(mark)
        }
        return marks
    }
}
