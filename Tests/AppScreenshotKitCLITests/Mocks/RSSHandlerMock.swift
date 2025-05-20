//
//  RSSHandlerMock.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/20.
//

import Foundation

@testable import AppScreenshotKitCLI

class RSSHandlerMock: RSSHandlerProtocol {
    let rssURL: URL

    var fetchCallCount = 0
    var fetchHandler: (() async throws -> RSSContent)?

    init(rssURL: URL) {
        self.rssURL = rssURL
    }

    func fetch() async throws -> RSSContent {
        fetchCallCount += 1
        guard let handler = fetchHandler else {
            throw CLIError(message: "No fetch handler provided for RSSHandlerMock")
        }
        return try await handler()
    }
}
