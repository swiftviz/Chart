//
//  EdgeInsets+extensions.swift
//

import SwiftUI

extension EdgeInsets {
    init(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) {
        var top: CGFloat = 0
        var leading: CGFloat = 0
        var bottom: CGFloat = 0
        var trailing: CGFloat = 0
        if edges.contains(.leading) {
            leading = length ?? 0
        }
        if edges.contains(.trailing) {
            trailing = length ?? 0
        }
        if edges.contains(.top) {
            top = length ?? 0
        }
        if edges.contains(.bottom) {
            bottom = length ?? 0
        }
        self.init(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }

    static func + (lhs: EdgeInsets, rhs: EdgeInsets) -> EdgeInsets {
        EdgeInsets(
            top: lhs.top + rhs.top,
            leading: lhs.leading + rhs.leading,
            bottom: lhs.bottom + rhs.bottom,
            trailing: lhs.trailing + rhs.trailing
        )
    }
}
