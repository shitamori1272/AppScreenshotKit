import AppScreenshotKit
import Foundation
import SwiftUI

#if canImport(XCTest)
    import XCTest
#endif

/// Exports screenshots using AppScreenshotKit and saves them to disk or attaches them to XCTest.
///
/// This class provides methods to export screenshots for given content types, supporting both file output and XCTest attachments.
public class AppScreenshotExporter {
    let option: ExportOption
    var appleDesignResourceBezelURL: URL = Bundle.module.bundleURL.appending(path: "AppleDesignResource/Bezels")

    /// Initializes the exporter with the given export option.
    ///
    /// - Parameter option: The export option specifying output destination and file naming rules.
    public init(
        option: ExportOption
    ) {
        self.option = option
    }

    /// Sets the URL for Apple Design Resource bezels.
    ///
    /// - Parameter url: The URL to the Apple Design Resource bezels directory.
    public func setAppleDesignResourceURL(_ url: URL) {
        appleDesignResourceBezelURL = url
    }

    /// Exports screenshots for the specified content type.
    ///
    /// - Parameter content: The AppScreenshot content type to export.
    /// - Returns: An array of AppScreenshotOutput representing the exported screenshots.
    /// - Throws: Errors thrown during export or file writing.
    @discardableResult
    @MainActor public func export<Content: AppScreenshot>(
        _ content: Content.Type = Content.self
    ) throws -> [AppScreenshotOutput] {
        let outputs = try Content.export(
            resourceBaseURL: appleDesignResourceBezelURL,
            imageFormat: option.imageFormat
        )

        for output in outputs {
            let environment = output.environment

            switch option.option {
            case .file(let parent, let fileNameRule, _):
                let fileName: String
                if let fileNameRule {
                    fileName = fileNameRule(environment)
                } else {
                    var defaultFileName = [
                        environment.locale.identifier,
                        "\(environment.device.model.category.rawValue)_\(environment.device.model.displayInch)_inch",
                        String(describing: Content.self),
                    ].joined(separator: "/")

                    if environment.tileCount > 1 {
                        defaultFileName += "-\(output.count)"
                    }
                    fileName = defaultFileName
                }
                let fileURL = parent.appendingPathComponent(
                    fileName + "." + output.imageFormat.fileExtension
                )
                try FileManager.default.createDirectory(
                    at: fileURL.deletingLastPathComponent(),
                    withIntermediateDirectories: true
                )
                try output.imageData.write(to: fileURL)
            #if canImport(XCTest)
                case .attachment(let testCase, let fileNameRule, _):
                    let fileName: String
                    if let fileNameRule {
                        fileName = fileNameRule(environment)
                    } else {
                        var defaultFileName =
                            "\(environment.locale.identifier)-\(environment.device.model.rawValue)-\(String(describing: Content.self))"
                        if environment.tileCount > 1 {
                            defaultFileName += "-\(output.count)"
                        }
                        fileName = defaultFileName
                    }
                    let attachment = XCTAttachment(
                        uniformTypeIdentifier: output.imageFormat.uniformTypeIdentifier,
                        name: fileName,
                        payload: output.imageData
                    )
                    attachment.lifetime = .keepAlways
                    testCase.add(attachment)
            #endif
            }
        }
        return outputs
    }
}

extension AppScreenshotExporter {
    enum _ExportOption {
        case file(
            _ parentDirectoryURL: URL,
            fileNameRule: ((AppScreenshotEnvironment) -> String)?,
            imageFormat: AppScreenshotImageFormat
        )
        #if canImport(XCTest)
            case attachment(
                xcTestCase: XCTestCase,
                fileNameRule: ((AppScreenshotEnvironment) -> String)?,
                imageFormat: AppScreenshotImageFormat
            )
        #endif

    }

    /// Export options for AppScreenshotExporter.
    ///
    /// Use the static methods to create options for file output or XCTest attachment.
    public struct ExportOption {
        let option: _ExportOption

        /// Creates an export option for file output.
        ///
        /// - Parameter outputURL: The parent directory URL for output files.
        /// - Parameter fileNameRule: Optional closure to customize file names.
        /// - Parameter imageFormat: The image format to render.
        /// - Returns: An ExportOption configured for file output.
        public static func file(
            outputURL: URL,
            fileNameRule: ((AppScreenshotEnvironment) -> String)? = nil,
            imageFormat: AppScreenshotImageFormat = .png
        ) -> ExportOption {
            .init(option: .file(outputURL, fileNameRule: fileNameRule, imageFormat: imageFormat))
        }

        #if canImport(XCTest)
            /// Creates an export option for XCTest attachment.
            ///
            /// - Parameter testCase: The XCTestCase to attach screenshots to.
            /// - Parameter fileNameRule: Optional closure to customize attachment names.
            /// - Parameter imageFormat: The image format to render.
            /// - Returns: An ExportOption configured for XCTest attachment.
            public static func attachment(
                testCase: XCTestCase,
                fileNameRule: ((AppScreenshotEnvironment) -> String)? = nil,
                imageFormat: AppScreenshotImageFormat = .png
            ) -> ExportOption {
                .init(
                    option: .attachment(
                        xcTestCase: testCase,
                        fileNameRule: fileNameRule,
                        imageFormat: imageFormat
                    )
                )
            }
        #endif
    }
}

extension AppScreenshotExporter.ExportOption {
    var imageFormat: AppScreenshotImageFormat {
        switch option {
        case .file(_, _, let imageFormat):
            return imageFormat
        #if canImport(XCTest)
            case .attachment(_, _, let imageFormat):
                return imageFormat
        #endif
        }
    }
}
