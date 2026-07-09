// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "LiquidWall",
    defaultLocalization: "en",
    platforms: [
        .macOS("26.0")
    ],
    targets: [
        .executableTarget(
            name: "LiquidWall",
            path: "Sources/LiquidWall",
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                .defaultIsolation(MainActor.self)
            ]
        )
    ]
)
