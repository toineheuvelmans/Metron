// swift-tools-version:4.2

// https://github.com/apple/swift-evolution/blob/master/proposals/0162-package-manager-custom-target-layouts.md
// https://swift.org/package-manager

import PackageDescription

let package = Package(
    name: "Metron",
    products: [
        .library(name: "Metron", targets: ["Metron"])
    ],
    targets: [
        .target(name: "Metron", dependencies: [], path: "./source/Metron", exclude: ["Test"]),
        .testTarget(name: "Metron-Test", dependencies: ["Metron"], path: "./source/Metron/Test")
    ]
)
