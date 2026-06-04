// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NetworkManager",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(name: "NetworkManager", targets: ["NetworkManager"])
    ],
    dependencies: [
        .package(path: "../Constants"),
        .package(path: "../../Foundation/UtilityKit"),
        .package(url: "https://github.com/kean/Pulse.git", from: "5.0.0")
    ],
    targets: [
        .target(
            name: "NetworkManager",
            dependencies: [
                "Constants",
                "UtilityKit",
                .product(name: "Pulse", package: "Pulse")
            ]
        )
    ]
)
