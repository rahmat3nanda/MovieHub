// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Home",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "Home", targets: ["Home"])
    ],
    dependencies: [
        .package(path: "../../Core/DIContainer"),
        .package(path: "../../Core/NetworkManager"),
        .package(path: "../../Presentation/DesignSystem"),
        .package(path: "../../Presentation/SharedUI"),
        .package(path: "../../Foundation/UtilityKit"),
        .package(path: "../Movie")
    ],
    targets: [
        .target(
            name: "Home",
            dependencies: [
                "DIContainer",
                "NetworkManager",
                "DesignSystem",
                "SharedUI",
                "UtilityKit",
                "Movie"
            ],
            resources: [
                .process("View/HomeAppBarView.xib"),
                .process("View/HomeMovieSectionView.xib"),
                .process("View/HomeView.xib"),
                .process("View/MovieListAppBarView.xib"),
                .process("View/MovieListView.xib"),
                .process("View/MovieListHeaderView.xib"),
                .process("View/LoadingFooterView.xib")
            ]
        )
    ]
)
