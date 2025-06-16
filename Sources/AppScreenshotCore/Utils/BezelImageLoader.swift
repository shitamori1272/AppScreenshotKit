//
//  BezelImageLoader.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/04/25.
//

import CoreGraphics
import CoreImage
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

        let imageData = try Data(contentsOf: resourceBaseURL.appendingPathComponent(imageFilePath))

        // Check if we need to rotate the image (when using Portrait fallback for Landscape)
        let needsRotation =
            device.orientation == .landscape && needsPortraitFallback(device.model)
            && imageFilePath.contains("Portrait")

        if needsRotation {
            return try rotateImageData(imageData)
        }

        return imageData
    }

    private func imageFileNameCandidates(_ device: AppScreenshotDevice) -> [String] {
        let deviceName = getDeviceFileNameForModel(device.model)
        let colorName = device.color.rawValue
        let orientationName = device.orientation.rawValue

        var fileNames: [String] = []

        // Generate filename candidates based on actual file naming patterns
        switch device.model.category {
        case .iPhone:
            // Try requested orientation first
            fileNames.append("\(deviceName) - \(colorName) - \(orientationName).png")
            fileNames.append("\(deviceName) - \(colorName).png")

            // For specific iPhone models that only have Portrait images, fallback to Portrait when requesting Landscape
            if device.orientation == .landscape && needsPortraitFallback(device.model) {
                fileNames.append("\(deviceName) - \(colorName) - Portrait.png")
            }

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

    private func needsPortraitFallback(_ model: DeviceModel) -> Bool {
        // These specific iPhone models only have Portrait bezel images available
        switch model {
        case .iPhone15, .iPhone15Plus, .iPhone15ProMax, .iPhone14, .iPhone14Plus, .iPhone14ProMax:
            return true
        default:
            return false
        }
    }

    private func rotateImageData(_ imageData: Data) throws -> Data {
        // Create CIImage from input data
        guard let ciImage = CIImage(data: imageData) else {
            throw AppScreenshotKitError(message: "Failed to create CIImage from data")
        }

        // Apply 90-degree clockwise rotation
        let rotatedImage = ciImage.oriented(.right)

        // Create CIContext for rendering
        let context = CIContext()
        
        // Render to PNG data
        guard let pngData = context.pngRepresentation(of: rotatedImage, format: .RGBA8, colorSpace: CGColorSpaceCreateDeviceRGB()) else {
            throw AppScreenshotKitError(message: "Failed to create PNG representation")
        }

        return pngData
    }
}
