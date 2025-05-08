//
//  URL+.swift
//  FocusForFun
//
//  Created by Shuhei Shitamori on 2025/05/07.
//

import Foundation

extension URL {
    /**
     * Finds and returns the URL of the directory containing the Package.swift file by traversing up the directory tree.
     *
     * This method starts from the file where it's called and searches parent directories
     * until it finds a directory containing a Package.swift file.
     *
     * - Parameter currentFilePath: The file path from which to start the search. Defaults to the file where this function is called.
     * - Returns: The URL of the directory containing the Package.swift file.
     * - Throws: URLError if no Package.swift file is found in the directory tree.
     */
    public static func packageURL(currentFilePath: String = #filePath) throws -> URL {
        let currentFileURL = URL(filePath: currentFilePath)
        var currentDirectoryURL = currentFileURL.deletingLastPathComponent()
        while currentDirectoryURL != currentDirectoryURL.deletingLastPathComponent() {
            if FileManager.default.fileExists(
                atPath: currentDirectoryURL.appending(path: "Package.swift").path)
            {
                return currentDirectoryURL
            }
            currentDirectoryURL = currentDirectoryURL.deletingLastPathComponent()
        }

        throw URLError(message: "Package.swift not found in the directory tree.")
    }

    /**
     * Finds and returns the URL of the project root directory by searching for an .xcodeproj file.
     *
     * This method starts from the file where it's called and searches parent directories
     * until it finds a directory containing an .xcodeproj file.
     *
     * - Parameter currentFilePath: The file path from which to start the search. Defaults to the file where this function is called.
     * - Returns: The URL of the directory containing the Xcode project.
     * - Throws: URLError if no Xcode project is found in the directory tree.
     */
    public static func projectRootURL(currentFilePath: String = #filePath) throws -> URL {
        let currentFileURL = URL(filePath: currentFilePath)
        var currentDirectoryURL = currentFileURL.deletingLastPathComponent()
        while currentDirectoryURL != currentDirectoryURL.deletingLastPathComponent() {
            let files = try FileManager.default.contentsOfDirectory(
                at: currentDirectoryURL, includingPropertiesForKeys: nil)
            if files.contains(where: { $0.pathExtension == "xcodeproj" }) {
                return currentDirectoryURL
            }
            currentDirectoryURL = currentDirectoryURL.deletingLastPathComponent()
        }

        throw URLError(message: "Xcode project not found in the directory tree.")
    }
}

/// Error type for URL extension methods.
///
/// Used to provide descriptive error messages when operations on URLs fail.
struct URLError: LocalizedError {
    let message: String
    public var errorDescription: String? { message }
}
