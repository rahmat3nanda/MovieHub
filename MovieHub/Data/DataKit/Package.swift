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
        .package(path: "../../Core/NetworkManager"),
        .package(path: "../../Domain/DomainKit"),
        .package(path: "../../Core/Persistence")
    ],
    targets: [
        .target(
            name: "DataKit",
            dependencies: [
                "DomainKit",
                "NetworkManager",
                "Persistence"
            ]
        ),
        .testTarget(
            name: "DataKitTests",
            dependencies: ["DataKit"]
        )
    ]
)
