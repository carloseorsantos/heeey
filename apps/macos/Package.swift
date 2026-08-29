// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Heeey",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "Heeey",
            targets: ["Heeey"]
        )
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "Heeey",
            dependencies: [],
            path: "Sources/Heeey"
        ),
        .testTarget(
            name: "HeeeyTests",
            dependencies: ["Heeey"],
            path: "Tests/HeeeyTests"
        )
    ]
)
