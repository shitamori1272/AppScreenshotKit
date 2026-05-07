import Foundation
import Testing

/// Behavioral tests for the `cp` invocation produced by `Plugins/RegisterBezelsCommand`.
///
/// SwiftPM build-tool plugin targets cannot be imported into a test target, so
/// these tests exercise the same `cp` invocation the plugin emits by running
/// `/bin/cp` via `Process` with arguments constructed identically to the plugin.
///
/// If the argument format in `Plugins/RegisterBezelsCommand/RegisterBezelsCommand.swift`
/// changes, mirror the change in `pluginCpArguments(src:dst:)` below.
@Suite
final class CopyBezelsTests {

    private let tempRootURL: URL

    init() throws {
        tempRootURL = FileManager.default.temporaryDirectory.appending(
            path: "RegisterBezelsCommandTests-\(UUID().uuidString)"
        )
        try FileManager.default.createDirectory(at: tempRootURL, withIntermediateDirectories: true)
    }

    deinit {
        try? FileManager.default.removeItem(at: tempRootURL)
    }

    // MARK: - Helpers

    /// Mirrors the argument list emitted by `RegisterBezelsCommand`.
    private func pluginCpArguments(src: URL, dst: URL) -> [String] {
        [
            "-R",
            src.path(percentEncoded: false) + "/.",
            dst.path(percentEncoded: false),
        ]
    }

    @discardableResult
    private func runCp(_ arguments: [String]) throws -> Int32 {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/cp")
        process.arguments = arguments
        process.standardOutput = Pipe()
        process.standardError = Pipe()
        try process.run()
        process.waitUntilExit()
        return process.terminationStatus
    }

    /// Build a minimal bezel-like source tree:
    /// `<dir>/Bezels/Apple-Sketch-Library-Product-Bezels/<filename>` with given contents.
    @discardableResult
    private func makeBezelSource(
        at sourceURL: URL,
        fileName: String = "iPhone 16 Pro Max - Black - Portrait.png",
        contents: Data = Data("bezel-data".utf8)
    ) throws -> URL {
        let nestedDirectory = sourceURL
            .appending(path: "Bezels")
            .appending(path: "Apple-Sketch-Library-Product-Bezels")
        try FileManager.default.createDirectory(at: nestedDirectory, withIntermediateDirectories: true)
        let fileURL = nestedDirectory.appending(path: fileName)
        try contents.write(to: fileURL)
        return fileURL
    }

    private func bezelDataInDestination(_ dst: URL, fileName: String) -> Data? {
        try? Data(
            contentsOf: dst
                .appending(path: "Bezels")
                .appending(path: "Apple-Sketch-Library-Product-Bezels")
                .appending(path: fileName)
        )
    }

    // MARK: - Regression: existing behavior preserved

    @Test
    func copiesContents_withAsciiPaths() throws {
        let src = tempRootURL.appending(path: "src")
        let dst = tempRootURL.appending(path: "dst")
        let payload = Data("payload".utf8)
        try makeBezelSource(at: src, contents: payload)

        let status = try runCp(pluginCpArguments(src: src, dst: dst))
        #expect(status == 0)
        #expect(bezelDataInDestination(dst, fileName: "iPhone 16 Pro Max - Black - Portrait.png") == payload)
    }

    @Test
    func idempotent_acrossMultipleInvocations() throws {
        let src = tempRootURL.appending(path: "src")
        let dst = tempRootURL.appending(path: "dst")
        try makeBezelSource(at: src)

        // Run twice. The destination already exists on the second pass, which is
        // exactly the configuration that triggered the bug under the old args.
        try runCp(pluginCpArguments(src: src, dst: dst))
        try runCp(pluginCpArguments(src: src, dst: dst))

        // The source's tree must not appear nested inside the destination.
        let nested = dst
            .appending(path: src.lastPathComponent)
            .appending(path: "Bezels")
        #expect(!FileManager.default.fileExists(atPath: nested.path(percentEncoded: false)))
        #expect(bezelDataInDestination(dst, fileName: "iPhone 16 Pro Max - Black - Portrait.png") != nil)
    }

