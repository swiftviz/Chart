//
//  BarMark.swift
//  
//
//  Created by Joseph Heck on 3/25/22.
//

public struct BarMark: Mark {
    
    let height: Double //? value cast from with quantitative (Double) or Ordinal (Int) type
    
    let width: Double //? value cast from the mapping to width, which could be from a categorical (String) or ordinal (Int) type.
    // The actual width for an individual bar as displayed on the Canvas
    // can be inferred if the mapped property is categorical by dividing
    // the available space among the # of categories being displayed with
    // accommodation for optional spacing between the bars.
    
    public init(_ height: Double, _ width: Double) {
        self.height = height
        self.width = width
    }
}
