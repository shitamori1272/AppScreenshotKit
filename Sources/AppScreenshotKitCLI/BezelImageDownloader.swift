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
    let additionalDMGURLs: [URL]

    init(
        rssURL: URL,
        outputDirectoryURL: URL?,
        fileManager: FileManagerProtocol = FileManager.default,
        rssHandler: ((URL) -> RSSHandlerProtocol) = { RSSHandler(rssURL: $0) },
        dmgHandler: ((URL) -> DMGHandlerProtocol) = { DMGHandler(mountPointURL: $0) },
        shell: (() -> ShellProtocol) = { Shell() },
        urlSession: URLSessionProtocol = URLSession.shared,
        additionalDMGURLs: [URL] = []
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
        self.additionalDMGURLs = additionalDMGURLs
    }

    func execute() async throws {
        if fileManager.fileExists(atPath: tempDirectoryURL.path) {
            try fileManager.removeItem(at: tempDirectoryURL)
        }
        try fileManager.createDirectory(at: tempDirectoryURL, withIntermediateDirectories: true)
        defer { try? fileManager.removeItem(at: tempDirectoryURL) }

        let rootDestinationURL = outputDirectoryURL.appending(path: "AppleDesignResource/Bezels")
        if fileManager.fileExists(atPath: rootDestinationURL.path) {
            try fileManager.removeItem(at: rootDestinationURL)
        }
        try fileManager.createDirectory(at: rootDestinationURL, withIntermediateDirectories: true)

        print("Fetching RSS \(rssHandler.rssURL)...")
        let rssContent = try await rssHandler.fetch()
        let dmgLinkURL = rssContent.dmgLinkURL

        print("Downloading \(dmgLinkURL)...")
        let downloadedDMGURL = try await downloadDMG(url: dmgLinkURL)
        defer { try? fileManager.removeItem(at: downloadedDMGURL) }

        let primaryDestinationURL = destinationDirectory(for: dmgLinkURL, under: rootDestinationURL)
        try fileManager.createDirectory(at: primaryDestinationURL, withIntermediateDirectories: true)

        try dmgHandler.mount(dmgURL: downloadedDMGURL) { contentURLs in
            for contentURL in contentURLs {
                if contentURL.pathExtension.lowercased() == "sketch" {
                    try savePNGsFromSketch(
                        sketchURL: contentURL,
                        destinationBaseURL: primaryDestinationURL
                    )
                } else if contentURL.lastPathComponent == "PNG" {
                    try savePNGsFromResourceDirectory(
                        resourceDirectoryURL: contentURL,
                        destinationBaseURL: primaryDestinationURL
                    )
                }
            }
        }

        for additionalDMGURL in additionalDMGURLs {
            print("Downloading additional resource \(additionalDMGURL)...")
            let downloadedAdditionalDMGURL = try await downloadDMG(url: additionalDMGURL)
            defer { try? fileManager.removeItem(at: downloadedAdditionalDMGURL) }

            let additionalDestinationURL = destinationDirectory(for: additionalDMGURL, under: rootDestinationURL)
            try fileManager.createDirectory(at: additionalDestinationURL, withIntermediateDirectories: true)

            try dmgHandler.mount(dmgURL: downloadedAdditionalDMGURL) { contentURLs in
                for contentURL in contentURLs where contentURL.lastPathComponent == "PNG" {
                    try savePNGsFromResourceDirectory(
                        resourceDirectoryURL: contentURL,
                        destinationBaseURL: additionalDestinationURL
                    )
                }
            }
        }
    }

    private func destinationDirectory(for dmgURL: URL, under root: URL) -> URL {
        let folderName = dmgURL.deletingPathExtension().lastPathComponent
        return root.appending(path: folderName)
    }

    func savePNGsFromSketch(sketchURL: URL, destinationBaseURL: URL) throws {
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

    func savePNGsFromResourceDirectory(resourceDirectoryURL: URL, destinationBaseURL: URL) throws {
        let enumerator = fileManager.enumerator(
            at: resourceDirectoryURL,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        )

        let baseURL = resourceDirectoryURL.standardizedFileURL

        while let fileURL = enumerator?.nextObject() as? URL {
            let standardizedFileURL = fileURL.standardizedFileURL
            let resourceValues = try fileURL.resourceValues(forKeys: [.isDirectoryKey])
            let isDirectory = resourceValues.isDirectory ?? false

            let relativePath = standardizedFileURL.path.replacingOccurrences(of: baseURL.path, with: "")
            if relativePath.isEmpty {
                continue
            }

            if relativePath.isEmpty {
                continue
            }

            let destinationURL = destinationBaseURL.appending(
                path: relativePath,
                directoryHint: isDirectory ? .isDirectory : .notDirectory
            )

            if isDirectory {
                if !fileManager.fileExists(atPath: destinationURL.path) {
                    try fileManager.createDirectory(
                        at: destinationURL,
                        withIntermediateDirectories: true
                    )
                }
            } else if fileURL.pathExtension.lowercased() == "png" {
                let parentDirectory = destinationURL.deletingLastPathComponent()
                if !fileManager.fileExists(atPath: parentDirectory.path) {
                    try fileManager.createDirectory(
                        at: parentDirectory,
                        withIntermediateDirectories: true
                    )
                }
                if fileManager.fileExists(atPath: destinationURL.path) {
                    try fileManager.removeItem(at: destinationURL)
                }
                try fileManager.copyItem(at: fileURL, to: destinationURL)
            }
        }
    }

    func downloadDMG(url: URL) async throws -> URL {
        let dmgPath = tempDirectoryURL.appendingPathComponent(url.lastPathComponent)
        let (data, _) = try await urlSession.data(from: url)
        try data.write(to: dmgPath)
        return dmgPath
    }
}
