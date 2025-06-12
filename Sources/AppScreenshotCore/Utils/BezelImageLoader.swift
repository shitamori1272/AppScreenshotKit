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
        guard let filePaths = FileManager.default.subpaths(atPath: resourceBaseURL.path()),
            let imageFilePath = filePaths.first(where: { path in
                imageFileNameCandidates.contains(where: { name in path.hasSuffix(name) })
            })
        else {
            throw AppScreenshotKitError(
                message:
                    "No image file found: \(imageFileNameCandidates[0]) in \(resourceBaseURL.path())"
            )
        }

        return try Data(contentsOf: resourceBaseURL.appendingPathComponent(imageFilePath))
    }

    private func imageFileNameCandidates(_ device: AppScreenshotDevice) -> [String] {
        let deviceName = getDeviceFileNameForModel(device.model)
        let colorName = device.color.rawValue
        let orientationName = device.orientation.rawValue
        
        var fileNames: [String] = []
        
        // Generate filename candidates based on actual file naming patterns
        switch device.model.category {
        case .iPhone:
            // Try both with and without orientation (some iPhone models have inconsistent naming)
            fileNames.append("\(deviceName) - \(colorName) - \(orientationName).png")
            fileNames.append("\(deviceName) - \(colorName).png")
            
        case .iPad:
            // iPads always include orientation in filename  
            fileNames.append("\(deviceName) - \(colorName) - \(orientationName).png")
        }
        
        return fileNames
    }
    
    private func getDeviceFileNameForModel(_ model: DeviceModel) -> String {
        switch model {
        // iPad models need special handling due to file naming differences
        case .iPadPro11M4: return "iPad Pro 11(M4)"
        case .iPadPro13M4: return "iPad Pro 13 (M4)"
        case .iPadAir11M2: return "iPad Air 11 (M2)"
        case .iPadAir13M2: return "iPad Air 13 (M2)"
        // For all other models, use the rawValue directly
        default: return model.rawValue
        }
    }
}
