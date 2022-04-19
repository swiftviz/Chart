import Chart
import SwiftUI
import XCTest

struct SampleData {
    let name: String
    let value: Int
}

 final class PublicChartTests: XCTestCase {
     struct SampleData {
         let name: String
         let value: Int
     }

    func testTypeStubs() throws {
        let chart = Chart {
//            BarMark(data: [SampleData(name: "X", value: 1)],
//                            value: QuantitativeVisualChannel(1),
//                            category: BandVisualChannel("Z"))
        }
        XCTAssertNotNil(chart)
    }
 }
