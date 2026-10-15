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
        .library(name: "LubaCore", targets: ["LubaCore"]),
        .library(name: "LubaComponents", targets: ["LubaComponents"]),
        .library(
            name: "LubaUI",
            targets: ["LubaUI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.3"),
    ],
    targets: [
        .target(
            name: "LubaCore",
            dependencies: [],
            resources: [
                // Built-in accessibility / UI strings (en, de).
                .process("Resources")
            ]
        ),
        .target(name: "LubaComponents", dependencies: ["LubaCore"]),
        .target(name: "LubaUI", dependencies: ["LubaCore", "LubaComponents"]),
        .testTarget(
            name: "LubaUITests",
            dependencies: ["LubaUI", "LubaCore", "LubaComponents"],
            path: "Tests/LubaUITests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
