// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SharedUI",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "SharedUI", targets: ["SharedUI"])
    ],
    dependencies: [
        .package(path: "../DesignSystem"),
        .package(path: "../../Foundation/UtilityKit"),
        .package(path: "../../Domain/DomainKit"),
        .package(url: "https://github.com/onevcat/kingfisher.git", from: "7.0.0")
    ],
    targets: [
        .target(
            name: "SharedUI",
            dependencies: [
                "DesignSystem",
                "UtilityKit",
                "DomainKit",
                .product(name: "Kingfisher", package: "kingfisher")
            ]
        )
    ]
)
