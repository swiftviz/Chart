//
//  CGRectInset.swift
//

@testable import Chart
import SwiftUI
import XCTest

class CGRectInset: XCTestCase {
    let reference = CGRect(x: 0, y: 0, width: 100, height: 50)

    func testTooSmallUniformInset() throws {
        let insetRect = CGRect(x: 0, y: 0, width: 10, height: 10).inset(7)
        XCTAssertEqual(insetRect.size, .zero)
    }

    func testVariableInset() throws {
        let insetRect = reference.inset(leading: 10, top: 20, trailing: 5, bottom: 15)
        XCTAssertEqual(insetRect.origin.x, 10)
        XCTAssertEqual(insetRect.origin.y, 20)
        XCTAssertEqual(insetRect.size.width, 100 - 15)
        XCTAssertEqual(insetRect.size.height, 50 - 35)
    }

    func testTooSmallVariableInset() throws {
        let insetRect = reference.inset(leading: 60, top: 20, trailing: 50, bottom: 15)
        XCTAssertEqual(insetRect.origin.x, 60)
        XCTAssertEqual(insetRect.origin.y, 20)
        XCTAssertEqual(insetRect.size.width, 0)
        XCTAssertEqual(insetRect.size.height, 50 - 35)
    }
}
