// swift-tools-version:4.2

// https://github.com/apple/swift-evolution/blob/master/proposals/0162-package-manager-custom-target-layouts.md
// https://swift.org/package-manager

import PackageDescription

let package = Package(
    name: "Metron",
    products: [
        .library(name: "Metron", targets: ["Metron"])
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Nimble.git", from: "7.0.0"),
        .package(url: "https://github.com/Quick/Quick.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "Metron", dependencies: [], path: "./source/Metron", exclude: ["Test"]),
        .testTarget(name: "Metron-Test", dependencies: ["Metron", "Quick", "Nimble"], path: "./source/Metron/Test")
    ]
)
