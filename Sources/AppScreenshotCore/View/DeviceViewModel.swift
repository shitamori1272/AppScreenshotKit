//
//  DeviceViewModel.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/04/27.
//

import Foundation
import SwiftUI

/// Protocol for a device view model combining screen and appearance information.
protocol DeviceViewModel: DeviceScreenViewModel, DeviceAppearanceViewModel, Sendable {}

extension AppScreenshotDevice: DeviceViewModel {}
