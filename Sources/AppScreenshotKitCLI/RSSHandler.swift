//
//  RSSHandler.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/11.
//

import Foundation

protocol RSSHandlerProtocol {
    var rssURL: URL { get }
    func fetch() async throws -> RSSContent
}

struct RSSHandler: RSSHandlerProtocol {
    let rssURL: URL

    func fetch() async throws -> RSSContent {
        let (rssData, _) = try await URLSession.shared.data(from: rssURL)
        guard let xml = String(data: rssData, encoding: .utf8) else {
            throw CLIError(message: "Failed to parse RSS feed as UTF-8.")
        }
        let pattern = #"https://.*?\.dmg"#
        let regex = try? NSRegularExpression(pattern: pattern)
        let matches = regex?.matches(in: xml, range: NSRange(xml.startIndex..., in: xml)) ?? []
        let urls = matches.compactMap {
            Range($0.range, in: xml).flatMap { URL(string: String(xml[$0])) }
        }
        guard let dmgLinkURL = urls.first else {
            throw CLIError(message: "No DMG link found in the RSS feed.")
        }
        return RSSContent(dmgLinkURL: dmgLinkURL)
    }
}

struct RSSContent {
    let dmgLinkURL: URL
}
