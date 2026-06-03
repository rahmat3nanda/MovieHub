// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Profile",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "Profile", targets: ["Profile"])
    ],
    dependencies: [
        .package(path: "../../Presentation/DesignSystem"),
        .package(path: "../../Presentation/SharedUI"),
        .package(path: "../../Foundation/UtilityKit")
    ],
    targets: [
        .target(
            name: "Profile",
            dependencies: [
                "DesignSystem",
                "SharedUI",
                "UtilityKit"
            ]
        )
    ]
)
