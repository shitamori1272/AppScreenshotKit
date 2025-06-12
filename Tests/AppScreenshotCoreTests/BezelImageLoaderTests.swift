//
// BezelImageLoaderTests.swift
// AppScreenshotKit
//
// Created by Shuhei Shitamori on 2025/06/04.
//

import Foundation
import Testing

@testable import AppScreenshotCore

@Suite("BezelImageLoader Tests")
struct BezelImageLoaderTests {

    @Test
    func testBezelImageLoader() throws {
        let resourceBaseURL = packageURL()!.appendingPathComponent("Bezels")
        let allDevices = AppScreenshotSize.all.map { $0.device }
        for device in allDevices {
            let bezelImageLoader = BezelImageLoader()
            let imageData = try bezelImageLoader.imageData(device, resourceBaseURL: resourceBaseURL)
            #expect(imageData.count > 0)
        }
    }

    private func packageURL(currentFilePath: String = #filePath) -> URL? {
        let currentFileURL = URL(filePath: currentFilePath)
        var currentDirectoryURL = currentFileURL.deletingLastPathComponent()
        while currentDirectoryURL != currentDirectoryURL.deletingLastPathComponent() {
            if FileManager.default.fileExists(
                atPath: currentDirectoryURL.appending(path: "Package.swift").path
            ) {
                return currentDirectoryURL
            }
            currentDirectoryURL = currentDirectoryURL.deletingLastPathComponent()
        }
        return nil
    }
}
