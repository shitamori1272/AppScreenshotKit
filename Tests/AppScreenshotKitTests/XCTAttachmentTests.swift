//
//  XCTAttachmentTests.swift
//  FocusForFun
//
//  Created by Shuhei Shitamori on 2025/05/07.
//

import XCTest
import AppScreenshotKit

class XCTAttachmentTests: XCTestCase {

    @MainActor
    func testExportAttachments() throws {

        ProcessInfo.processInfo.environment.forEach {
            print($0.key, $0.value)
        }

//        let exporter = AppScreenshotExporter(option: .attachment(xcTestCase: self))
//        try exporter.export(AppScreenshotIPad.self)
    }
}
