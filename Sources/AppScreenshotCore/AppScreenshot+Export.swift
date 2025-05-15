//
//  AppScreenshot+Export.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/04/25.
//

import Foundation

/// Extension that provides export functionality for App Store screenshots.
extension AppScreenshot {

    /**
     * Exports screenshots based on the configured environments.
     *
     * This method generates screenshot images for all the device types, orientations,
     * and locales specified in the configuration. The screenshots are rendered based
     * on the content provided in the `body` method.
     *
     * - Parameter resourceBaseURL: Optional URL to the directory containing device bezel resources.
     *   If provided, the screenshots will use Apple's official device frames.
     *   If nil, virtual device frames will be used.
     *
     * - Returns: An array of AppScreenshotOutput objects containing the PNG data and metadata for each screenshot.
     * - Throws: Errors that might occur during the rendering or image conversion process.
     */
    @MainActor
    package static func export(resourceBaseURL: URL? = nil) throws -> [AppScreenshotOutput] {
        return try configuration.environments().map { environment in
            let renderingStrategy: RenderingStrategy
            if let resourceBaseURL {
                let imageData = try BezelImageLoader().imageData(
                    environment.device,
                    resourceBaseURL: resourceBaseURL
                )
                renderingStrategy = .appleResource(imageData: imageData)
            } else {
                renderingStrategy = .virtual
            }

            // Create an image renderer with the content
            let content = screenshotView(environment: environment)
                .environment(\.renderingStrategy, renderingStrategy)

            let outputs: [AppScreenshotOutput] = try Array(0..<environment.tileCount)
                .compactMap { index in
                    let rect = environment.rect(for: index)
                    // Convert the view to PNG data
                    let pngData = try PNGDataConverter().convert(content, rect: rect)
                    return AppScreenshotOutput(
                        pngData: pngData,
                        environment: environment,
                        count: index
                    )
                }
            return outputs
        }.flatMap { $0 }
    }
}

/// Represents a generated screenshot with its associated metadata.
///
/// This struct encapsulates the PNG image data of the screenshot along with
/// information about the environment in which it was generated, such as device type,
/// orientation, and localization settings.
public struct AppScreenshotOutput: Sendable {
    /// The raw PNG data of the screenshot
    public let pngData: Data

    /// The environment configuration used to generate the screenshot
    public let environment: AppScreenshotEnvironment

    /// The index of the screenshot in a series (when multiple screenshots are generated)
    public let count: Int
}
