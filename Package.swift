// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SwiftStyleGuide",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .executable(name: "format", targets: ["format"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", exact: "1.3.1"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", exact: "0.53.6"),
    ],
    targets: [
        .executableTarget(
            name: "format",
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
