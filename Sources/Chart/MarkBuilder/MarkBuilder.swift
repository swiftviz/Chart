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
    // DEV NOTE: all of these builder expressions need to be `public static func` - miss
    // the `public` part of it, and that excludes the function from being invoked during
    // the compilation process, resulting in odd type errors (which I learned the hard way).

    public static func buildExpression<T>(_ element: BarMark<T>) -> [AnyMark] {
        [AnyMark(element)]
    }

    public static func buildExpression<T>(_ element: DotMark<T>) -> [AnyMark] {
        [AnyMark(element)]
    }

    public static func buildExpression<T>(_ element: LineMark<T>) -> [AnyMark] {
        [AnyMark(element)]
    }

    public static func buildBlock(_ components: [AnyMark]...) -> [AnyMark] {
        Array(components.joined())
    }
}
