//
//  AppScreenshotImageFormat.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2026/01/30.
//

import CoreGraphics

/// Image format for exported screenshots.
public enum AppScreenshotImageFormat: Sendable, Equatable {
    case png
    case jpeg(compressionQuality: CGFloat)

    /// The preferred file extension for the format.
    public var fileExtension: String {
        switch self {
        case .png:
            return "png"
        case .jpeg:
            return "jpeg"
        }
    }

    /// Uniform Type Identifier for attachments.
    public var uniformTypeIdentifier: String {
        switch self {
        case .png:
            return "public.png"
        case .jpeg:
            return "public.jpeg"
        }
    }

    var clampedCompressionQuality: CGFloat {
        switch self {
        case .png:
            return 1
        case .jpeg(let compressionQuality):
            return min(max(compressionQuality, 0), 1)
        }
    }
}
