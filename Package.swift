// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "SeedPackage",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "CreateDairyFeature",
            targets: ["CreateDairyFeature"]
        ),
        .library(
            name: "DiaryDetailFeature",
            targets: ["DiaryDetailFeature"]
        ),
        .library(
            name: "SeedFeature",
            targets: ["SeedFeature"]
        ),
        .library(
            name: "SettingFeature",
            targets: ["SettingFeature"]
        ),
        .library(
            name: "FirebaseApiClient",
            targets: ["FirebaseApiClient"]
        ),
        .library(
            name: "Component",
            targets: ["Component"]
        ),
    ],
    dependencies: [
        .package(
            name: "Firebase",
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            .exact("7.11.1")
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            .exact("0.18.0")
        ),
    ],
    targets: [
        .target(
            name: "SeedFeature",
            dependencies: [
                .target(name: "Component"),
                .target(name: "CreateDairyFeature"),
                .target(name: "DiaryDetailFeature"),
                .target(name: "SettingFeature"),
                .target(name: "FirebaseApiClient"),
                .product(name: "FirebaseFirestore", package: "Firebase"),
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
            ]
        ),
        .target(
            name: "CreateDairyFeature",
            dependencies: [
                .target(name: "FirebaseApiClient"),
                .product(name: "FirebaseFirestore", package: "Firebase"),
            ]
        ),
        .target(
            name: "DiaryDetailFeature",
            dependencies: [
                .target(name: "FirebaseApiClient"),
                .product(name: "FirebaseFirestore", package: "Firebase"),
            ]
        ),
        .target(
            name: "SettingFeature",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
            ]
        ),
        .target(
            name: "FirebaseApiClient",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
                .product(name: "FirebaseFirestore", package: "Firebase"),
                .product(name: "FirebaseFirestoreSwift-Beta", package: "Firebase"),
            ]
        ),
        .target(name: "Component", dependencies: []),
    ]
)
