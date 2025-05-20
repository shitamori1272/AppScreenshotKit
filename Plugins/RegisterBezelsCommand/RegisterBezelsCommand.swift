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
                        outputDirectoryURL.appending(path: "dummy.txt").path()
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
                    "-R",
                    bezelsDirectoryURL.path(),
                    outputDirectoryURL.path(),
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
