// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LubaUI",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .watchOS(.v9),
        .tvOS(.v16),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "LubaUI",
            targets: ["LubaUI"]
        ),
    ],
    targets: [
        .target(
            name: "LubaUI",
            dependencies: [],
            path: "Sources/LubaUI"
        ),
        .testTarget(
            name: "LubaUITests",
            dependencies: ["LubaUI"],
            path: "Tests/LubaUITests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
