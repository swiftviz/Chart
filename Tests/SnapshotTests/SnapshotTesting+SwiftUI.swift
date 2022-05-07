//
//  SnapshotTesting+SwiftUI.swift
//  SnapshotTestingSwiftUITests

import SnapshotTesting
import SwiftUI

#if os(iOS) || os(watchOS) || os(tvOS)
    // The iOS version created by Vadim Bulavin on 4/28/20.
    // ref: https://www.vadimbulavin.com/snapshot-testing-swiftui-views/
    // Copyright © 2020 Vadim Bulavin. All rights reserved.
    extension Snapshotting where Value: SwiftUI.View, Format == UIImage {
        static func image(
            drawHierarchyInKeyWindow: Bool = false,
            precision: Float = 1,
            size: CGSize? = nil,
            traits: UITraitCollection = .init()
        ) -> Snapshotting {
            Snapshotting<UIViewController, UIImage>.image(
                drawHierarchyInKeyWindow: drawHierarchyInKeyWindow,
                precision: precision,
                size: size,
                traits: traits
            )
            .pullback(UIHostingController.init(rootView:))
        }
    }

#elseif os(macOS)
    // macOS variation of this same setup created by Joseph Heck, May 02, 2022,
    // inspired by Vadim's example and reference information from PointFreeCo's
    // Snapshot Testing library (https://github.com/pointfreeco/swift-snapshot-testing)
    extension Snapshotting where Value: SwiftUI.View, Format == NSImage {
        static func image(
            precision: Float = 1,
            size: CGSize? = nil
        ) -> Snapshotting {
            Snapshotting<NSViewController, NSImage>.image(
                precision: precision,
                size: size
            )
            .pullback(NSHostingController.init(rootView:))
        }
    }

#endif

let referenceSize = CGSize(width: 300, height: 200)

extension SwiftUI.View {
    func referenceFrame() -> some View {
        frame(width: referenceSize.width, height: referenceSize.height).ignoresSafeArea()
    }
}
