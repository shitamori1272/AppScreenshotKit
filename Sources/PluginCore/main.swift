// main.swift
import Foundation

do {
    let rssURL = URL(string: "https://developer.apple.com/design/downloads/sketch-bezels.rss")!
    let outputDirectoryPath = CommandLine.arguments.count >= 2 ? CommandLine.arguments[1] : nil

    let bezelImageDownloader = BezelImageDownloader(
        rssURL: rssURL,
        outputDirectoryURL: outputDirectoryPath.map { URL(filePath: $0) }
    )

    try await bezelImageDownloader.execute()
} catch {
    print("Error: \(error)")
    exit(1)
}
