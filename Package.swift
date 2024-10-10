// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MijickPopups",
    platforms: [
        .iOS(.v14),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v4)
    ],
    products: [
        .library(name: "MijickPopups", targets: ["MijickPopups"])
    ],
    targets: [
        .target(name: "MijickPopups", dependencies: [], path: "Sources"),
        .testTarget(name: "MijickPopupsTests", dependencies: ["MijickPopups"], path: "Tests")
    ],
    swiftLanguageModes: [.v6]
)
