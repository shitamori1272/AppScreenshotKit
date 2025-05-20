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
}
