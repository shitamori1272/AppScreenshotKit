//
//  FileManagerMock.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/19.
//

import Foundation

@testable import AppScreenshotKitCLI

class FileManagerMock: FileManagerProtocol {
    var contentsOfDirectoryCallCount = 0
    var contentsOfDirectoryHandler: ((String) throws -> [String])?

    var fileExistsCallCount = 0
    var fileExistsHandler: ((String) -> Bool)?

    var createDirectoryCallCount = 0
    var createDirectoryHandler: ((URL, Bool) throws -> Void)?

    var removeItemCallCount = 0
    var removeItemHandler: ((URL) throws -> Void)?

    var copyItemCallCount = 0
    var copyItemHandler: ((URL, URL) throws -> Void)?

    var enumeratorCallCount = 0
    var enumeratorHandler: ((URL, [URLResourceKey]?, FileManager.DirectoryEnumerationOptions) -> FileManager.DirectoryEnumerator?)?

    var _temporaryDirectory = URL(fileURLWithPath: "/tmp")
    var _currentDirectoryPath = "/current"
    var _urls: [URL] = []

    func contentsOfDirectory(atPath path: String) throws -> [String] {
        contentsOfDirectoryCallCount += 1
        guard let handler = contentsOfDirectoryHandler else {
            return []
        }
        return try handler(path)
    }

    func fileExists(atPath path: String) -> Bool {
        fileExistsCallCount += 1
        guard let handler = fileExistsHandler else {
            return false
        }
        return handler(path)
    }

    func createDirectory(
        at url: URL,
        withIntermediateDirectories: Bool
    ) throws {
        createDirectoryCallCount += 1
        if let handler = createDirectoryHandler {
            try handler(url, withIntermediateDirectories)
        }
    }

    func removeItem(at url: URL) throws {
        removeItemCallCount += 1
        if let handler = removeItemHandler {
            try handler(url)
        }
    }

    func copyItem(at srcURL: URL, to dstURL: URL) throws {
        copyItemCallCount += 1
        if let handler = copyItemHandler {
            try handler(srcURL, dstURL)
        }
    }

    func enumerator(
        at url: URL,
        includingPropertiesForKeys keys: [URLResourceKey]?,
        options mask: FileManager.DirectoryEnumerationOptions
    ) -> FileManager.DirectoryEnumerator? {
        enumeratorCallCount += 1
        if let handler = enumeratorHandler {
            return handler(url, keys, mask)
        }
        return nil
    }

    var temporaryDirectory: URL {
        return _temporaryDirectory
    }

    var currentDirectoryPath: String {
        return _currentDirectoryPath
    }

    func urls(
        for directory: FileManager.SearchPathDirectory,
        in domainMask: FileManager.SearchPathDomainMask
    ) -> [URL] {
        return _urls
    }
}
