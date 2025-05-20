//
//  AppScreenshotKitTestToolsTests.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/11.
//

import XCTest
import AppScreenshotKit
import SwiftUI
@testable import AppScreenshotKitTestTools

class AppScreenshotKitTestToolsTests: XCTestCase {

    @MainActor
    func testExportAttachments() throws {
        let exporter = AppScreenshotExporter(option: .attachment(testCase: self))
        try exporter.export(TestScreenshot.self)
    }

    @MainActor
    func testExportPNGFiles() throws {
        let outputURL = FileManager.default.temporaryDirectory.appending(path: "ScreenshotOutput")
        let exporter = AppScreenshotExporter(option: .file(outputURL: outputURL))
        try exporter.export(TestScreenshot.self)

        let contents = try XCTUnwrap(FileManager.default.subpaths(atPath: outputURL.path()))
        XCTAssertTrue(contents.contains(where: { $0.hasSuffix("TestScreenshot.png") }))
    }
}

@AppScreenshot
struct TestScreenshot: View {
    var body: some View {
        Text("Hello, World!")
    }
}

