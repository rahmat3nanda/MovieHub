// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Home",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "Home", targets: ["Home"])
    ],
    dependencies: [
        .package(path: "../../Presentation/DesignSystem"),
        .package(path: "../../Presentation/SharedUI"),
        .package(path: "../../Foundation/UtilityKit"),
        .package(path: "../../Core/NetworkManager")
    ],
    targets: [
        .target(
            name: "Home",
            dependencies: [
                "DesignSystem",
                "SharedUI",
                "UtilityKit",
                "NetworkManager"
            ]
        )
    ]
)
