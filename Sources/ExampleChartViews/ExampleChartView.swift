//
//  ExampleChartView.swift
//

import Chart
import SwiftUI

struct ExampleChartView: View {
    var body: some View {
        Chart(inset: 10) {
            PointMark(data: SFTemps.provideData(),
                      x: QuantitativeVisualChannel(\SFTemps.high),
                      y: QuantitativeVisualChannel(\SFTemps.low))
                .xAxis(chartRules: true)
                .yAxis(chartRules: true)
        }
        .frame(width: 400, height: 400, alignment: .center)
        .border(.blue)
    }
}

struct ExampleChartView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleChartView()
    }
}
