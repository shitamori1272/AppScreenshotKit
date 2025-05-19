//
//  DMGHandler.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/10.
//

import Foundation

protocol DMGHandlerProtocol {
    func mount(dmgURL: URL, handler: (([URL]) throws -> Void)) throws
}

struct DMGHandler: DMGHandlerProtocol {
    let fileManager: FileManagerProtocol
    let mountPointURL: URL
    let shell: ShellProtocol

    init(
        mountPointURL: URL,
        fileManager: FileManagerProtocol = FileManager.default,
        shell: ShellProtocol = Shell()
    ) {
        self.mountPointURL = mountPointURL
        self.fileManager = fileManager
        self.shell = shell
    }

    func mount(dmgURL: URL, handler: (([URL]) throws -> Void)) throws {
        // mount the DMG
        try shell.run(.attachDmg(dmgURL: dmgURL, mountPointURL: mountPointURL))
        defer {
            // unmount the DMG
            _ = try? shell.run(.detachDmg(mountPointURL: mountPointURL))
        }

        let contentURLs = try fileManager.contentsOfDirectory(atPath: mountPointURL.path)
            .map { mountPointURL.appendingPathComponent($0) }

        try handler(contentURLs)
    }
}
