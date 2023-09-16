// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MijickPopupView",
    platforms: [
        .iOS(.v14),
        .macOS(.v12),
        .tvOS(.v15)
    ],
    products: [
        .library(name: "MijickPopupView", targets: ["MijickPopupView"])
    ],
    targets: [
        .target(name: "MijickPopupView", dependencies: [], path: "Sources")
    ],
    swiftLanguageVersions: [.v5]
)
