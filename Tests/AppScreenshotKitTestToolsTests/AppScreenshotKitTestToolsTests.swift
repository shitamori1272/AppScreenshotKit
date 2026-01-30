//
//  AppScreenshotKitTestToolsTests.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/11.
//

import AppScreenshotKit
import SwiftUI
import XCTest

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

    @MainActor
    func testExportJPEGFilesWithHighQuality() throws {
        let outputURL = FileManager.default.temporaryDirectory.appending(
            path: "ScreenshotOutput_JPEG_High"
        )
        let exporter = AppScreenshotExporter(
            option: .file(outputURL: outputURL, imageFormat: .jpeg(compressionQuality: 1.0))
        )
        try exporter.export(TestScreenshot.self)

        let contents = try XCTUnwrap(FileManager.default.subpaths(atPath: outputURL.path()))
        XCTAssertTrue(
            contents.contains(where: { $0.hasSuffix("TestScreenshot.jpeg") }),
            "Expected to find a file ending with TestScreenshot.jpeg"
        )
    }

    @MainActor
    func testExportJPEGFilesWithMediumQuality() throws {
        let outputURL = FileManager.default.temporaryDirectory.appending(
            path: "ScreenshotOutput_JPEG_Medium"
        )
        let exporter = AppScreenshotExporter(
            option: .file(outputURL: outputURL, imageFormat: .jpeg(compressionQuality: 0.5))
        )
        try exporter.export(TestScreenshot.self)

        let contents = try XCTUnwrap(FileManager.default.subpaths(atPath: outputURL.path()))
        XCTAssertTrue(
            contents.contains(where: { $0.hasSuffix("TestScreenshot.jpeg") }),
            "Expected to find a file ending with TestScreenshot.jpeg"
        )
    }

    @MainActor
    func testExportJPEGFilesWithLowQuality() throws {
        let outputURL = FileManager.default.temporaryDirectory.appending(
            path: "ScreenshotOutput_JPEG_Low"
        )
        let exporter = AppScreenshotExporter(
            option: .file(outputURL: outputURL, imageFormat: .jpeg(compressionQuality: 0.1))
        )
        try exporter.export(TestScreenshot.self)

        let contents = try XCTUnwrap(FileManager.default.subpaths(atPath: outputURL.path()))
        XCTAssertTrue(
            contents.contains(where: { $0.hasSuffix("TestScreenshot.jpeg") }),
            "Expected to find a file ending with TestScreenshot.jpeg"
        )
    }

    @MainActor
    func testJPEGFileExtension() throws {
        let jpegFormat = AppScreenshotImageFormat.jpeg(compressionQuality: 0.8)
        XCTAssertEqual(
            jpegFormat.fileExtension,
            "jpeg",
            "JPEG format should have 'jpeg' file extension"
        )
    }

    @MainActor
    func testJPEGUniformTypeIdentifier() throws {
        let jpegFormat = AppScreenshotImageFormat.jpeg(compressionQuality: 0.8)
        XCTAssertEqual(
            jpegFormat.uniformTypeIdentifier,
            "public.jpeg",
            "JPEG format should have 'public.jpeg' uniformTypeIdentifier"
        )
    }

    @MainActor
    func testExportJPEGAttachments() throws {
        let exporter = AppScreenshotExporter(
            option: .attachment(testCase: self, imageFormat: .jpeg(compressionQuality: 0.8))
        )
        let outputs = try exporter.export(TestScreenshot.self)

        // Verify that outputs have the correct format
        for output in outputs {
            XCTAssertEqual(
                output.imageFormat,
                .jpeg(compressionQuality: 0.8),
                "Output should have JPEG format"
            )
            XCTAssertEqual(
                output.imageFormat.uniformTypeIdentifier,
                "public.jpeg",
                "Output uniformTypeIdentifier should be public.jpeg"
            )
            XCTAssertFalse(output.imageData.isEmpty, "Output image data should not be empty")
        }
    }
}

@AppScreenshot
struct TestScreenshot: View {
    var body: some View {
        Text("Hello, World!")
    }
}
