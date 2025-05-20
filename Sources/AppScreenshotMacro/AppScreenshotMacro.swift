//
//  AppScreenshotMacro.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/13.
//

import AppScreenshotCore

@attached(extension, conformances: AppScreenshot, names: named(configuration), named(body))
public macro AppScreenshot(_ size: AppScreenshotSize..., options: AppScreenshotConfiguration.Option...) =
    #externalMacro(
        module: "AppScreenshotMacroPlugin",
        type: "AppScreenshotMacro"
    )
