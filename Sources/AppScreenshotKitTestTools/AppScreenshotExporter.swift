import Foundation
import SwiftUI
import AppScreenshotKit
#if canImport(XCTest)
import XCTest
#endif

public class AppScreenshotExporter {
    let option: ExportOption
    var appleDesignResourceBezelURL: URL = Bundle.module.bundleURL.appending(path: "AppleDesignResource/Bezels")

    public init(
        option: ExportOption
    ) {
        self.option = option
    }

    public func setAppleDesignResourceURL(_ url: URL) {
        appleDesignResourceBezelURL = url
    }

    @discardableResult
    @MainActor public func export<Content: AppScreenshot>(_ content: Content.Type = Content.self) throws -> [AppScreenshotOutput] {
        let outputs = try Content.export(resourceBaseURL: appleDesignResourceBezelURL)

        try outputs.forEach { output in
            let environment = output.environment

            switch option {
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
    public enum ExportOption {
        case file(_ parentDirectoryURL: URL, fileNameRule: ((AppScreenshotEnvironment) -> String)? = nil)
#if canImport(XCTest)
        case attachment(xcTestCase: XCTestCase, fileNameRule: ((AppScreenshotEnvironment) -> String)? = nil)
#endif
    }
}
