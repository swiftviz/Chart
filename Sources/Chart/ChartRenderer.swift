//
//  ChartRenderer.swift
//
//
//  Created by Joseph Heck on 4/20/22.
//
import SwiftUI

public class ChartRenderer {
    // pre-process the collection of marks provided to determine what, if any, axis
    // and margins need to be accounted for in rendering out the view.

    public func createView(_: [AnyMark]) -> some View {
        Canvas { context, size in
            // walk the collection of marks
            // - first determine any insets needed for axis defined within them
            // - then iterate through the whole set, provide the range available, and get
            //   the marks (symbolsForMark), which in turns needs to pass through or use
            //   the range provided with the visualChannel's internal scale to get the
            //   explicit values from the data.
            context.stroke(
                Path(ellipseIn: CGRect(origin: .zero, size: size)),
                with: .color(.green),
                lineWidth: 4
            )
        }
    }
}
