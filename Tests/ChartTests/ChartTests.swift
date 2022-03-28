import Chart
import SwiftUI
import XCTest

final class PublicChartTests: XCTestCase {
    func testTypeStubs() throws {
        let chart = Chart {
            EmptyView()
        }
        XCTAssertNotNil(chart)
    }
}