    @Test
    func reflectsUpdatedSourceContents_onSecondInvocation() throws {
        let src = tempRootURL.appending(path: "src")
        let dst = tempRootURL.appending(path: "dst")
        try makeBezelSource(at: src, contents: Data("v1".utf8))
        try runCp(pluginCpArguments(src: src, dst: dst))

        try makeBezelSource(at: src, contents: Data("v2".utf8))
        try runCp(pluginCpArguments(src: src, dst: dst))

        #expect(
            bezelDataInDestination(dst, fileName: "iPhone 16 Pro Max - Black - Portrait.png")
                == Data("v2".utf8)
        )
    }

    // MARK: - Bug fix: double-nest no longer happens

    /// Demonstrates the original bug to lock in the fix: the *old* argument
    /// shape (`cp -R src dst`, no trailing `/.`) creates `dst/<srcname>/...`
    /// the second time around. If this ever stops being true, the trailing
    /// `/.` in `pluginCpArguments` is no longer guarding the regression and
    /// the test design needs to be revisited.
    @Test
    func oldArguments_demonstratesDoubleNestBug() throws {
        let src = tempRootURL.appending(path: "src")
        let dst = tempRootURL.appending(path: "dst")
        try makeBezelSource(at: src)

        let oldArgs: [String] = [
            "-R",
            src.path(percentEncoded: false),
            dst.path(percentEncoded: false),
        ]
        try runCp(oldArgs)
        try runCp(oldArgs)

        let doubleNestedFile = dst
            .appending(path: src.lastPathComponent)
            .appending(path: "Bezels")
            .appending(path: "Apple-Sketch-Library-Product-Bezels")
            .appending(path: "iPhone 16 Pro Max - Black - Portrait.png")
        #expect(FileManager.default.fileExists(atPath: doubleNestedFile.path(percentEncoded: false)))
    }

    // MARK: - Bug fix: paths with spaces / non-ASCII are no longer percent-encoded

    @Test
    func copiesContents_whenSourceContainsSpaces() throws {
        let parent = tempRootURL.appending(path: "with space")
        let src = parent.appending(path: "src")
        let dst = parent.appending(path: "dst")
        let payload = Data("space-payload".utf8)
        try makeBezelSource(at: src, contents: payload)

        // Sanity check: the OLD code path passed `URL.path()`, which percent-encodes
        // the space and yields a string `cp` cannot resolve.
        try #require(src.path().contains("%20"))

        let status = try runCp(pluginCpArguments(src: src, dst: dst))
        #expect(status == 0)
        #expect(bezelDataInDestination(dst, fileName: "iPhone 16 Pro Max - Black - Portrait.png") == payload)
    }

    @Test
    func copiesContents_whenDestinationContainsNonAsciiCharacters() throws {
        let parent = tempRootURL.appending(path: "テスト")
        let src = parent.appending(path: "src")
        let dst = parent.appending(path: "dst")
        let payload = Data("non-ascii-payload".utf8)
        try makeBezelSource(at: src, contents: payload)

        try #require(dst.path().contains("%"))

        let status = try runCp(pluginCpArguments(src: src, dst: dst))
        #expect(status == 0)
        #expect(bezelDataInDestination(dst, fileName: "iPhone 16 Pro Max - Black - Portrait.png") == payload)
    }

    /// Demonstrates that the *old* argument shape (`URL.path()`) fails when
    /// the path contains characters that get percent-encoded. Locks in the
    /// rationale for `path(percentEncoded: false)` in `pluginCpArguments`.
    @Test
    func oldArguments_demonstratesPercentEncodingBug() throws {
        let parent = tempRootURL.appending(path: "with space")
        let src = parent.appending(path: "src")
        let dst = parent.appending(path: "dst")
        try makeBezelSource(at: src)

        let oldArgs: [String] = [
            "-R",
            src.path() + "/.",  // percent-encoded: cp cannot open this
            dst.path(),
        ]
        let status = try runCp(oldArgs)
        #expect(status != 0)
    }
}
