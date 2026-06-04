// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Constants",
    platforms: [
        .iOS(.v13),
        .macOS(.v12)
    ],
    products: [
        .library(name: "Constants", targets: ["Constants"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Constants",
            dependencies: []
        )
    ]
)
