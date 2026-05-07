//
//  RegisterBezelsCommand.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/11.
//

import Foundation
import PackagePlugin

@main
struct RegisterBezelsCommand: BuildToolPlugin {
    func createBuildCommands(
        context: PackagePlugin.PluginContext,
        target: any PackagePlugin.Target
    ) async throws -> [PackagePlugin.Command] {
        let cacheDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let bezelsDirectoryURL = cacheDirectoryURL.appending(
            path: "com.shitamori1272.AppScreenshotKit/AppleDesignResource"
        )
        let outputDirectoryURL = context.pluginWorkDirectoryURL.appending(path: "AppleDesignResource")

        guard FileManager.default.fileExists(atPath: bezelsDirectoryURL.path) else {
            Diagnostics.warning(
                "No bezels found in \(bezelsDirectoryURL.path). Please run the command to download bezels first.\n \"swift run AppScreenshotKitCLI download-bezel-image\""
            )

            try FileManager.default.createDirectory(at: outputDirectoryURL, withIntermediateDirectories: true)

            return [
                .buildCommand(
                    displayName: "Register Dummy Bezel image file",
                    executable: URL(fileURLWithPath: "/usr/bin/touch"),
                    arguments: [
                        outputDirectoryURL.appending(path: "dummy.txt").path(percentEncoded: false)
                    ],
                    environment: [:],
                    inputFiles: [
                        cacheDirectoryURL
                    ],
                    outputFiles: [
                        outputDirectoryURL
                    ]
                )
            ]
        }

        return [
            .buildCommand(
                displayName: "Register Bezel images",
                executable: URL(fileURLWithPath: "/bin/cp"),
                arguments: [
                    // Trailing `/.` copies the *contents* of the source directory
                    // into the destination. `cp -R src dst` would copy the source
                    // *directory itself* into `dst` whenever `dst` already exists,
                    // producing `dst/<srcname>/...` on a second invocation.
                    "-R",
                    bezelsDirectoryURL.path(percentEncoded: false) + "/.",
                    outputDirectoryURL.path(percentEncoded: false),
                ],
                environment: [:],
                inputFiles: [
                    cacheDirectoryURL
                ],
                outputFiles: [
                    outputDirectoryURL
                ]
            )
        ]
    }
}
