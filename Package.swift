// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "AppScreenshotKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "AppScreenshotKit",
            targets: ["AppScreenshotKit"]
        ),
        .library(
            name: "AppScreenshotKitTestTools",
            targets: ["AppScreenshotKitTestTools"]
        ),
        .executable(
            name: "AppScreenshotKitCLI",
            targets: ["AppScreenshotKitCLI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "601.0.0-latest")
    ],
    targets: [
        .target(
            name: "AppScreenshotKit",
            dependencies: [
                "AppScreenshotCore",
                "AppScreenshotMacro",
            ]
        ),
        .target(
            name: "AppScreenshotCore"
        ),
        .target(
            name: "AppScreenshotKitTestTools",
            dependencies: [
                "AppScreenshotKit"
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
        ),
        .target(
            name: "AppScreenshotMacro",
            dependencies: [
                "AppScreenshotCore",
                "AppScreenshotMacroPlugin",
            ]
        ),
        .macro(
            name: "AppScreenshotMacroPlugin",
            dependencies: [
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
            ]
        ),
    ]
)
