# Coding Guidelines

## Values

This project borrows liberally from NetNewsWire's coding values:

* No data loss
* No crashes
* No other bugs
* Fast performance
* Developer productivity

## Language

Write new code in Swift 5. This library builds over Swift 5.5 and is meant to work with SwiftUI.

We use assertions and preconditions (assertions are hit only when running a debug build; preconditions will crash a release build). We also allow force-unwrapping of optionals as a shorthand for a precondition failure, though these should be used sparingly.

Internal elements should be marked private as often as possible. APIs should be exactly what’s needed and not more.

## Code organization

As a general practice:

* Properties go at the top, followed by functions.
* After those, protocol conformances.
* Finally, any a private extension for any private functions.

Use `// MARK:` as appropriate.

### Cleanliness

No code that triggers compiler errors or **warnings** may be checked in.
No code that writes to the console may be checked in — console spew is not allowed.
Use [`swiftformat`](https://github.com/nicklockwood/SwiftFormat) to format the code.

### Profiling

Use Instruments to look for leaks and to do profiling. Instruments is great at finding where the problems actually are, as opposed to where you think they are.

### Docs

The documentation is rendered with DocC, and all public API must have relevant doc comments.
If your PR updates the functionality of an API, the doc comments should be updated to match.
Use extension files in the documentation catalog to include API organization (also known as curation).
Include code snippets illustrating how to use the functions, and verify the results of the code snippets (including any visual results) by including any snippets within the `DocTests` target.

### Testing

Write unit tests, particularly when fixing a bug.

There is never enough test coverage. In other areas, there should always be more tests.

### Version Control / Commit Messages

Commit messages are yours to use as you see fit, but all commits are squashed and merged.
Pull requests should start with a summary that begins with a present-tense verb describing the code update.
