// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DataKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "DataKit", targets: ["DataKit"])
    ],
    dependencies: [
        .package(path: "../../Core/NetworkManager"),
        .package(path: "../../Domain/DomainKit")
    ],
    targets: [
        .target(
            name: "DataKit",
            dependencies: [
                "DomainKit",
                "NetworkManager"
            ]
        ),
        .testTarget(
            name: "DataKitTests",
            dependencies: ["DataKit"]
        )
    ]
)
