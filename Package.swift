// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppScreenshotKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "AppScreenshotKit",
            targets: ["AppScreenshotKit"]),
        .library(
            name: "AppScreenshotKitTestTools",
            targets: ["AppScreenshotKitTestTools"]
        ),
        .executable(
            name: "AppScreenshotKitCLI",
            targets: ["AppScreenshotKitCLI"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AppScreenshotKit"
        ),
        .target(
            name: "AppScreenshotKitTestTools",
            dependencies: [
                "AppScreenshotKit",
            ],
            plugins: [
                "RegisterBezelsCommand"
            ]
        ),
        .executableTarget(
            name: "AppScreenshotKitCLI"
        ),
        .plugin(
            name: "RegisterBezelsCommand",
            capability: .buildTool()
        ),
        .testTarget(
            name: "AppScreenshotKitTests",
            dependencies: ["AppScreenshotKit"]
        ),
        .testTarget(
            name: "AppScreenshotKitTestToolsTests",
            dependencies: ["AppScreenshotKitTestTools"]
        ),
        .testTarget(
            name: "AppScreenshotKitCLITests",
            dependencies: ["AppScreenshotKitCLI"]
        )
    ]
)
