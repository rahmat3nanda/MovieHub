// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Discover",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "Discover", targets: ["Discover"])
    ],
    dependencies: [
        .package(path: "../../Presentation/DesignSystem"),
        .package(path: "../../Presentation/SharedUI"),
        .package(path: "../../Foundation/UtilityKit")
    ],
    targets: [
        .target(
            name: "Discover",
            dependencies: [
                "DesignSystem",
                "SharedUI",
                "UtilityKit"
            ]
        )
    ]
)
