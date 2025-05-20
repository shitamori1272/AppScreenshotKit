//
//  URLSession+Protocol.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/19.
//

import Foundation

/// A protocol that abstracts `URLSession` to enable dependency injection and facilitate testing.
/// Implement this protocol in types that need to perform network requests, such as `URLSession` or mock objects in test cases.
protocol URLSessionProtocol {
  func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
