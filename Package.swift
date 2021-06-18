// swift-tools-version:5.5.0
import PackageDescription

var package = Package(
    name: "SeedPackage",
    defaultLocalization: "ja",
    platforms: [
//        .iOS(.v15)
        .iOS("15.0")
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
        )
    ],
    dependencies: [
        .package(
            name: "Firebase",
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            .exact("7.11.1")
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            .exact("0.19.0")
        )
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
                )
            ]
        ),
        .target(
            name: "CreateDairyFeature",
            dependencies: [
                .target(name: "FirebaseApiClient"),
                .product(name: "FirebaseFirestore", package: "Firebase")
            ]
        ),
        .target(
            name: "DiaryDetailFeature",
            dependencies: [
                .target(name: "FirebaseApiClient"),
                .product(name: "FirebaseFirestore", package: "Firebase")
            ]
        ),
        .target(
            name: "SettingFeature",
            dependencies: [
                .target(name: "Component"),
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                )
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
                .product(name: "FirebaseFirestoreSwift-Beta", package: "Firebase")
            ]
        ),
        .target(name: "Component", dependencies: [])
    ]
)

// MARK: - Test Targets
package.targets.append(contentsOf: [
    .testTarget(
        name: "SeedFeatureTests",
        dependencies: ["SeedFeature"]
    ),
    .testTarget(
        name: "CreateDairyFeatureTests",
        dependencies: ["CreateDairyFeature"]
    ),
    .testTarget(
        name: "DiaryDetailFeatureTests",
        dependencies: ["DiaryDetailFeature"]
    ),
    .testTarget(
        name: "SettingFeatureTests",
        dependencies: ["SettingFeature"]
    ),
])
