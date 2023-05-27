# Chart

Declarative charting and visualization

## [work in progress]

At WWDC 2022, Apple released [Swift Charts](https://developer.apple.com/documentation/charts) which hit all the points that this project intended to tackle, and more.
The project has been on hiatus, and is getting refocused to a different end deliverable.
Rather than a sole focus on 2D graphics, use the same _grammar of graphics_ declarative styling to produce visualizations for 2D or 3D environments.

## Inspiration

The original goal of this library is to provide a SwiftUI declarative chart view.
The structure of defining a chart follows the pattern of describing the charts akin to what's been done with Observable's [Plot](https://observablehq.com/@observablehq/plot) or [Vega-lite](https://vega.github.io/vega-lite/).

You describe visualizations not in terms of the kind of chart, but in terms of the kinds of marks, transformations, and projects from your data sources. This is explored in quite a bit of detail within the following papers:

- Hadley Wickham's [Layered Grammar of Graphics](https://vita.had.co.nz/papers/layered-grammar.html)
- [A Grammar of Interactive Graphics](https://idl.cs.washington.edu/files/2017-VegaLite-InfoVis.pdf)

## Goals

The library is functional for simpler 2D visualizations, displayed within SwiftUI - with an updated goal of expanding the effort to produce 3D models for similar visualizations in AR/VR.  
The excellent implementations already out there that do this all do so with dynamic languages (primarily Javascript or TypeScript), but I'd like to be able to build the same kinds of charts using that kind of grammar built to work inside SwiftUI, and leveraging the Swift language and standard library.

## Open Development, Open Source

The project is in development in the open, with design, development notes, and documentation included within this repository. The project itself is open source, provided under the MIT license - collaborators are very welcome. As a starting point, feel free to ask questions within the [Github Discussions for this repository](https://github.com/swiftviz/Chart/discussions), and read through the [contributing guide](./CONTRIBUTING.md).
