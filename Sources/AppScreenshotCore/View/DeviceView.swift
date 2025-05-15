//
//  DeviceView.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/04/25.
//

import Foundation
import SwiftUI

/// A view that renders content within a device bezel (frame).
///
/// This view provides a convenient way to display your app's content within a realistic
/// device frame, making your App Store screenshots more visually appealing and contextual.
/// It supports both virtual bezels and Apple's official device frames.
public struct DeviceView<Content: View>: View {

    @Environment(\.renderingStrategy) var renderingStrategy
    let content: Content

    /**
     * Creates a new device view with the specified content.
     *
     * - Parameter content: A closure that returns the content to display within the device frame.
     */
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        switch renderingStrategy {
        case .virtual:
            VirtualBezelView {
                content
            }
        case .appleResource(let imageData):
            Bezel(bezelImageData: imageData) {
                content
            }
        }
    }

    /**
     * Configures the view to display a status bar in the device frame.
     *
     * - Returns: A modified view with the status bar displayed.
     */
    public func statusBarShown() -> some View {
        self.environment(\.statusBarShown, true)
    }
}

/// Defines the rendering strategy for device bezels.
///
/// - virtual: Uses a programmatically generated device frame.
/// - appleResource: Uses Apple's official device frames with the provided image data.
enum RenderingStrategy {
    case virtual
    case appleResource(imageData: Data)
}
