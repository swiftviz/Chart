# Chart

Declarative charting and visualization to use with SwiftUI

## [work in progress]

The package is in open development with a goal of making a declarative charting library
for use with SwiftUI.
If you found this looking for a charting library you can use immediately, there are several packages immediately available that may provide what you need:

- [SwiftCharts](https://swiftpackageindex.com/ivanschuetz/SwiftCharts)
- [SwiftPlot](https://swiftpackageindex.com/KarthikRIyer/swiftplot)
- [SwiftUIGraphPlotLibrary](https://swiftpackageindex.com/KanshuYokoo/SwiftUIGraphPlotLibrary)

## Inspiration

The goal of this library is to provide a declarative chart view that can be used directly as a SwiftUI view, and following the pattern of describing the charts akin to what's been done with Observable's [Plot](https://observablehq.com/@observablehq/plot) or [Vega-lite](https://vega.github.io/vega-lite/).

The core idea being describing the views not in terms of the kind of chart, but in terms of the kinds of marks used to represent the data you have, describing visually. This core idea is explored in quite a bit of detail within the following papers:

- Hadley Wickham's [Layered Grammar of Graphics](https://vita.had.co.nz/papers/layered-grammar.html)
- [A Grammar of Interactive Graphics](https://idl.cs.washington.edu/files/2017-VegaLite-InfoVis.pdf)

## Goals

The excellent implementations already out there that do this all do so with dynamic languages (primarily Javascript or TypeScript), but I'd like to be able to build the same kinds of charts using that kind of grammar built to work inside SwiftUI, and leveraging the Swift language and standard library.

## Open Development, Open Source

The project is in development in the open, with design, development notes, and documentation included within this repository. The project itself is open source, provided under the MIT license - collaborators are very welcome. As a starting point, feel free to ask questions within the [Github Discussions for this repository](https://github.com/swiftviz/Chart/discussions), and read through the [contributing guide](./CONTRIBUTING.md).
