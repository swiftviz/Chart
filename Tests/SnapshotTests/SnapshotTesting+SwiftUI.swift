//
//  SnapshotTesting+SwiftUI.swift
//  SnapshotTestingSwiftUITests
//
//  Created by Vadim Bulavin on 4/28/20.
//  Copyright © 2020 Vadim Bulavin. All rights reserved.
//
// ref: https://www.vadimbulavin.com/snapshot-testing-swiftui-views/

import SnapshotTesting
import SwiftUI

#if os(iOS) || os(watchOS) || os(tvOS)
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

#endif
