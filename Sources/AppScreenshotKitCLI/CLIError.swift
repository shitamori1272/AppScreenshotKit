//
//  CLIError.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/10.
//

import Foundation

struct CLIError: LocalizedError, CustomStringConvertible {
    let message: String
    var errorDescription: String { message }
    var description: String { message }

    static let unsupportedPlatform = CLIError(message: "Unsupported platform. Please use macOS.")
}
