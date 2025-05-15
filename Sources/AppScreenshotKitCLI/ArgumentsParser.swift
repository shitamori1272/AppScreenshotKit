//
//  ArgumentsParser.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/11.
//

import Foundation

enum ArgumentsParser {
    static func parse(_ arguments: [String]) throws -> Command {
        // Skip the first argument which is the application path
        let args = Array(arguments.dropFirst())

        guard !args.isEmpty else {
            throw CLIError(message: "No subcommand specified.")
        }

        // Validate the subcommand
        guard let subcommand = Subcommand(rawValue: args[0]) else {
            throw CLIError(message: "Invalid subcommand: \(args[0])")
        }

        var outputURL: URL? = nil

        // Parse the remaining arguments
        var index = 1
        while index < args.count {
            let arg = args[index]

            // Options are expected to be in the format "--option"
            if arg.hasPrefix("--") {
                let optionName = String(arg.dropFirst(2))

                guard let option = Option(rawValue: optionName) else {
                    throw CLIError(message: "Invalid option: \(optionName)")
                }

                // Handle options that require a value
                switch option {
                case .outputURL:
                    guard index + 1 < args.count else {
                        throw CLIError(message: "Missing value for option '\(optionName)'.")
                    }

                    let urlString = args[index + 1]
                    outputURL = URL(fileURLWithPath: urlString)
                    index += 2
                }
            } else {
                index += 1
            }
        }

        return Command(subcommand: subcommand, outputURL: outputURL)
    }
}

enum Subcommand: String {
    case downloadBezelImage = "download-bezel-image"
}

enum Option: String {
    case outputURL = "output"
}

struct Command {
    let subcommand: Subcommand
    let outputURL: URL?
}
