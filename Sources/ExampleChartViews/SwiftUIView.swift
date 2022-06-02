//
//  SwiftUIView.swift
//
//
//  Created by Joseph Heck on 5/31/22.
//

import Chart
// conceptually, I'm hoping to create views that loosely match the kind of interactive exploration you can find with Observable's Plot at
// https://observablehq.com/@observablehq/plot-cheatsheets
import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        Chart(_options: [.all]) {
            PointMark(data: [1, 2, 3, 10, 11], x: QuantitativeVisualChannel(13), y: QuantitativeVisualChannel(\.self))
                .xAxis(showTickLabels: false, label: "fredd", labelOffset: 10)
                .yAxis(label: "i was here really, really, really long title that explodes out of the available space")
        }.frame(width: 400, height: 200, alignment: .center)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
