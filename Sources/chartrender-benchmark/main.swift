//
//  main.swift - chartrender-benchmark
//

import Benchmark
import Chart
import SwiftUI

// swift build --target chartrender-benchmark -c release
// .build/release/chartrender-benchmark --time-unit ms --quiet
//
let referenceSize = CGSize(width: 300, height: 200)

extension SwiftUI.View {
    func referenceFrame() -> some View {
        frame(width: referenceSize.width, height: referenceSize.height).ignoresSafeArea()
    }
}

struct SampleData {
    let name: String
    let value: Double
}

let data: [SampleData] = [
    SampleData(name: "A", value: 3),
    SampleData(name: "B", value: 5),
    SampleData(name: "C", value: 2),
    SampleData(name: "D", value: 7),
]

benchmark("create chart") {
    let chart = Chart {
        BarMark(data: data,
                value: QuantitativeVisualChannel(\.value),
                category: BandVisualChannel(\.name))
    }
}

let chart = Chart {
    BarMark(data: data,
            value: QuantitativeVisualChannel(\.value),
            category: BandVisualChannel(\.name))
}

benchmark("snapshot chart") {
    let image = chart.snapshot()
}

Benchmark.main()

extension View {
    func snapshot() -> NSImage? {
        let controller = NSHostingController(rootView: self)
        let targetSize = controller.view.intrinsicContentSize
        let contentRect = NSRect(origin: .zero, size: targetSize)

        let window = NSWindow(
            contentRect: contentRect,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        window.contentView = controller.view

        guard
            let bitmapRep = controller.view.bitmapImageRepForCachingDisplay(in: contentRect)
        else { return nil }

        controller.view.cacheDisplay(in: contentRect, to: bitmapRep)
        let image = NSImage(size: bitmapRep.size)
        image.addRepresentation(bitmapRep)
        return image
    }
}
