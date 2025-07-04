//
//  BezelImageDownloader.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/11.
//

import Foundation

struct BezelImageDownloader {

    let packageDomain = "com.shitamori1272.AppScreenshotKit"
    let fileManager: FileManagerProtocol
    let outputDirectoryURL: URL
    let tempDirectoryURL: URL
    let rssHandler: RSSHandlerProtocol
    let dmgHandler: DMGHandlerProtocol
    let shell: ShellProtocol
    let urlSession: URLSessionProtocol

    init(
        rssURL: URL,
        outputDirectoryURL: URL?,
        fileManager: FileManagerProtocol = FileManager.default,
        rssHandler: ((URL) -> RSSHandlerProtocol) = { RSSHandler(rssURL: $0) },
        dmgHandler: ((URL) -> DMGHandlerProtocol) = { DMGHandler(mountPointURL: $0) },
        shell: (() -> ShellProtocol) = { Shell() },
        urlSession: URLSessionProtocol = URLSession.shared
    ) {
        self.fileManager = fileManager
        self.outputDirectoryURL =
            outputDirectoryURL
            ?? fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appending(
                path: packageDomain
            )
            ?? URL(fileURLWithPath: fileManager.currentDirectoryPath)

        self.tempDirectoryURL = fileManager.temporaryDirectory.appendingPathComponent(packageDomain)

        self.rssHandler = rssHandler(rssURL)
        self.dmgHandler = dmgHandler(tempDirectoryURL.appendingPathComponent("BezelImageTmp"))
        self.shell = shell()
        self.urlSession = urlSession
    }

    func execute() async throws {
        if fileManager.fileExists(atPath: tempDirectoryURL.path) {
            try fileManager.removeItem(at: tempDirectoryURL)
        }
        try fileManager.createDirectory(at: tempDirectoryURL, withIntermediateDirectories: true)
        defer { try? fileManager.removeItem(at: tempDirectoryURL) }

        print("Fetching RSS \(rssHandler.rssURL)...")
        let rssContent = try await rssHandler.fetch()
        let dmgLinkURL = rssContent.dmgLinkURL

        print("Downloading \(dmgLinkURL)...")
        let downloadedDMGURL = try await downloadDMG(url: dmgLinkURL)
        defer { try? fileManager.removeItem(at: downloadedDMGURL) }

        try dmgHandler.mount(dmgURL: downloadedDMGURL) { contentURLs in
            for contentURL in contentURLs {
                guard contentURL.pathExtension.lowercased() == "sketch" else { continue }
                try savePNGsFromSketch(sketchURL: contentURL)
            }
        }
    }

    func savePNGsFromSketch(sketchURL: URL) throws {
        let unzipDirectory = tempDirectoryURL.appendingPathComponent("sketch_unzip")
        if fileManager.fileExists(atPath: unzipDirectory.path) {
            try fileManager.removeItem(at: unzipDirectory)
        }
        try fileManager.createDirectory(at: unzipDirectory, withIntermediateDirectories: true)
        defer { try? fileManager.removeItem(at: unzipDirectory) }

        try shell.run(.unzip(sketchURL: sketchURL, unzipDirectory: unzipDirectory))

        let pagesDirectory = unzipDirectory.appendingPathComponent("pages")
        let pageURLs = try fileManager.contentsOfDirectory(atPath: pagesDirectory.path())
            .map { pagesDirectory.appendingPathComponent($0) }

        let destinationBaseURL = outputDirectoryURL.appending(path: "AppleDesignResource/Bezels")
        if fileManager.fileExists(atPath: destinationBaseURL.path) {
            try fileManager.removeItem(at: destinationBaseURL)
        }

        for pageURL in pageURLs {
            let pageData = try Data(contentsOf: pageURL)
            let page = try JSONDecoder().decode(SketchPage.self, from: pageData)
            let imageNameMap = try page.imageNameMap()
            for (layerName, imagePath) in imageNameMap {
                let destinationURL = destinationBaseURL.appending(component: layerName).appendingPathExtension("png")
                if !fileManager.fileExists(atPath: destinationURL.deletingLastPathComponent().path) {
                    try fileManager.createDirectory(
                        at: destinationURL.deletingLastPathComponent(),
                        withIntermediateDirectories: true
                    )
                }
                try fileManager.copyItem(
                    at: unzipDirectory.appending(component: imagePath),
                    to: destinationURL
                )
            }
        }
        print("Saved PNGs to \(destinationBaseURL.path)")
    }

    func downloadDMG(url: URL) async throws -> URL {
        let dmgPath = tempDirectoryURL.appendingPathComponent(url.lastPathComponent)
        let (data, _) = try await urlSession.data(from: url)
        try data.write(to: dmgPath)
        return dmgPath
    }
}
