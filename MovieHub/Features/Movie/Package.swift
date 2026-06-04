// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Movie",
    platforms: [
        .iOS(.v15),
        .macOS(.v13)
    ],
    products: [
        .library(name: "Movie", targets: ["Movie"])
    ],
    dependencies: [
        .package(path: "../../Core/DIContainer"),
        .package(path: "../../Presentation/DesignSystem"),
        .package(path: "../../Presentation/SharedUI"),
        .package(path: "../../Foundation/UtilityKit"),
        .package(path: "../../Domain/DomainKit"),
        .package(url: "https://github.com/onevcat/kingfisher.git", from: "7.0.0")
    ],
    targets: [
        .target(
            name: "Movie",
            dependencies: [
                "DIContainer",
                "DesignSystem",
                "SharedUI",
                "UtilityKit",
                "DomainKit",
                .product(name: "Kingfisher", package: "kingfisher")
            ]
        )
    ]
)
