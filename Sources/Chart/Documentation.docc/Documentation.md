# ``Chart``

A declarative charting library that extends SwiftUI.

## Overview

Chart provides a declarative chart view for SwiftUI that allows you to describe a chart mapping data into marks.
This follows a pattern, and takes inspiration from, declarative charting in other languages such as Observable's [Plot](https://observablehq.com/@observablehq/plot) or the [Vega-lite](https://vega.github.io/vega-lite/) project.
The core concept behind declarative charting is explored in quite a bit of detail within the following papers:

- Hadley Wickham's [Layered Grammar of Graphics](https://vita.had.co.nz/papers/layered-grammar.html)
- [A Grammar of Interactive Graphics](https://idl.cs.washington.edu/files/2017-VegaLite-InfoVis.pdf)

## Topics

### Charts

- ``Chart/Chart``

### Marks

- ``Chart/LineMark``
- ``Chart/PointMark``
- ``Chart/BarMark``
- ``Chart/AnyMark``
- ``Chart/Mark``

### Symbols

- ``Chart/MarkSymbol``
- ``Chart/Axis``
- ``Chart/IndividualLine``
- ``Chart/IndividualPoint``
- ``Chart/IndividualRect``
- ``Chart/IndividualRule``
- ``Chart/PlotShape``

### Visual Channels

- ``Chart/QuantitativeVisualChannel``
- ``Chart/DiscreteVisualChannel``
- ``Chart/BandVisualChannel``
- ``Chart/TypeOfVisualProperty``
- ``Chart/VisualPropertyType``

### Building Charts

- ``Chart/ChartBuilder``
- ``Chart/ChartSpec``
- ``Chart/ChartOrientation``
- ``Chart/DrawingMode``

