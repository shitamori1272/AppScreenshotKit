//
//  AppScreenshotKitError.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/11.
//

import Foundation

struct AppScreenshotKitError: LocalizedError, Sendable {
    let message: String
    var errorDescription: String { message }
}
