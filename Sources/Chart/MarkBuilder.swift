//
//  File.swift
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

@resultBuilder
public enum MarkBuilder {
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
