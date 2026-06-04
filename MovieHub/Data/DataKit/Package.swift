// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DataKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v12)
    ],
    products: [
        .library(name: "DataKit", targets: ["DataKit"])
    ],
    dependencies: [
        .package(path: "../../Core/DIContainer"),
        .package(path: "../../Core/NetworkManager"),
        .package(path: "../../Core/Persistence"),
        .package(path: "../../Domain/DomainKit")
    ],
    targets: [
        .target(
            name: "DataKit",
            dependencies: [
                "DIContainer",
                "NetworkManager",
                "Persistence",
                "DomainKit"
            ]
        ),
        .testTarget(
            name: "DataKitTests",
            dependencies: ["DataKit"]
        )
    ]
)
