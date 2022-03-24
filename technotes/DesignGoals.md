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

## Scales

A scale is defined with an input domain and transforms data to an output range.
The transformation can use different mechanisms, for example a linear or logrithmic scale.
Because a transformation might result in data outside of a visible range, scales can be configured to drop or clamp values that exceed either the input domain or output range after having been scaled.
Scales can also be used to transform the value - such as converting a quantitative value into a specific hue or opacity.

### Bar Mark

A chart displays a bar mark using a series of bars, either horizontal or vertical.
The length of the bars (required) can represent quantitative or ordinal data.
The sets of bars (required) can represent categorical or ordinal data.

Visual Channels:

- `x`
- `y`

### Dot Mark

A chart displays a dot mark using a collection of shapes, mapped into an area.
The `x` and `y` (required) coordinates of the position represent quantitative data or ordinal data.
The `shape` of the mark can represent categorical data.
The `color` of the mark can represent categorical, ordinal, or quantitative data.

Visual Channels:

- `x`
- `y`
- `shape`
- `color`

### Line Mark

A chart displays a line mark using a line drawn through sequential points.
The `x` and `y` (required) coordinates of the position represent quantitative data or ordinal data.
The `color` of the mark can represent categorical, ordinal, or quantitative data.
The individual points which make up the ends of the line segments can have a `shape` that displays categorical data.

Visual Channels:

- `x`
- `y`
- `shape`
- `color`

### Additional Marks and Capabilities

Additional marks include:

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
