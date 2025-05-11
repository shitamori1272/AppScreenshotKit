//
//  SketchDocument.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/10.
//

import Foundation

struct SketchPage: Codable {
    let layers: [Layer]

    enum CodingKeys: String, CodingKey {
        case layers
    }

    func imageNameMap() throws -> [String: String] {
        var imageNameMap: [String: String] = [:]

        for layer in layers {
            guard let bitmapLayers = layer.layers else { continue }
            for bitmapLayer in bitmapLayers {
                let imagePath = bitmapLayer.image.filePath
                let layerName = layer.name
                imageNameMap[layerName] = imagePath
            }
        }
        return imageNameMap
    }
}

struct Layer: Codable {
    let name: String
    let layers: [BitmapLayer]?

    enum CodingKeys: String, CodingKey {
        case layers, name
    }
}

struct BitmapLayer: Codable {
    let name: String
    let image: Image

    enum CodingKeys: String, CodingKey {
        case image, name
    }
}

struct Image: Codable {
    let filePath: String

    enum CodingKeys: String, CodingKey {
        case filePath = "_ref"
    }
}
