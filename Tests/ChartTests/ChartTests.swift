import Chart
import XCTest
import SwiftUI

final class PublicChartTests: XCTestCase {
    func testTypeStubs() throws {
        let chart = Chart {
            EmptyView()
        }
        XCTAssertNotNil(chart)
    }
}
