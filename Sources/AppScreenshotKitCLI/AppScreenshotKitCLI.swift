// main.swift
import Foundation

@main
struct AppScreenshotKitCLI {

    static func main() async throws {
        let command = try ArgumentsParser.parse(CommandLine.arguments)
        switch command.subcommand {
        case .downloadBezelImage:
            let rssURL = URL(string: "https://developer.apple.com/design/downloads/sketch-bezels.rss")!
            let additionalDMGURLs = [
                URL(string: "https://devimages-cdn.apple.com/design/resources/download/Bezel-iPhone-17.dmg")!
            ]
            let outputDirectoryPath = command.outputURL

            let bezelImageDownloader = BezelImageDownloader(
                rssURL: rssURL,
                outputDirectoryURL: outputDirectoryPath,
                additionalDMGURLs: additionalDMGURLs
            )

            try await bezelImageDownloader.execute()
        }
    }
}
