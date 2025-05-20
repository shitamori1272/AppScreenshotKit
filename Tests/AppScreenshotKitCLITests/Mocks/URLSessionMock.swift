//
//  URLSessionMock.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/19.
//

import Foundation

@testable import AppScreenshotKitCLI

class URLSessionMock: URLSessionProtocol {
  var dataCallCount = 0
  var dataHandler: ((URL) throws -> (Data, URLResponse))?

  func data(from url: URL) async throws -> (Data, URLResponse) {
    dataCallCount += 1
    guard let handler = dataHandler else {
      throw CLIError(message: "No data handler provided for URLSessionMock")
    }
    return try handler(url)
  }
}
