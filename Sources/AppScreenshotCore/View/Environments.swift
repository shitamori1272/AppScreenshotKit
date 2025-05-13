//
//  Environments.swift
//  FocusForFun
//
//  Created by Shuhei Shitamori on 2025/04/25.
//

import Foundation
import SwiftUI

struct DeviceModelEnvironmentKey: EnvironmentKey {
    static let defaultValue: DeviceViewModel = AppScreenshotDevice(
        orientation: .portrait,
        color: .black,
        model: .iPhone16Pro
    )
}

struct RenderingStrategyEnvironmentKey: EnvironmentKey {
    static let defaultValue: RenderingStrategy = .virtual
}

struct StatusBarShownEnvironmentKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

struct AppScreenshotEnvironmentEnvironmentKey: EnvironmentKey {
    static let defaultValue: AppScreenshotEnvironment = AppScreenshotEnvironment(
        screenshotSize: .zero,
        tileCount: 1,
        canvasSize: .zero,
        locale: .current,
        device: AppScreenshotDevice(
            orientation: .portrait,
            color: .black,
            model: .iPhone16Pro
        )
    )
}

extension EnvironmentValues {
    var deviceModel: DeviceViewModel {
        get { self[DeviceModelEnvironmentKey.self] }
        set { self[DeviceModelEnvironmentKey.self] = newValue }
    }

    var renderingStrategy: RenderingStrategy {
        get { self[RenderingStrategyEnvironmentKey.self] }
        set { self[RenderingStrategyEnvironmentKey.self] = newValue }
    }

    var statusBarShown: Bool {
        get { self[StatusBarShownEnvironmentKey.self] }
        set { self[StatusBarShownEnvironmentKey.self] = newValue }
    }

    public var appScreenshotEnvironment: AppScreenshotEnvironment {
        get { self[AppScreenshotEnvironmentEnvironmentKey.self] }
        set { self[AppScreenshotEnvironmentEnvironmentKey.self] = newValue }
    }
}
