//
//  TestSampleData.swift
//  

struct TestSampleData: Equatable, Hashable {
    let name: String
    let value: Int
    let xValue: Double
    let yValue: Double

    init(name: String = "", intValue: Int = 0, x: Double = 0.0, y: Double = 0.0) {
        self.name = name
        value = intValue
        xValue = x
        yValue = y
    }
}
