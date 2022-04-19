//
//  MarkBuilder.swift
//
//
//  Created by Joseph Heck on 4/7/22.
//

import Foundation

// MARK: - collection access to different kinds of 'mark' templates

// reference for result builders:
// https://docs.swift.org/swift-book/ReferenceManual/Attributes.html
// https://docs.swift.org/swift-book/LanguageGuide/AdvancedOperators.html#ID630

@resultBuilder
public enum MarkBuilder {
    static func buildExpression(_ element: BarMark<Any>) -> [AnyMark] {
        [AnyMark(element)]
    }

    static func buildExpression(_ element: DotMark<Any>) -> [AnyMark] {
        [AnyMark(element)]
    }

    static func buildExpression(_ element: LineMark<Any>) -> [AnyMark] {
        [AnyMark(element)]
    }

    public static func buildBlock(_ components: [AnyMark]...) -> [AnyMark] {
        Array(components.joined())
    }
}
