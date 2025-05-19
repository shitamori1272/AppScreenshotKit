//
//  FileManager.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/19.
//

import Foundation

protocol FileManagerProtocol {
    func contentsOfDirectory(atPath path: String) throws -> [String]
    func fileExists(atPath path: String) -> Bool
}

extension FileManager: FileManagerProtocol { }

