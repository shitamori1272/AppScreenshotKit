import Foundation
import Testing

@testable import AppScreenshotKitCLI

struct ShellTests {
    @Test
    func test_unzip_command_arguments() {
        let sketchURL = URL(fileURLWithPath: "/tmp/test.sketch")
        let unzipDir = URL(fileURLWithPath: "/tmp/unzip")
        let command = Shell.Command.unzip(sketchURL: sketchURL, unzipDirectory: unzipDir)
        #expect(command.arguments[0] == "unzip")
        #expect(command.arguments.contains("-d"))
        #expect(command.arguments.contains(unzipDir.path))
    }

    @Test
    func test_detachDmg_command_arguments() {
        let mountPointURL = URL(fileURLWithPath: "/tmp/mountpoint")
        let command = Shell.Command.detachDmg(mountPointURL: mountPointURL)
        #expect(command.arguments[0] == "hdiutil")
        #expect(command.arguments[1] == "detach")
        #expect(command.arguments[2] == mountPointURL.path)
        #expect(command.arguments[3] == "-force")
        #expect(command.input == nil)
    }

    @Test
    func test_attachDmg_command_arguments() {
        let dmgURL = URL(fileURLWithPath: "/tmp/test.dmg")
        let mountPointURL = URL(fileURLWithPath: "/tmp/mountpoint")
        let command = Shell.Command.attachDmg(dmgURL: dmgURL, mountPointURL: mountPointURL)
        #expect(command.arguments[0] == "hdiutil")
        #expect(command.arguments[1] == "attach")
        #expect(command.arguments[2] == dmgURL.path)
        #expect(command.arguments.contains("-nobrowse"))
        #expect(command.arguments.contains("-readonly"))
        #expect(command.arguments.contains("-mountpoint"))
        #expect(command.arguments.contains(mountPointURL.path))
        // #expect(command.arguments.contains("-quiet"))
        #expect(command.input == "yes")
    }
}
