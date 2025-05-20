//
//  URLSession+Protocol.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/19.
//

import Foundation

protocol URLSessionProtocol {
  func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
