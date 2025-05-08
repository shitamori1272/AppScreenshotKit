//
//  BezelImageLoader.swift
//  FocusForFun
//
//  Created by Shuhei Shitamori on 2025/04/25.
//

import Foundation
import System

// 継承を許可するためにopenクラスに変更
struct BezelImageLoader {
    func imageData(_ device: AppScreenshotDevice, resourceBaseURL: URL) throws -> Data {
        // iPadとiPhoneで画像名の作成方法が異なる
        let imageFileName = createImageFileName(device)

        // まずは直接パスで検索
        let directFilePath = resourceBaseURL.appending(component: imageFileName)
        if FileManager.default.fileExists(atPath: directFilePath.path) {
            return try Data(contentsOf: directFilePath)
        }

        // iPhoneの場合はサブディレクトリ内にある
        if device.model.category == .iPhone {
            let iPhoneFilePath =
                resourceBaseURL
                .appending(component: device.model.rawValue)
                .appending(component: imageFileName)
            if FileManager.default.fileExists(atPath: iPhoneFilePath.path) {
                return try Data(contentsOf: iPhoneFilePath)
            }
        }

        // 再帰的に検索
        if let foundURL = findFile(named: imageFileName, in: resourceBaseURL) {
            return try Data(contentsOf: foundURL)
        }

        if let foundURL = findFile(
            named: imageFileName.replacingOccurrences(of: ".png", with: ""),
            in: resourceBaseURL
        ) {
            return try Data(contentsOf: foundURL)
        }

        throw NSError(
            domain: "BezelImageLoaderError",
            code: 404,
            userInfo: [NSLocalizedDescriptionKey: "Bezel image not found: \(imageFileName)"]
        )
    }

    private func createImageFileName(_ device: AppScreenshotDevice) -> String {
        "\(device.model.rawValue) - \(device.color.rawValue) - \(device.orientation.rawValue).png"
    }

    // 再帰的にファイルを検索する関数
    private func findFile(named fileName: String, in directory: URL) -> URL? {
        let fileManager = FileManager.default

        guard
            let contents = try? fileManager.contentsOfDirectory(
                at: directory,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: [.skipsHiddenFiles]
            )
        else {
            return nil
        }

        // 現在のディレクトリで検索
        if let file = contents.first(where: { $0.lastPathComponent == fileName }) {
            return file
        }

        // サブディレクトリを再帰的に検索
        for url in contents {
            guard (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true else {
                continue
            }

            if let found = findFile(named: fileName, in: url) {
                return found
            }
        }

        return nil
    }
}
