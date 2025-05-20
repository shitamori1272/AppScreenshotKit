// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Demo",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "Demo",
            targets: ["Demo"]
        )
    ],
    dependencies: [
        .package(path: "../../AppScreenshotKit")
    ],
    targets: [
        .target(
            name: "Demo",
            dependencies: [
                .product(name: "AppScreenshotKit", package: "AppScreenshotKit")
            ]
        ),
        .testTarget(
            name: "DemoTests",
            dependencies: [
                "Demo",
                .product(name: "AppScreenshotKitTestTools", package: "AppScreenshotKit"),
            ]
        ),
    ]
)
