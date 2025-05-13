//
//  DeviceViewModel.swift
//  FocusForFun
//
//  Created by Shuhei Shitamori on 2025/04/27.
//

import Foundation
import SwiftUI

protocol DeviceViewModel: DeviceScreenViewModel, DeviceAppearanceViewModel, Sendable {}

extension AppScreenshotDevice: DeviceViewModel {}
