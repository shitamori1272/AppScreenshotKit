import Foundation
import Testing

@testable import AppScreenshotKitCLI

struct BezelImageDownloaderTests {

    @Test func test_init_and_properties() {
        let rssURL = URL(string: "https://example.com/rss")!
        let outputDir = URL(fileURLWithPath: "/tmp/output")
        let downloader = BezelImageDownloader(rssURL: rssURL, outputDirectoryURL: outputDir)
        #expect(downloader.outputDirectoryURL == outputDir)
    }

    @Test func test_savePNGsFromResourceDirectory() throws {
        let fileManager = FileManager.default
        let baseTempDirectory = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)

        defer { try? fileManager.removeItem(at: baseTempDirectory) }

        let resourceDirectory = baseTempDirectory.appendingPathComponent("source/PNG/iPhone 17")
        try fileManager.createDirectory(at: resourceDirectory, withIntermediateDirectories: true)

        let samplePNGURL = resourceDirectory.appendingPathComponent("sample.png")
        try Data([0x89, 0x50, 0x4E, 0x47]).write(to: samplePNGURL)

        let outputDirectory = baseTempDirectory.appendingPathComponent("output")
        let downloader = BezelImageDownloader(
            rssURL: URL(string: "https://example.com/rss")!,
            outputDirectoryURL: outputDirectory
        )

        let destinationRootURL = outputDirectory.appending(path: "AppleDesignResource/Bezels")
        let destinationBaseURL = destinationRootURL.appending(path: "Bezel-iPhone-17")
        try fileManager.createDirectory(at: destinationBaseURL, withIntermediateDirectories: true)

        try downloader.savePNGsFromResourceDirectory(
            resourceDirectoryURL: resourceDirectory.deletingLastPathComponent(),
            destinationBaseURL: destinationBaseURL
        )

        let expectedFileURL = destinationBaseURL.appendingPathComponent("iPhone 17/sample.png")
        #expect(fileManager.fileExists(atPath: expectedFileURL.path))
    }
}
