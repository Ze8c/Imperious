// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Imperious",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Imperious",
            targets: ["Imperious"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Imperious",
            dependencies: []),
        .testTarget(
            name: "ImperiousTests",
            dependencies: ["Imperious"]),
    ]
)
