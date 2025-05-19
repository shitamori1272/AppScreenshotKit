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
}
