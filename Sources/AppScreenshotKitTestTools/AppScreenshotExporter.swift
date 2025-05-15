import Foundation
import SwiftUI
import AppScreenshotKit
#if canImport(XCTest)
import XCTest
#endif

/**
 * Exports screenshots using AppScreenshotKit and saves them to disk or attaches them to XCTest.
 *
 * This class provides methods to export screenshots for given content types, supporting both file output and XCTest attachments.
 */
public class AppScreenshotExporter {
    let option: ExportOption
    var appleDesignResourceBezelURL: URL = Bundle.module.bundleURL.appending(path: "AppleDesignResource/Bezels")

    /**
     * Initializes the exporter with the given export option.
     *
     * - Parameter option: The export option specifying output destination and file naming rules.
     */
    public init(
        option: ExportOption
    ) {
        self.option = option
    }

    /**
     * Sets the URL for Apple Design Resource bezels.
     *
     * - Parameter url: The URL to the Apple Design Resource bezels directory.
     */
    public func setAppleDesignResourceURL(_ url: URL) {
        appleDesignResourceBezelURL = url
    }

    /**
     * Exports screenshots for the specified content type.
     *
     * - Parameter content: The AppScreenshot content type to export.
     * - Returns: An array of AppScreenshotOutput representing the exported screenshots.
     * - Throws: Errors thrown during export or file writing.
     */
    @discardableResult
    @MainActor public func export<Content: AppScreenshot>(_ content: Content.Type = Content.self) throws -> [AppScreenshotOutput] {
        let outputs = try Content.export(resourceBaseURL: appleDesignResourceBezelURL)

        try outputs.forEach { output in
            let environment = output.environment

            switch option.option {
            case let .file(parent, fileNameRule):
                let fileName: String
                if let fileNameRule {
                    fileName = fileNameRule(environment)
                } else {
                    var defaultFileName = [
                        environment.locale.identifier,
                        "\(environment.device.model.category.rawValue)_\(environment.device.model.displayInch)_inch",
                        String(describing: Content.self)
                    ].joined(separator: "/")

                    if environment.tileCount > 1 {
                        defaultFileName += "-\(output.count)"
                    }
                    fileName = defaultFileName
                }
                let fileURL = parent.appendingPathComponent(fileName + ".png")
                try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
                try output.pngData.write(to: fileURL)
#if canImport(XCTest)
            case let .attachment(testCase, fileNameRule):
                let fileName: String
                if let fileNameRule {
                    fileName = fileNameRule(environment)
                } else {
                    var defaultFileName = "\(environment.locale.identifier)-\(environment.device.model.rawValue)-\(String(describing: Content.self))"
                    if environment.tileCount > 1 {
                        defaultFileName += "-\(output.count)"
                    }
                    fileName = defaultFileName
                }
                let attachment = XCTAttachment(uniformTypeIdentifier: "public.png", name: fileName, payload: output.pngData)
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
        case file(_ parentDirectoryURL: URL, fileNameRule: ((AppScreenshotEnvironment) -> String)?)
#if canImport(XCTest)
        case attachment(xcTestCase: XCTestCase, fileNameRule: ((AppScreenshotEnvironment) -> String)?)
#endif

    }

    /**
     * Export options for AppScreenshotExporter.
     *
     * Use the static methods to create options for file output or XCTest attachment.
     */
    public struct ExportOption {
        let option: _ExportOption

        /**
         * Creates an export option for file output.
         *
         * - Parameter outputURL: The parent directory URL for output files.
         * - Parameter fileNameRule: Optional closure to customize file names.
         * - Returns: An ExportOption configured for file output.
         */
        public static func file(outputURL: URL, fileNameRule: ((AppScreenshotEnvironment) -> String)? = nil) -> ExportOption {
            .init(option: .file(outputURL, fileNameRule: fileNameRule))
        }

#if canImport(XCTest)
        /**
         * Creates an export option for XCTest attachment.
         *
         * - Parameter testCase: The XCTestCase to attach screenshots to.
         * - Parameter fileNameRule: Optional closure to customize attachment names.
         * - Returns: An ExportOption configured for XCTest attachment.
         */
        public static func attachment(testCase: XCTestCase, fileNameRule: ((AppScreenshotEnvironment) -> String)? = nil) -> ExportOption {
            .init(option: .attachment(xcTestCase: testCase, fileNameRule: fileNameRule))
        }
#endif
    }
}
