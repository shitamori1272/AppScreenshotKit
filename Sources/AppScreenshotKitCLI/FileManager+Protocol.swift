//
//  FileManager+Protocol.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/19.
//

import Foundation

protocol FileManagerProtocol {
    func contentsOfDirectory(atPath path: String) throws -> [String]
    func fileExists(atPath path: String) -> Bool
    func createDirectory(at url: URL, withIntermediateDirectories: Bool) throws
    func removeItem(at url: URL) throws
    func copyItem(at srcURL: URL, to dstURL: URL) throws
    func enumerator(
        at url: URL,
        includingPropertiesForKeys keys: [URLResourceKey]?,
        options mask: FileManager.DirectoryEnumerationOptions
    ) -> FileManager.DirectoryEnumerator?

    var temporaryDirectory: URL { get }
    var currentDirectoryPath: String { get }

    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL]
}

extension FileManager: FileManagerProtocol {
    func createDirectory(at url: URL, withIntermediateDirectories: Bool) throws {
        try createDirectory(at: url, withIntermediateDirectories: withIntermediateDirectories, attributes: nil)
    }

    func enumerator(
        at url: URL,
        includingPropertiesForKeys keys: [URLResourceKey]?,
        options mask: FileManager.DirectoryEnumerationOptions
    ) -> FileManager.DirectoryEnumerator? {
        enumerator(at: url, includingPropertiesForKeys: keys, options: mask, errorHandler: nil)
    }
}
