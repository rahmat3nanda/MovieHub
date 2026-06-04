// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NetworkManager",
    platforms: [
        .iOS(.v13),
        .macOS(.v12)
    ],
    products: [
        .library(name: "NetworkManager", targets: ["NetworkManager"])
    ],
    dependencies: [
        .package(path: "../Constants")
    ],
    targets: [
        .target(
            name: "NetworkManager",
            dependencies: [
                "Constants"
            ]
        )
    ]
)
