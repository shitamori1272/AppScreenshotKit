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
    func createBuildCommands(context: PackagePlugin.PluginContext, target: any PackagePlugin.Target) async throws -> [PackagePlugin.Command] {

        let cacheDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let bezelsDirectoryURL = cacheDirectoryURL.appending(path: "com.shitamori1272.AppScreenshotKit/AppleDesignResource")
        let outputDirectoryURL = context.pluginWorkDirectoryURL.appending(path: "AppleDesignResource")

        return [
            .prebuildCommand(
                displayName: "Register bezel images",
                executable: URL(fileURLWithPath: "/bin/cp"),
                arguments: [
                    "-R",
                    bezelsDirectoryURL.path(),
                    outputDirectoryURL.path()
                ],
                environment: [:],
                outputFilesDirectory: outputDirectoryURL
            )
        ]
    }
}
