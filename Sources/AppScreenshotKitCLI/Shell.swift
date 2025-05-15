//
//  Shell.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/10.
//

import Foundation

enum Shell {
    @discardableResult
    static func command(_ args: String..., input: String? = nil) throws -> String {
#if os(macOS)
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["bash", "-c", args.joined(separator: " ")]

        let outputPipe = Pipe()
        let errorPipe = Pipe()

        process.standardOutput = outputPipe
        process.standardError = errorPipe

        if let input {
            let inputPipe = Pipe()
            process.standardInput = inputPipe
            inputPipe.fileHandleForWriting.write(input.data(using: .utf8)!)
            inputPipe.fileHandleForWriting.closeFile()
        }

        print("Running command: \(args.joined(separator: " "))")
        try process.run()
        process.waitUntilExit()

        guard process.terminationStatus == 0 else {
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            let errorString = String(decoding: errorData, as: UTF8.self)
            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let outputString = String(decoding: outputData, as: UTF8.self)
            throw CLIError(message: "Command failed with \(process.terminationStatus):\n error: \(errorString)\n output: \(outputString)")
        }

        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        return String(decoding: outputData, as: UTF8.self)
#else
        throw CLIError.unsupportedPlatform
#endif
    }
}
