//
//  Shell.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/10.
//

import Foundation

protocol ShellProtocol {
    @discardableResult
    func run(_ command: Shell.Command) throws -> String
}

struct Shell: ShellProtocol {
    enum Command {
        case unzip(sketchURL: URL, unzipDirectory: URL)
        case detachDmg(mountPointURL: URL)
        case attachDmg(dmgURL: URL, mountPointURL: URL)

        var arguments: [String] {
            switch self {
            case .unzip(let sketchURL, let unzipDirectory):
                [
                    "unzip",
                    "\"\(sketchURL.path(percentEncoded: false))\"",
                    "-d",
                    unzipDirectory.path(),
                ]
            case .detachDmg(let mountPointURL):
                [
                    "hdiutil",
                    "detach",
                    mountPointURL.path,
                    "-force",
                ]
            case .attachDmg(let dmgURL, let mountPointURL):
                [
                    "hdiutil",
                    "attach",
                    dmgURL.path,
                    "-nobrowse",
                    "-readonly",
                    "-mountpoint",
                    mountPointURL.path,
                    "-debug",
                ]
            }
        }

        var input: String? {
            switch self {
            case .unzip, .detachDmg: nil
            case .attachDmg: "yes"
            }
        }
    }

    @discardableResult
    func run(_ command: Command) throws -> String {
        #if os(macOS)
            let args = command.arguments
            let input = command.input

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

            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            let errorString = String(decoding: errorData, as: UTF8.self)
            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let outputString = String(decoding: outputData, as: UTF8.self)

            guard process.terminationStatus == 0 else {
                let commandString = args.joined(separator: " ")
                let terminationReason = process.terminationReason == .exit ? "exit" : "signal"
                throw CLIError(
                    message:
                        "Shell command failed: '\(commandString)'\nTermination: \(terminationReason) with code \(process.terminationStatus)\nError: \(errorString.trimmingCharacters(in: .whitespacesAndNewlines))\nOutput: \(outputString.trimmingCharacters(in: .whitespacesAndNewlines))"
                )
            }

            return outputString
        #else
            throw CLIError.unsupportedPlatform
        #endif
    }
}
