// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "LubaConsumers",
    platforms: [.macOS(.v13)],
    dependencies: [.package(name: "LubaUI", path: "../..")],
    targets: [
        .executableTarget(name: "CoreConsumer", dependencies: [.product(name: "LubaCore", package: "LubaUI")]),
        .executableTarget(name: "ComponentsConsumer", dependencies: [.product(name: "LubaComponents", package: "LubaUI")]),
        .executableTarget(name: "LegacyConsumer", dependencies: [.product(name: "LubaUI", package: "LubaUI")])
    ]
)
