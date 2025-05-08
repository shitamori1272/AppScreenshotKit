// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppScreenshotKit",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "AppScreenshotKit",
            targets: ["AppScreenshotKit"])
    ],
    targets: [
        .target(
            name: "AppScreenshotKit"
        ),
        .testTarget(
            name: "AppScreenshotKitTests",
            dependencies: ["AppScreenshotKit"]
        ),
    ]
)
