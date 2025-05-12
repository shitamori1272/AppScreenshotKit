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
    
    @MainActor
    func testExportPNGFiles() throws {
        let exporter = AppScreenshotExporter(
            option: .file(
                try AppScreenshotKitUtils.packageURL().appendingPathComponent("Screenshots")
            )
        )
        
        try exporter.export(AppScreenshoSamples.AppScreenshotKitREADME.self)
    }
}
