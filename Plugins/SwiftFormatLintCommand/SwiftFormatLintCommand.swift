//
//  SwiftFormatLintCommand.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/20.
//

import Foundation
import PackagePlugin

@main
struct SwiftFormatLintCommand: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: any Target) async throws -> [Command] {
        return [
            .buildCommand(
                displayName: "swift format lint",
                executable: URL(fileURLWithPath: "/usr/bin/swift"),
                arguments: [
                    "format",
                    "lint",
                    ".",
                    "--recursive",
                    "--configuration",
                    context.package.directoryURL.appending(path: ".swift-format").path(),
                ],
                environment: [:],
                inputFiles: target.sourceModule?.sourceFiles.map { $0.url } ?? [],
                outputFiles: []
            )
        ]
    }
}
