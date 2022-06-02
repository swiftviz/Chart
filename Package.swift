// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
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
        .library(name: "ExampleChartViews", targets: ["ExampleChartViews"]),
        // COMMENT OUT
//        .executable(name: "chartrender-benchmark", targets: ["chartrender-benchmark"])
    ],
    dependencies: [
        .package(url: "https://github.com/swiftviz/scale.git", branch: "main"),
        // .package(url: "https://github.com/swiftviz/scale.git", from: "0.5.0"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.7.2"),
        // COMMENT OUT:
//        .package(url: "https://github.com/google/swift-benchmark", from: "0.1.0"),
        .package(url: "https://github.com/dehesa/CodableCSV", from: "0.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Chart",
            dependencies: [.product(name: "SwiftVizScale", package: "Scale")]
        ),
        .target(
            name: "ExampleChartViews",
            dependencies: [
                "Chart",
                .product(name: "CodableCSV", package: "CodableCSV"),
            ]
        ),
        .testTarget(
            name: "ChartTests",
            dependencies: [
                "Chart",
                .product(name: "SwiftVizScale", package: "Scale"),
            ]
        ),
        .testTarget(
            name: "SnapshotTests",
            dependencies: [
                "Chart",
                .product(name: "SwiftVizScale", package: "Scale"),
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
                .product(name: "CodableCSV", package: "CodableCSV"),
            ],
            resources: [.process("__SnapShots__")]
        ),
        .testTarget(
            name: "DocTests",
            dependencies: [
                "Chart",
                .product(name: "SwiftVizScale", package: "Scale"),
            ]
        ),
        // COMMENT OUT
//        .executableTarget(
//            name: "chartrender-benchmark",
//            dependencies: [
//                "Chart",
//                .product(name: "SwiftVizScale", package: "Scale"),
//                .product(name: "Benchmark", package: "swift-benchmark"),
//                .product(name: "CodableCSV", package: "CodableCSV")
//            ],
//            resources: [.process("fixtures")]
//        )
    ]
)

if ProcessInfo.processInfo.environment["BENCHMARK"] != nil {
    package.products.append(
        .executable(name: "chartrender-benchmark", targets: ["chartrender-benchmark"])
    )
    package.dependencies.append(contentsOf: [
        .package(url: "https://github.com/google/swift-benchmark", from: "0.1.0"),
    ])
    package.targets.append(
        .executableTarget(
            name: "chartrender-benchmark",
            dependencies: [
                "Chart",
                .product(name: "SwiftVizScale", package: "Scale"),
                .product(name: "Benchmark", package: "swift-benchmark"),
                .product(name: "CodableCSV", package: "CodableCSV"),
            ],
            resources: [.process("fixtures")]
        )
    )
}

// Add the documentation compiler plugin if possible
#if swift(>=5.6)
    package.dependencies.append(
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    )
#endif
