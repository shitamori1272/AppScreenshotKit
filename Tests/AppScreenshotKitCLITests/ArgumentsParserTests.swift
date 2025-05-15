import Foundation
import Testing

@testable import AppScreenshotKitCLI

final class ArgumentsParserTests {
  @Test func testParseValidCommandWithoutOptions() throws {
    // Prepare
    let arguments = ["/path/to/app", "download-bezel-image"]

    // Execute
    let command = try ArgumentsParser.parse(arguments)

    // Verify
    #expect(command.subcommand == .downloadBezelImage)
    #expect(command.outputURL == nil)
  }

  @Test func testParseValidCommandWithOutputOption() throws {
    // Prepare
    let arguments = ["/path/to/app", "download-bezel-image", "--output", "/path/to/output"]

    // Execute
    let command = try ArgumentsParser.parse(arguments)

    // Verify
    #expect(command.subcommand == .downloadBezelImage)
    #expect(command.outputURL != nil)
    #expect(command.outputURL?.path == "/path/to/output")
  }

  @Test func testParseEmptyArguments() throws {
    // Prepare
    let arguments = ["/path/to/app"]

    // Execute & Verify
    #expect(throws: CLIError.self) {
      _ = try ArgumentsParser.parse(arguments)
    }
  }

  @Test func testParseInvalidSubcommand() throws {
    // Prepare
    let arguments = ["/path/to/app", "invalid-subcommand"]

    // Execute & Verify
    #expect(throws: CLIError.self) {
      _ = try ArgumentsParser.parse(arguments)
    }
  }

  @Test func testParseInvalidOption() throws {
    // Prepare
    let arguments = ["/path/to/app", "download-bezel-image", "--invalid-option"]

    // Execute & Verify
    #expect(throws: CLIError.self) {
      _ = try ArgumentsParser.parse(arguments)
    }
  }

  @Test func testParseMissingOptionValue() throws {
    // Prepare
    let arguments = ["/path/to/app", "download-bezel-image", "--output"]

    // Execute & Verify
    #expect(throws: CLIError.self) {
      _ = try ArgumentsParser.parse(arguments)
    }
  }

  @Test func testParseMultipleOptionsWithValues() throws {
    // Prepare
    // Note: Currently, ArgumentsParser only supports "--output" option
    // This test will be valuable when adding more options in the future
    let arguments = ["/path/to/app", "download-bezel-image", "--output", "/path/to/output"]

    // Execute
    let command = try ArgumentsParser.parse(arguments)

    // Verify
    #expect(command.subcommand == .downloadBezelImage)
    #expect(command.outputURL != nil)
    #expect(command.outputURL?.path == "/path/to/output")
  }
}
