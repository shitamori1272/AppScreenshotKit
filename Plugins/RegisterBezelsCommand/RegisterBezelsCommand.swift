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

        // We use `ditto` rather than `cp -R` because `cp -R src dst` nests
        // `src` inside `dst` whenever `dst` already exists, producing
        // `dst/<srcname>/...` on a re-run. `ditto src dst` always merges
        // `src`'s contents into `dst` regardless of whether `dst` exists,
        // so the bezel layout stays flat across rebuilds. macOS-only, which
        // is fine here because SwiftPM build plugins always run on the host.
        //
        // `path(percentEncoded: false)` is required because `ditto` (and
        // `touch` above) resolve their arguments as literal filesystem
        // paths. `URL.path()` percent-encodes spaces and non-ASCII
        // characters, which would break builds for users whose home
        // directory path contains such characters.
        return [
            .buildCommand(
                displayName: "Register Bezel images",
                executable: URL(fileURLWithPath: "/usr/bin/ditto"),
                arguments: [
                    bezelsDirectoryURL.path(percentEncoded: false),
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
