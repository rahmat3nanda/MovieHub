// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Persistence",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(name: "Persistence", targets: ["Persistence"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Persistence",
            dependencies: []
        )
    ]
)
