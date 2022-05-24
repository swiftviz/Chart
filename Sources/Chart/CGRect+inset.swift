//
//  File.swift
//
//
//  Created by Joseph Heck on 5/24/22.
//

import Foundation
#if canImport(CoreGraphics)
    import CoreGraphics
#endif

extension CGRect {
    /// Returns a new CGRect with the values inset evenly by the value you provide.
    /// - Parameter amount: The amount to inset the edges of the rect.
    func inset(_ amount: CGFloat) -> CGRect {
        insetBy(dx: amount, dy: amount)
    }

    func inset(leading: CGFloat = 0, top: CGFloat = 0, trailing: CGFloat = 0, bottom: CGFloat = 0) -> CGRect {
        let newWidth = max(size.width - (leading + trailing), 0)
        let newHeight = max(size.height - (top + bottom), 0)
        return CGRect(x: origin.x + leading,
                      y: origin.y + top,
                      width: newWidth,
                      height: newHeight)
    }
}
