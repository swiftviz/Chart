//
//  BarMark.swift
//  
//
//  Created by Joseph Heck on 3/25/22.
//
import SwiftUI

/// A type that represents a series of bars.
///
/// The type infers the number and visual properties of the bars from the data you provide to the visual channels when declaring a bar mark.
public struct BarMark: Mark {
    public var x: CGFloat
    
    public var y: CGFloat
    
    
    let height: CGFloat //? value cast from with quantitative (Double) or Ordinal (Int) type
    
    let width: CGFloat //? value cast from the mapping to width, which could be from a categorical (String) or ordinal (Int) type.
    // The actual width for an individual bar as displayed on the Canvas
    // can be inferred if the mapped property is categorical by dividing
    // the available space among the # of categories being displayed with
    // accommodation for optional spacing between the bars.
    
    public init(_ height: Double, _ width: Double) {
        self.height = height
        self.width = width
    }
}
