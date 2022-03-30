# Marks and Their Configuration

## Kinds of Marks

### Bar Mark

A chart displays a bar mark using a series of bars, either horizontal or vertical.
The length of the bars (required) can represent quantitative or ordinal data.
The sets of bars (required) can represent categorical or ordinal data.

Visual Channels:

- `value` - required (quantitative, ordinal can be treated as quantitative)
- `category` - required (categorical only)

optional parameters:

- orientation [horizontal|vertical] - default vertical & bottom edge
- ordering - default locale specific based on LTR/RTL language setting, en_US is `LTR`

Common Channels and Defaults:

- `fill` (color, opacity) - default to black, 1.0
- `stroke` (color, opacity, width, style) - default to black, 1.0
- `title` (tooltip or hover description) - default to ""
- `accessibility_label` (short label for accessibility) - default to `title`
- `accessibility_description` (accessibility description) - default to ""
- `accessibility_hidden` (Boolean indicating the mark should be hidden in terms of accessibility) - default to `true`
- `href` (external link for selection) - default to ""

### Dot Mark

A chart displays a dot mark using a collection of shapes, mapped into an area.
The `x` and `y` (required) coordinates of the position represent quantitative data or ordinal data.
The `shape` of the mark (can represent categorical data)
The `color` of the mark (can represent categorical, ordinal, or quantitative data)

Visual Channels:

- `x` - required
- `y` - required
- `shape` - default to circle

optional parameters:

- orientation [horizontal|vertical] - default vertical & bottom edge
- ordering - default locale specific based on LTR/RTL language setting, en_US is `LTR`

Common Channels and Defaults:

- `fill` (color, opacity) - default to black, 1.0
- `stroke` (color, opacity, width, style) - default to black, 1.0
- `title` (tooltip or hover description) - default to ""
- `accessibility_label` (short label for accessibility) - default to `title`
- `accessibility_description` (accessibility description) - default to ""
- `accessibility_hidden` (Boolean indicating the mark should be hidden in terms of accessibility) - default to `true`
- `href` (external link for selection) - default to ""

### Line Mark

A chart displays a line mark using a line drawn through sequential points.
The `x` and `y` (required) coordinates of the position represent quantitative data or ordinal data.
The `color` of the mark can represent categorical, ordinal, or quantitative data.
The individual points which make up the ends of the line segments can have a `shape` that displays categorical data.

Visual Channels:

- `x` - required
- `y` - required
- `shape` - default to circle

optional parameters:

- orientation [horizontal|vertical] - default vertical & bottom edge
- ordering - default locale specific based on LTR/RTL language setting, en_US is `LTR`

Common Channels and Defaults:

- `fill` (color, opacity) - default to black, 1.0
- `stroke` (color, opacity, width, style) - default to black, 1.0
- `title` (tooltip or hover description) - default to ""
- `accessibility_label` (short label for accessibility) - default to `title`
- `accessibility_description` (accessibility description) - default to ""
- `accessibility_hidden` (Boolean indicating the mark should be hidden in terms of accessibility) - default to `true`
- `href` (external link for selection) - default to ""

## Common visual channels for marks

Visual properties that are relevant for all of the marks:

- `fill` (color, opacity)
- `stroke` (color, opacity, width, style)
- `title` (tooltip or hover description)
- `accessibility_label` (short label for accessibility)
- `accessibility_description` (accessibility description)
- `accessibility_hidden` (Boolean indicating the mark should be hidden in terms of accessibility)
- `href` (external link for selection)

Potential properties for all marks:

- `blend` (blend-mode)
- `offsetX`
- `offsetY`
