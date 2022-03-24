# Design Goals

Chart aims to provide a declarative structure for charts and plots, with the intent of being embedded within a SwiftUI view.
The main thrust of the declaration maps data you provide to the chart to _marks_, used to visually represent the data.
Examples of marks include `bar`, `dot`, `line`, `area`, and `arc`.
The rendered chart is made up of the data mapped to visual properties of these marks, for example the position of a `dot` with `x` and `y` coordinates, and scaled to be presented.
The input domain of the scales can be declared explicitly, or inferred from the data, and may have the characteristics of clamping or dropping data outside of the input domain, or which scales to outside the output range.
The scale associated with a visual channel is also used to display a visual axis with ticks and values, or potentially a legend describing categories displayed.

The type of data informs what marks are effective at displaying it, types being categorized into the following groups:

- quantitative: continuous data represented in Swift by `Double`.
- ordinal: positional or count data represented in Swift by `Int`.
- nominal (or categorical): descriptive data about a grouping represented in Swift by `String`.
- temporal: continuous time data represented in Swift by `Date` or `TimeInterval`.

This grammatical pattern of displaying a chart or plot is inspired by existing JavaScript libraries including [Vega-lite](https://vega.github.io/vega-lite/), and the research associated with it, and Observable's [Plot](https://observablehq.com/@observablehq/plot), which extends from the [D3.js](http://d3js.org/) visualization library.

## Marks

Marks are geometric shapes such as bars, points, and lines that describe data.
The positions and colors - or any visual aspect - derives from the data that you are charting.
The sequence of data you provide provides the basis for the visual values, from properties on the objects or from raw values you provide.
The raw values are then transformed using a _scale_ in order to display the information in ways that are understandable.
The combination of the visual property being set, and the scale that is transforming the data incoming, can be described as a _visual channel_.
Each kind of mark tends is effective at displaying a few specific kinds of data.
As a result, when creating a chart, choose a mark that best fits the information to visually describe.
Not all visual channels need to be specified, although a few are required for a valid chart.

A list of marks for initial development:

- `Bar`
- `Dot`
- `Line`

Additional marks to potentially develop:

- `Area`
- `Arrow`
- `Box`
- `Cell`
- `Rect`
- `Text`
- `Tick`
- `Vector`

- `Rule`
- `Frame`

## Scales

A scale is defined with an input domain and transforms data to an output range.
The transformation can use different mechanisms, for example a linear or logrithmic scale.
Because a transformation might result in data outside of a visible range, scales can be configured to drop or clamp values that exceed either the input domain or output range after having been scaled.
Scales can also be used to transform the value - such as converting a quantitative value into a specific hue or opacity.

Scales:

- `Linear` - default: Identity (1:1) linear mapping
- `Log`
- `Power`
- `Band` (coerces ordinal position to a location on screen, accomodating spacing between bands, alignment of labels, and explicit widths of bands)

### Color Palletes for Scales

- categorical (equiv to ordinal, returning 8-10 constrasting colors)
- sequential (linear gradients)
- cyclical (linear repeating gradient - rainbow)
- diverging (linear scale diverging from a median)

_(borrowing heavily from Observable)_

Sequential Color Schemes:

- blues
- greens
- greys
- oranges
- purples
- reds

- bugn (blue to green)
- bupu (blue to purple)
- gnbu (green to blue)
- orrd (orange to red)
- pubu (purple to blue)
- pubugn (purle to blue to green)
- purd (purple to red)
- rdpu (red to purple)
- ylgn (yellow to green)
- ylgnby (yellow to green to blue)
- ylorbr (yellow to orange to brown)
- ylorrd (yellot to orange to red)

Diverging Color Schemes:

- brgr (brown to white to green)
- prgn (purple to white to green)
- piyg (pink to white to green)
- puor (purple to white to orange)
- rdbu (red to white to blue)
- rdgy (red to white to grey)
- rdylbu (red to yellow to white to blue)
- rdylgn (red to yellow to white to green)
- spectral (red to yellow to green to blue)
- burd (blue to white to red)
- buylrd (blue to white to yellow to red)

## Transforms

Some marks, such as `bar` and `line` can be `stacked` when representing multiple series of data within a chart.

- `stack` adjusts the positioning of marks to layer marks instead of overlaying them.

Data can be transformed before it is applied to visual channels:

- `bin` to count data
- `group` to collect and categorize data
- `window` to provide smoothed data
- `interval` to convert a discrete value into a `start` and `stop` value

At the start of this effort, I'm uncertain if there's value in including transforms (other than `stack`) within the declarative structure of a chart.
The Swift language provides functional programming capabilities that may mean its easier for a developer to do transormations outside of the chart declaration.

## Chart Layout Configuration

- Margins
  - top: default 0
  - leading: default 0
  - trailing: default 0
  - bottom: default 0
- Size (width, height) : default to available area from view
  - lean into specifying any overall size constraint with the `frame` view modifier

### Axis Configuration

default: No axis

- orientation: top, leading, bottom, trailing
- ticks: (# of requested ticks - default 10)
- tick size: default 6 pt
- tick padding: (distance between tick and label) default 3 pt
- tick rotation: (angle degrees clockwise) default 0
- ruled: (boolean indicating if the axis extends rules through the background of the chart) - default false
- line (boolean indicating a line drawn to represent the domain of the scale) - default true
- label anchor: location of text relative to the end of the tick + padding: default center

## Declarative Structure

_(initial swag)_

```swift
Chart {
  BarMark(data: sourceData) {
    VisualChannel(width, \.node)    // an ordinal/Int value
    VisualChannel(height, \.latency) // a quantitative/Double value
      .logScale(0.1, 100).      // an explicit logarithmic scale for latency that maps from 0.1 to 100
  }
}
```
