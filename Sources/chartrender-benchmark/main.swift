//
//  main.swift - chartrender-benchmark
//
import Benchmark
import Chart
import CodableCSV
import SwiftUI

// BENCHMARK=1 swift build -c release && .build/release/chartrender-benchmark --iterations 1000 --time-unit ms

let referenceSize = CGSize(width: 300, height: 200)

extension SwiftUI.View {
    func referenceFrame() -> some View {
        frame(width: referenceSize.width, height: referenceSize.height).ignoresSafeArea()
    }
}

let athleteDecoder = CSVDecoder {
    $0.headerStrategy = .firstLine
    $0.dateStrategy = .formatted(Athletes.dateformatter)
}

let athlete_data = try athleteDecoder.decode([Athletes].self, from: Athletes.url)
// print("Loaded \(athlete_data.count) rows from \(Athletes.url)")

let tempDecoder = CSVDecoder {
    $0.headerStrategy = .firstLine
    $0.dateStrategy = .formatted(SFTemps.dateformatter)
}

let temp_data = try tempDecoder.decode([SFTemps].self, from: SFTemps.url)
// print("Loaded \(temp_data.count) rows from \(SFTemps.url)")

struct SampleData {
    let name: String
    let value: Double
    let value2: Double

    init(name: String, value: Double, _ value2: Double = 0.0) {
        self.name = name
        self.value = value
        self.value2 = value2
    }
}

// guard let fileUrl = Bundle.main.url(forResource: "athletes", withExtension: "csv") else { fatalError() }
// let tabdata = try DataFrame(contentsOfCSVFile: fileUrl)
//
// print("tabdata is \(tabdata)")
// for something in tabdata.rows {
//    print(something)
// }

let smallData: [SampleData] = [
    SampleData(name: "A", value: 3),
    SampleData(name: "B", value: 5),
    SampleData(name: "C", value: 2),
    SampleData(name: "D", value: 7),
]

let range: ClosedRange<Int> = 0 ... 1000
let middleData = range.map { num in
    SampleData(name: "", value: cos(Double(num)), sin(Double(num)))
}

let bigRange: ClosedRange<Int> = 0 ... 1_000_000
let largeData = range.map { num in
    SampleData(name: "", value: sin(Double(num)), cos(Double(num)))
}

benchmark("create small bar chart") {
    _ = Chart {
        BarMark(data: smallData,
                value: QuantitativeVisualChannel(\.value),
                category: BandVisualChannel(\.name))
    }
}

benchmark("create medium point chart") {
    _ = Chart {
        PointMark(data: middleData,
                  x: QuantitativeVisualChannel(\.value),
                  y: QuantitativeVisualChannel(\.value2))
    }
}

benchmark("create large line chart") {
    _ = Chart {
        LineMark(data: largeData,
                 x: QuantitativeVisualChannel(\.value),
                 y: QuantitativeVisualChannel(\.value2))
    }
}

let barChart = Chart {
    BarMark(data: smallData,
            value: QuantitativeVisualChannel(\.value),
            category: BandVisualChannel(\.name))
}

let pointChart = Chart {
    PointMark(data: middleData,
              x: QuantitativeVisualChannel(\.value),
              y: QuantitativeVisualChannel(\.value2))
}

let lineChart = Chart {
    LineMark(data: largeData,
             x: QuantitativeVisualChannel(\.value),
             y: QuantitativeVisualChannel(\.value2))
}

benchmark("snapshot small bar chart") {
    _ = barChart.snapshot()
}

benchmark("snapshot medium point chart") {
    _ = pointChart.snapshot()
}

benchmark("snapshot large line chart") {
    _ = lineChart.snapshot()
}

Benchmark.main()
