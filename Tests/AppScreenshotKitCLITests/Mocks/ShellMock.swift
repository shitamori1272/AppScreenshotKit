//
//  ShellMock.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/19.
//

@testable import AppScreenshotKitCLI

class ShellMock: ShellProtocol {
    var runCallCount = 0
    var runHandler: ((Shell.Command) throws -> String)?

    func run(_ command: Shell.Command) throws -> String {
        runCallCount += 1
        guard let handler = runHandler else {
            fatalError()
        }
        return try handler(command)
    }
}
