//
//  48.swift
//  https://github.com/swiftviz/Chart/issues/48
//

import Chart
import SnapshotTesting
import SwiftUI
import XCTest

final class Issue48Tests: XCTestCase {
    #if os(macOS)
        func testIssue48() throws {
            let chart = Chart(_options: [.all]) {
                PointMark(data: SFTemps.provideData(), x: QuantitativeVisualChannel(\SFTemps.high), y: QuantitativeVisualChannel(\SFTemps.low))
                    .xAxis()
                    .yAxis()
            }
            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }
    #endif
}
