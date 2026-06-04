// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DomainKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "DomainKit", targets: ["DomainKit"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DomainKit",
            dependencies: []
        )
    ]
)
