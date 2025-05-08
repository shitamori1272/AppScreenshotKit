import Foundation
import SwiftUI
//#if canImport(XCTest) && !XCODE_BUILDING_FOR_PREVIEWS
//import XCTest
//#endif

public class AppScreenshotExporter {
    let option: ExportOption
    var appleDesignResourceBezelURL: URL?

    public init(
        option: ExportOption,
        appleDesignResourceBezelURL: URL? = nil
    ) {
        self.option = option
        self.appleDesignResourceBezelURL = appleDesignResourceBezelURL
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
                    var defaultFileName = "\(environment.locale.identifier)/\(environment.device.model.rawValue)/\(String(describing: Content.self))"
                    if environment.screenshotCount > 1 {
                        defaultFileName += "-\(output.count)"
                    }
                    fileName = defaultFileName
                }
                let fileURL = parent.appendingPathComponent(fileName + ".png")
                try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
                try output.pngData.write(to: fileURL)
//#if canImport(XCTest) && !XCODE_BUILDING_FOR_PREVIEWS
//            case let .attachment(testCase, fileNameRule):
//                let fileName: String
//                if let fileNameRule {
//                    fileName = fileNameRule(environment)
//                } else {
//                    var defaultFileName = "\(environment.locale.identifier)-\(environment.device.model.rawValue)-\(String(describing: Content.self))"
//                    if environment.screenshotCount > 1 {
//                        defaultFileName += "-\(output.count)"
//                    }
//                    fileName = defaultFileName
//                }
//                let attachment = XCTAttachment(uniformTypeIdentifier: "public.png", name: fileName, payload: output.pngData)
//                attachment.lifetime = .keepAlways
//                testCase.add(attachment)
//#endif
            case .plugin:
                break
            }
        }
        return outputs
    }
}

extension AppScreenshotExporter {
    public enum ExportOption {
        case file(_ parentDirectoryURL: URL, fileNameRule: ((AppScreenshotEnvironment) -> String)? = nil)
        case plugin
//#if canImport(XCTest) && !XCODE_BUILDING_FOR_PREVIEWS
//        case attachment(xcTestCase: XCTestCase, fileNameRule: ((AppScreenshotEnvironment) -> String)? = nil)
//#endif
    }
}
