import Testing
import AppScreenshotKitTestTools
@testable import Demo

@MainActor
@Test func example() async throws {
    let outputDirectoryURL = try AppScreenshotKitUtils.packageURL().appending(path: "Screenshots")

    let exporter = AppScreenshotExporter(option: .file(outputURL: outputDirectoryURL))

    try exporter.export(READMEDemo.self)
    try exporter.export(LocaleDemo.self)
}
