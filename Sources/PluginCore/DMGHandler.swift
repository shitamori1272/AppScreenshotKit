//
//  DMGHandler.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/10.
//

import Foundation

struct DMGHandler {
    let fileManager = FileManager.default
    let mountPointURL: URL

    init(mountPointURL: URL? = nil) {
        self.mountPointURL = mountPointURL ?? fileManager.temporaryDirectory.appending(path: "BezelImageTmp")
    }

    func mount(dmgURL: URL, handler: (([URL]) throws -> Void)) throws {
        // mount the DMG
        try Shell
            .command(
                "hdiutil",
                "attach",
                dmgURL.path,
                "-nobrowse",
                "-readonly",
                "-mountpoint",
                mountPointURL.path,
                "-quiet",
                input: "yes"
            )
        defer {
            // unmount the DMG
            _ = try? Shell.command("hdiutil", "detach", mountPointURL.path, "-force")
        }

        let contentURLs = try fileManager.contentsOfDirectory(atPath: mountPointURL.path)
            .map { mountPointURL.appendingPathComponent($0) }

        try handler(contentURLs)
    }
}
