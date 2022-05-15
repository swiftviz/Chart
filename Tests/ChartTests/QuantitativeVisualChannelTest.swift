//
//  VisualChannelTest.swift
//

@testable import Chart
import XCTest

class QuantitativeVisualChannelTest: XCTestCase {
    struct SampleData {
        let name: String
        let value: Int
        let xValue: Double
        let yValue: Double

        init(_ name: String, _ intValue: Int, _ x: Double, _ y: Double) {
            self.name = name
            value = intValue
            xValue = x
            yValue = y
        }
    }

    let data = SampleData("X", 3, Double.pi, 5.0)

    // MARK: - initializer tests

    func testQuantitativeChannelConstantIntInitializer() throws {
        let constantChannel = QuantitativeVisualChannel<SampleData>(32)
        XCTAssertNotNil(constantChannel)
        XCTAssertEqual(constantChannel.valueProvider(data), 32)
    }

    func testQuantitativeChannelConstantDoubleInitializer() throws {
        let constantChannel = QuantitativeVisualChannel<SampleData>(5.5)
        XCTAssertNotNil(constantChannel)
        XCTAssertEqual(constantChannel.valueProvider(data), 5.5)
    }

    func testQuantitativeChannelKeypathIntInitializer() throws {
        let intChannel = QuantitativeVisualChannel<SampleData>(\.value)
        XCTAssertNotNil(intChannel)
        XCTAssertEqual(intChannel.valueProvider(data), 3)
    }

    func testQuantitativeChannelKeypathDoubleInitializer() throws {
        let doubleChannel = QuantitativeVisualChannel<SampleData>(\.xValue)
        XCTAssertNotNil(doubleChannel)
        XCTAssertEqual(doubleChannel.valueProvider(data), data.xValue)
    }

    func testQuantitativeChannelClosureInitializer() throws {
        let channel = QuantitativeVisualChannel<SampleData> { incoming in
            incoming.xValue + incoming.yValue
        }
        XCTAssertNotNil(channel)
        XCTAssertEqual(channel.valueProvider(data), data.xValue + data.yValue)
    }

    // MARK: - configure and provide data

    func testQuantitativeChannelConstantIntDomainAndScale() throws {
        let channel = QuantitativeVisualChannel<SampleData>(32)
        let configured = channel.applyDomain([data])
        print(configured.scale.domainLower)
        print(configured.scale.domainHigher)
        XCTAssertEqual(configured.scaledValue(data: data, rangeLower: 0, rangeHigher: 50), 32)
    }

    func testQuantitativeChannelConstantDoubleDomainAndScale() throws {
        let channel = QuantitativeVisualChannel<SampleData>(5.5)
        let configured = channel.applyDomain([data])
        print(configured.scale.domainLower)
        print(configured.scale.domainHigher)
        XCTAssertEqual(configured.scaledValue(data: data, rangeLower: 0, rangeHigher: 10), 5.5)
    }

    func testQuantitativeChannelKeypathIntDomainAndScale() throws {
        let channel = QuantitativeVisualChannel<SampleData>(\.value)
        let configured = channel.applyDomain([data])
        print(configured.scale.domainLower)
        print(configured.scale.domainHigher)
    }

    func testQuantitativeChannelKeypathDoubleDomainAndScale() throws {
        let channel = QuantitativeVisualChannel<SampleData>(\.xValue)
        let configured = channel.applyDomain([data])
        print(configured.scale.domainLower)
        print(configured.scale.domainHigher)
    }

    func testQuantitativeChannelClosureDomainAndScale() throws {
        let channel = QuantitativeVisualChannel<SampleData> { incoming in
            incoming.xValue + incoming.yValue
        }
        let configured = channel.applyDomain([data])
        print(configured.scale.domainLower)
        print(configured.scale.domainHigher)
    }
}
