// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DIContainer",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "DIContainer", targets: ["DIContainer"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DIContainer",
            dependencies: []
        )
    ]
)
