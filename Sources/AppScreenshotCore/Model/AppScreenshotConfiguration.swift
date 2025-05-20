import SwiftUI

/// Configuration for App Store screenshot generation.
///
/// This struct provides a flexible way to specify which device types, orientations,
/// locales, and series count should be used when generating App Store screenshots.
/// It forms the foundation of the screenshot generation process.
public struct AppScreenshotConfiguration: Sendable {
    /// The collection of screenshot sizes and device configurations to generate
    public let sizes: [AppScreenshotSize]

    /// The locales for which to generate screenshots (for localization)
    public fileprivate(set) var locales: [Locale] = [.current]

    /// Number of screenshots to generate in a series (for sequential screenshots)
    public fileprivate(set) var tileCount: Int = 1

    /// Initializes a new configuration with the specified screenshot sizes.
    ///
    /// - Parameter size: One or more AppScreenshotSize values representing the devices and sizes to use.
    public init(_ size: AppScreenshotSize..., options: Option...) {
        self.sizes = size.isEmpty ? [.iPad97Inch()] : size
        for option in options {
            switch option {
            case .tiles(let count): self.tileCount = count
            case .locale(let locales): self.locales = locales
            }
        }
    }

    /// Initializes a new configuration with an array of screenshot sizes.
    ///
    /// - Parameter sizes: An array of AppScreenshotSize values representing the devices and sizes to use.
    init(sizes: [AppScreenshotSize]) {
        self.sizes = sizes
    }

    /// Generates all the environments for screenshot rendering based on the configuration.
    ///
    /// This method creates the necessary screenshot environments by combining
    /// the specified device sizes with the locales and count settings.
    ///
    /// - Returns: An array of AppScreenshotEnvironment objects ready for rendering.
    func environments() -> [AppScreenshotEnvironment] {
        return sizes.combined(locales).map { size, locale in
            AppScreenshotEnvironment(
                screenshotSize: size.size.size,
                tileCount: tileCount,
                canvasSize: CGSize(
                    width: size.size.size.width * Double(tileCount),
                    height: size.size.size.height
                ),
                locale: locale,
                device: size.device
            )
        }
    }
}

extension AppScreenshotConfiguration {
    /// Sets a single locale for the screenshot configuration.
    ///
    /// - Parameter locale: The locale to use for screenshot generation.
    /// - Returns: A new configuration with the updated locale setting.
    public func locale(_ locale: Locale) -> Self {
        var newConfiguration = self
        newConfiguration.locales = [locale]
        return newConfiguration
    }

    /// Sets multiple locales for the screenshot configuration.
    ///
    /// This enables generation of screenshots for multiple languages/regions at once.
    ///
    /// - Parameter locales: An array of locales to use for screenshot generation.
    /// - Returns: A new configuration with the updated locale settings.
    public func locales(_ locales: [Locale]) -> Self {
        var newConfiguration = self
        newConfiguration.locales = locales
        return newConfiguration
    }
}

extension AppScreenshotConfiguration {
    /// Sets the number of sequential screenshots to generate for each device/locale combination.
    ///
    /// This is useful when creating a series of screenshots that demonstrate a workflow or feature sequence.
    ///
    /// - Parameter count: The number of screenshots to generate in the series.
    /// - Returns: A new configuration with the updated count setting.
    public func tileCount(_ count: Int) -> Self {
        var newConfiguration = self
        newConfiguration.tileCount = count
        return newConfiguration
    }
}

/// Configuration for Macro
extension AppScreenshotConfiguration {
    public enum Option {
        case locale([Locale])
        case tiles(Int)
    }
}

extension Sequence {
    /// Combines the elements of this sequence with the elements of another sequence.
    ///
    /// - Parameter other: The other sequence to combine with.
    /// - Returns: An array of tuples containing paired elements from both sequences.
    fileprivate func combined<OtherSequence: Sequence>(
        _ other: OtherSequence
    ) -> [(
        Element, OtherSequence.Element
    )] {
        var result: [(Element, OtherSequence.Element)] = []
        for element in self {
            for otherElement in other {
                result.append((element, otherElement))
            }
        }
        return result
    }
}
