//
//  AppScreenshotSize.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/04/25.
//

import Foundation

/// Represents a specific device size configuration for App Store screenshots.
///
/// This struct combines a device model with its size specifications to ensure
/// screenshots are generated at the correct dimensions required by the App Store.
public struct AppScreenshotSize: Sendable {
    /// The device configuration including model, color, and orientation
    let device: AppScreenshotDevice

    /// The size specification for the screenshot based on App Store requirements
    let size: SizeOption
}

/// Protocol defining a size option for App Store screenshots.
///
/// Implementations of this protocol provide the exact pixel dimensions
/// required for different device types according to App Store specifications.
protocol SizeOption: Sendable {
    /// The actual dimensions of the screenshot in points
    var size: CGSize { get }
}

extension AppScreenshotSize {
    /**
     * Generates all possible combinations of device configurations for a given model.
     *
     * This method creates an array of screenshot size configurations by combining
     * all available orientations, colors, and size options for a specific device model.
     *
     * - Parameters:
     *   - model: The device model to generate configurations for.
     *   - color: The color type to use for the device. Defaults to the provided Color type.
     *   - size: The size option type to use. Defaults to the provided Size type.
     * - Returns: An array of AppScreenshotSize configurations representing all possible combinations.
     */
    static func allCases<
        Color: DeviceColorConvertable & CaseIterable, Size: SizeOption & CaseIterable
    >(of model: DeviceModel, color: Color.Type = Color.self, size: Size.Type = Size.self)
        -> [AppScreenshotSize]
    {
        var sizeList = [AppScreenshotSize]()
        for orientation in DeviceOrientation.allCases {
            for color in Color.allCases {
                for size in Size.allCases {
                    sizeList.append(
                        AppScreenshotSize(
                            device: AppScreenshotDevice(
                                orientation: orientation,
                                color: color.deviceColor,
                                model: model
                            ),
                            size: size
                        )
                    )
                }
            }
        }
        return sizeList
    }

    /**
     * A collection of all supported device screenshot configurations.
     *
     * This property combines all configurations for iPads and iPhones to provide
     * a comprehensive set of screenshot specifications for all supported devices.
     */
    static var all: [AppScreenshotSize] {
        Self.iPad97InchAll + Self.iPad110InchAll + Self.iPad130InchAll + Self.iPhone61InchAll
            + Self.iPhone63InchAll + Self.iPhone69InchAll
    }
}
