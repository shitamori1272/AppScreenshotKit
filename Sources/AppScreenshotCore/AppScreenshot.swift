import SwiftUI

/// Protocol that defines the core functionality for generating App Store screenshots.
///
/// This protocol is the foundation of AppScreenshotKit, allowing you to define
/// how your App Store screenshots should be rendered across different devices,
/// orientations, and locales.
public protocol AppScreenshot {
    associatedtype Content: View

    /**
     * The configuration that defines which devices, orientations, and locales
     * will be used for screenshot generation.
     */
    static var configuration: AppScreenshotConfiguration { get }

    /**
     * Builds the content view for the screenshot.
     *
     * This method is where you define the actual appearance of your screenshots.
     * It will be called for each device and locale combination specified in your configuration.
     *
     * - Parameter environment: The environment containing contextual information about
     *   the current screenshot being rendered, including device information and locale.
     * - Returns: A SwiftUI view that will be rendered as the screenshot.
     */
    @MainActor static func body(environment: AppScreenshotEnvironment) -> Content
}

extension AppScreenshot {
    /**
     * Creates and configures the screenshot view with the appropriate environment settings.
     *
     * This method applies the necessary frame constraints, device environment values,
     * and other configurations to ensure the screenshot is rendered correctly.
     *
     * - Parameter environment: The environment context for the screenshot.
     * - Returns: A configured view ready for screenshot rendering.
     */
    @MainActor static func screenshotView(environment: AppScreenshotEnvironment) -> some View {
        return body(environment: environment)
            .frame(
                width: environment.canvasSize.width,
                height: environment.canvasSize.height
            )
            .clipped()
            .environment(\.deviceModel, environment.device)
            .environment(\.locale, environment.locale)
            .environment(
                \.verticalSizeClass,
                environment.device.verticalSizeClass
            )
            .environment(
                \.horizontalSizeClass,
                environment.device.horizontalSizeClass
            )
    }
}
