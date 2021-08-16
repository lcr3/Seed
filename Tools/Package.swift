// swift-tools-version:5.4.0
import PackageDescription

let package = Package(
    name: "Tools",
    products: [
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", .exact("0.43.1")),
        .package(url: "https://github.com/apple/swift-format", .exact("0.48.5")),
    ],
    targets: [
    ]
)
