// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "UtilityKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "UtilityKit", targets: ["UtilityKit"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "UtilityKit",
            dependencies: []
        )
    ]
)
