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
        self.mountPointURL =
            mountPointURL ?? fileManager.temporaryDirectory.appending(path: "BezelImageTmp")
    }

    func mount(dmgURL: URL, handler: (([URL]) throws -> Void)) throws {
        // mount the DMG
        try Shell.run(.attachDmg(dmgURL: dmgURL, mountPointURL: mountPointURL))
        defer {
            // unmount the DMG
            _ = try? Shell.run(.detachDmg(mountPointURL: mountPointURL))
        }

        let contentURLs = try fileManager.contentsOfDirectory(atPath: mountPointURL.path)
            .map { mountPointURL.appendingPathComponent($0) }

        try handler(contentURLs)
    }
}
