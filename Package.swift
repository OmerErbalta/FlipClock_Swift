// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "FlipClockFramework",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "FlipClockFramework",
            targets: ["FlipClockFramework"]
        ),
    ],
    targets: [
        .target(
            name: "FlipClockFramework",
            dependencies: [],
            path: "Sources/FlipClockFramework",
            exclude: [],
            swiftSettings: [
                .define("ENABLE_UICONTENT")
            ]
        ),
        .testTarget(
            name: "FlipClockFrameworkTests",
            dependencies: ["FlipClockFramework"]
        ),
    ]
)
