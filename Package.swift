// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Metron",
    products: [.library(name: "Metron", targets: ["Metron"])],
    targets: [.target(name: "Metron", dependencies: [], path: "./Metron")]
)
