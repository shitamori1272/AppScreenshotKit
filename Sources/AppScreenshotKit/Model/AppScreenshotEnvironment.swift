//
//  ScreenshotEnvironment.swift
//  FocusForFun
//
//  Created by Shuhei Shitamori on 2025/04/25.
//

import Foundation

/// Represents the environment configuration for a specific App Store screenshot.
///
/// This struct encapsulates all contextual information needed to render a screenshot,
/// including device characteristics, canvas dimensions, and localization settings.
public struct AppScreenshotEnvironment: Equatable, Hashable, Sendable {
    /// The size of the individual screenshot based on App Store requirements
    public let screenshotSize: CGSize

    /// The number of screenshots in the series
    public let screenshotCount: Int

    /// The total canvas size for the screenshot generation
    public let canvasSize: CGSize

    /// The locale for content localization
    public let locale: Locale

    /// The device model configuration
    public let device: AppScreenshotDevice
}

extension AppScreenshotEnvironment {
    /**
     * Calculates the rectangle for a specific screenshot in a series.
     *
     * When generating multiple screenshots in a sequence, this method determines
     * the appropriate portion of the canvas to capture for each individual screenshot.
     *
     * - Parameter screenshotIndex: The index of the screenshot in the series.
     * - Returns: A CGRect representing the position and size of the screenshot, or nil if the index is out of bounds.
     */
    public func rect(for screenshotIndex: Int) -> CGRect {
        guard screenshotIndex < screenshotCount else { return .zero }
        guard screenshotIndex >= 0 else { return .zero }

        let origin = CGPoint(x: CGFloat(screenshotIndex) * screenshotSize.width, y: 0)
        return CGRect(origin: origin, size: screenshotSize)
    }
}
