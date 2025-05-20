import Foundation
import Testing

@testable import AppScreenshotKitCLI

struct DMGHandlerTests {

    let mountPoint: URL = URL(fileURLWithPath: "/tmp/mount")
    let shellMock: ShellMock = ShellMock()
    let fileManagerMock: FileManagerMock = FileManagerMock()

    let dmgHandler: DMGHandler

    init() {
        self.dmgHandler = DMGHandler(
            mountPointURL: mountPoint,
            fileManager: fileManagerMock,
            shell: shellMock
        )
    }

    @Test func init_and_properties() {
        #expect(dmgHandler.mountPointURL == mountPoint)
    }

    @Test func mount_should_call_handler() async throws {
        let dmgURL = URL(fileURLWithPath: "/path/to/file.dmg")
        let testFiles = ["file1.txt", "file2.txt"]
        var handlerCalled = false

        // Setup mocks
        shellMock.runHandler = { _ in return "" }
        fileManagerMock.contentsOfDirectoryHandler = { path in
            #expect(path == self.mountPoint.path)
            return testFiles
        }

        try dmgHandler.mount(dmgURL: dmgURL) { urls in
            handlerCalled = true
            #expect(urls.count == 2)
            #expect(urls[0].lastPathComponent == testFiles[0])
            #expect(urls[1].lastPathComponent == testFiles[1])
        }

        #expect(handlerCalled)
        #expect(shellMock.runCallCount >= 1)
        #expect(fileManagerMock.contentsOfDirectoryCallCount == 1)
    }

    @Test func mount_should_attach_and_detach_dmg() throws {
        let dmgURL = URL(fileURLWithPath: "/path/to/file.dmg")
        var attachCalled = false
        var detachCalled = false

        shellMock.runHandler = { command in
            switch command {
            case .attachDmg(let url, let mountPoint):
                attachCalled = true
                #expect(url.path == dmgURL.path)
                #expect(mountPoint.path == self.mountPoint.path)
            case .detachDmg(let mountPoint):
                detachCalled = true
                #expect(mountPoint.path == self.mountPoint.path)
            default:
                throw CLIError(message: "Unexpected command")
            }
            return ""
        }

        fileManagerMock.contentsOfDirectoryHandler = { _ in return [] }

        try dmgHandler.mount(dmgURL: dmgURL) { _ in }

        #expect(attachCalled)
        #expect(detachCalled)
        #expect(shellMock.runCallCount == 2)
    }

    @Test func mount_should_still_detach_even_if_handler_throws() throws {
        let dmgURL = URL(fileURLWithPath: "/path/to/file.dmg")
        var detachCalled = false

        shellMock.runHandler = { command in
            if case .detachDmg = command {
                detachCalled = true
            }
            return ""
        }

        fileManagerMock.contentsOfDirectoryHandler = { _ in return [] }

        do {
            try dmgHandler.mount(dmgURL: dmgURL) { _ in
                throw CLIError(message: "Test error")
            }
        } catch {
            // Expected error
        }

        #expect(detachCalled, "DMG should be detached even if handler throws")
    }
}
