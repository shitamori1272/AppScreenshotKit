//
//  ScreenshotsTests.swift
//  DemoAppTests
//
//  Verifies Material rendering through a hosted UIApplication.
//

import AppScreenshotKit
import AppScreenshotKitTestTools
import Foundation
import SwiftUI
import Testing

@testable import DemoApp

@AppScreenshot(.iPhone69Inch())
struct MaterialDemo: View {
    var body: some View {
        MaterialDemoView()
    }
}

@MainActor
@Test func exportMaterialScreenshot() throws {
    let exporter = AppScreenshotExporter(
        option: .file(
            outputURL: URL(fileURLWithPath: NSTemporaryDirectory())
                .appendingPathComponent("AppScreenshotKitMaterialDemo"),
            imageFormat: .jpeg(compressionQuality: 0.6)
        )
    )

    let outputs = try exporter.export(MaterialDemo.self)
    #expect(outputs.count == 1)
    #expect(!outputs[0].imageData.isEmpty)
}
