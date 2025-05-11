//
//  AppScreenshotKitTestToolsTests.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/11.
//

import XCTest
import AppScreenshotKit
@testable import AppScreenshotKitTestTools

class AppScreenshotKitTestToolsTests: XCTestCase {

    @MainActor
    func testExportAttachments() throws {
        let exporter = AppScreenshotExporter(option: .attachment(xcTestCase: self))
        try exporter.export(AppScreenshoSamples.AppScreenshotIPad.self)
    }
}
