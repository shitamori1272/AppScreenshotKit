//
//  DMGHandlerMock.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/20.
//

import Foundation

@testable import AppScreenshotKitCLI

class DMGHandlerMock: DMGHandlerProtocol {
  var mountCallCount = 0
  var mountHandler: ((URL, (([URL]) throws -> Void)) throws -> Void)?

  func mount(dmgURL: URL, handler: (([URL]) throws -> Void)) throws {
    mountCallCount += 1
    guard let mountHandler = mountHandler else {
      throw CLIError(message: "No mount handler provided for DMGHandlerMock")
    }
    try mountHandler(dmgURL, handler)
  }
}
