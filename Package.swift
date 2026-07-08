// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "LiquidWall",
    platforms: [
        .macOS("26.0")
    ],
    targets: [
        .executableTarget(
            name: "LiquidWall",
            path: "Sources/LiquidWall",
            swiftSettings: [
                .defaultIsolation(MainActor.self)
            ]
        )
    ]
)
