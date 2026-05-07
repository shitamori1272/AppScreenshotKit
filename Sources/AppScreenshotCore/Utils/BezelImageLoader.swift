//
//  BezelImageLoader.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/04/25.
//

import Foundation

struct BezelImageLoader {

    func imageData(_ device: AppScreenshotDevice, resourceBaseURL: URL) throws -> Data {
        let imageFileNameCandidates = imageFileNameCandidates(device)
        let fileURLs =
            FileManager.default.enumerator(
                at: resourceBaseURL,
                includingPropertiesForKeys: nil
            )?
            .allObjects as? [URL] ?? []
        guard
            let imageURL = fileURLs.first(where: { url in
                imageFileNameCandidates.contains(url.lastPathComponent)
            })
        else {
            throw AppScreenshotKitError(
                message:
                    "No image file found: \(imageFileNameCandidates[0]) in \(resourceBaseURL.path(percentEncoded: false))"
            )
        }

        return try Data(contentsOf: imageURL)
    }

    private func imageFileNameCandidates(_ device: AppScreenshotDevice) -> [String] {
        let defaultDeviceName = device.model.rawValue

        let candidates =
            switch device.model {
            case .iPadPro11M4: ["iPad Pro 11(M4)"]
            case .iPadPro13M4: ["iPad Pro 13 (M4)"]
            case .iPadAir11M2: ["iPad Air 11 (M2)"]
            case .iPadAir13M2: ["iPad Air 13 (M2)"]
            default: []
            }
        return ([defaultDeviceName] + candidates)
            .map { "\($0) - \(device.color.rawValue) - \(device.orientation.rawValue).png" }
    }
}
