//
//  ExampleChartView.swift
//

import Chart
import CodableCSV
// conceptually, I'm hoping to create views that loosely match the kind of interactive exploration you can find with Observable's Plot at
// https://observablehq.com/@observablehq/plot-cheatsheets
import SwiftUI

struct ExampleChartView: View {
    var body: some View {
        Chart(_options: [.frame, .chartarea, .axis]) {
            PointMark(data: SFTemps.provideData(),
                      x: QuantitativeVisualChannel(\SFTemps.high),
                      y: QuantitativeVisualChannel(\SFTemps.low))
                .xAxis()
                .yAxis()
        }.frame(width: 400, height: 400, alignment: .center)
    }
}

struct ExampleChartView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleChartView()
    }
}
