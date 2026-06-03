// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NetworkManager",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "NetworkManager", targets: ["NetworkManager"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "NetworkManager",
            dependencies: []
        )
    ]
)
