import AppScreenshotKitTestTools
import Testing

@testable import Demo

@MainActor
@Test func example() async throws {
    let outputDirectoryURL = try AppScreenshotKitUtils.packageURL().appending(path: "Screenshots")

    let exporter = AppScreenshotExporter(
        option: .file(outputURL: outputDirectoryURL, imageFormat: .jpeg(compressionQuality: 0.6))
    )

    try exporter.export(READMEDemo.self)
    try exporter.export(LocaleDemo.self)
}
