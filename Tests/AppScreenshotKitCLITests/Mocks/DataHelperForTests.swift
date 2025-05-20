//
//  DataHelperForTests.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/20.
//

import Foundation

@testable import AppScreenshotKitCLI

/// A test helper that stores mock file data for use in tests
actor FileDataMock {
    static let shared = FileDataMock()

    private var dataMap: [String: Data] = [:]

    /// Register mock data for a specific URL path
    func register(url: URL, data: Data) {
        dataMap[url.path] = data
    }

    /// Register multiple files at once with a base directory
    func registerFiles(baseDirectory: URL, filePathsAndData: [String: Data]) {
        for (path, data) in filePathsAndData {
            let url = baseDirectory.appendingPathComponent(path)
            register(url: url, data: data)
        }
    }

    /// Clear all registered mock data
    func clear() {
        dataMap.removeAll()
    }

    /// Get mock data for a URL if it exists
    func data(forURL url: URL) -> Data? {
        return dataMap[url.path]
    }
}

// Extension for FileManagerMock to handle file content operations
extension FileManagerMock {
    /// Add functionality to mock Data(contentsOf:) calls
    func addContentMock(for url: URL, data: Data) async {
        await FileDataMock.shared.register(url: url, data: data)
    }

    /// Add content mocks for multiple files
    func addContentMocks(baseDirectory: URL, filePathsAndData: [String: Data]) async {
        await FileDataMock.shared.registerFiles(
            baseDirectory: baseDirectory,
            filePathsAndData: filePathsAndData
        )
    }

    /// Clear all file content mocks
    func clearContentMocks() async {
        await FileDataMock.shared.clear()
    }

    /// Helper method to get mock data for a URL
    func mockDataFor(url: URL) async -> Data? {
        return await FileDataMock.shared.data(forURL: url)
    }

    /// Simulate reading from a file
    func contentsOf(url: URL) async throws -> Data {
        if let mockData = await FileDataMock.shared.data(forURL: url) {
            return mockData
        }
        throw CLIError(message: "No mock data found for \(url)")
    }
}
