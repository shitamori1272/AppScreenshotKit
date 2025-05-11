//
//  BezelImageLoader.swift
//  FocusForFun
//
//  Created by Shuhei Shitamori on 2025/04/25.
//

import Foundation

struct BezelImageLoader {

    func imageData(_ device: AppScreenshotDevice, resourceBaseURL: URL) throws -> Data {
        let imageFileName = imageFileName(device)
        guard let filePaths = FileManager.default.subpaths(atPath: resourceBaseURL.path()),
              let imageFilePath = filePaths.first(where: { $0.hasSuffix(imageFileName) }) else {
            throw AppScreenshotKitError(message: "No image file found: \(imageFileName) in \(resourceBaseURL.path())")
        }

        return try Data(contentsOf: resourceBaseURL.appendingPathComponent(imageFilePath))
    }

    private func imageFileName(_ device: AppScreenshotDevice) -> String {
        let deviceName = switch device.model {
        case .iPadPro11M4: "iPad Pro 11(M4)"
        case .iPadPro13M4: "iPad Pro 13 (M4)"
        case .iPadAir11M2: "iPad Air 11 (M2)"
        case .iPadAir13M2: "iPad Air 13 (M2)"
        default: device.model.rawValue
        }
        return "\(deviceName) - \(device.color.rawValue) - \(device.orientation.rawValue).png"
    }
}
