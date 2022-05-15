//
//  ChartQuickTestView.swift
//

import SwiftUI

struct ChartQuickTestView: View {
    struct SampleData {
        let xValue: Double
        let yValue: Double
    }

    var body: some View {
        Chart {
            PointMark(data: [SampleData(xValue: 2, yValue: 3)],
                      x: QuantitativeVisualChannel(\.xValue),
                      y: QuantitativeVisualChannel(167))
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ChartQuickTestView()
            .frame(width: 300, height: 200)
    }
}
