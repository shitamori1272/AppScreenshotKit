//
//  AppScreenshotDevice.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/04/27.
//

import Foundation

/// Represents a device for App Store screenshot generation.
///
/// This struct encapsulates the physical characteristics of a device,
/// including its orientation, color, and model.
public struct AppScreenshotDevice: Sendable, Hashable, Equatable {
    /// The orientation of the device (portrait or landscape)
    public let orientation: DeviceOrientation

    /// The color variant of the device
    public let color: DeviceColor

    /// The model of the device (iPhone, iPad, etc.)
    public let model: DeviceModel
}
