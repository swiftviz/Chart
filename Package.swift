// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Chart",
    platforms: [
        .macOS("12"),
        .iOS("15.0"),
        .tvOS("15.0"),
        .watchOS("8.0"),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Chart",
            targets: ["Chart"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftviz/scale.git", branch: "main")
        //.package(url: "https://github.com/swiftviz/scale.git", from: "0.5.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Chart",
            dependencies: [.product(name: "SwiftVizScale", package: "Scale")]
        ),
        .testTarget(
            name: "ChartTests",
            dependencies: ["Chart", .product(name: "SwiftVizScale", package: "Scale")]
        ),
        .testTarget(
            name: "DocTests",
            dependencies: ["Chart", .product(name: "SwiftVizScale", package: "Scale")]
        ),
    ]
)
