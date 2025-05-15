// main.swift
import Foundation

@main
struct AppScreenshotKitCLI {

    static func main() async throws {
        let command = try ArgumentsParser.parse(CommandLine.arguments)
        switch command.subcommand {
        case .downloadBezelImage:
            let rssURL = URL(string: "https://developer.apple.com/design/downloads/sketch-bezels.rss")!
            let outputDirectoryPath = command.outputURL

            let bezelImageDownloader = BezelImageDownloader(
                rssURL: rssURL,
                outputDirectoryURL: outputDirectoryPath
            )

            try await bezelImageDownloader.execute()
        }
    }
}
