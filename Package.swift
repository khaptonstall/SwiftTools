// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SwiftTools",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .executable(name: "swifttools", targets: ["swifttools"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", exact: "1.3.1"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", exact: "0.54.3"),
    ],
    targets: [
        .executableTarget(
            name: "swifttools",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftFormat", package: "SwiftFormat"),
            ],
            resources: [
                .process("Resources"),
            ]
        ),
    ]
)
