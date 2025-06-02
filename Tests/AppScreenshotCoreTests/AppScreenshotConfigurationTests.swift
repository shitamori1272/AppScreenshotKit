//
//  AppScreenshotConfigurationTests.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/06/02.
//

import Foundation
import Testing

@testable import AppScreenshotCore

/// Tests for AppScreenshotConfiguration and related functionality.
@Suite("AppScreenshotConfiguration Tests")
struct AppScreenshotConfigurationTests {

    // MARK: - Initialization Tests

    /// Tests default initialization with no parameters.
    @Test("Default initialization creates configuration with iPad 9.7 inch")
    func testDefaultInitialization() {
        let configuration = AppScreenshotConfiguration()

        #expect(configuration.sizes.count == 1)
        #expect(configuration.locales == [.current])
        #expect(configuration.tileCount == 1)
    }

    /// Tests initialization with custom sizes.
    @Test("Initialization with custom sizes")
    func testInitializationWithCustomSizes() {
        let size1 = AppScreenshotSize.iPad97Inch()
        let size2 = AppScreenshotSize.iPad97Inch(size: .w2160h1620)

        let configuration = AppScreenshotConfiguration(size1, size2)

        #expect(configuration.sizes.count == 2)
        #expect(configuration.locales == [.current])
        #expect(configuration.tileCount == 1)
    }

    /// Tests initialization with options.
    @Test("Initialization with options")
    func testInitializationWithOptions() {
        let testLocales = [Locale(identifier: "en_US"), Locale(identifier: "ja_JP")]
        let configuration = AppScreenshotConfiguration(
            .iPad97Inch(),
            options: .locale(testLocales),
            .tiles(3)
        )

        #expect(configuration.sizes.count == 1)
        #expect(configuration.locales == testLocales)
        #expect(configuration.tileCount == 3)
    }

    // MARK: - Locale Configuration Tests

    /// Tests setting a single locale.
    @Test("Setting single locale")
    func testSetSingleLocale() {
        let configuration = AppScreenshotConfiguration()
        let testLocale = Locale(identifier: "en_US")

        let updatedConfiguration = configuration.locale(testLocale)

        #expect(updatedConfiguration.locales == [testLocale])
        #expect(configuration.locales == [.current])  // Original should be unchanged
    }

    /// Tests setting multiple locales.
    @Test("Setting multiple locales")
    func testSetMultipleLocales() {
        let configuration = AppScreenshotConfiguration()
        let testLocales = [
            Locale(identifier: "en_US"),
            Locale(identifier: "ja_JP"),
            Locale(identifier: "fr_FR"),
        ]

        let updatedConfiguration = configuration.locales(testLocales)

        #expect(updatedConfiguration.locales == testLocales)
        #expect(configuration.locales == [.current])  // Original should be unchanged
    }

    // MARK: - Tile Count Configuration Tests

    /// Tests setting tile count.
    @Test("Setting tile count")
    func testSetTileCount() {
        let configuration = AppScreenshotConfiguration()
        let testCount = 5

        let updatedConfiguration = configuration.tileCount(testCount)

        #expect(updatedConfiguration.tileCount == testCount)
        #expect(configuration.tileCount == 1)  // Original should be unchanged
    }

    /// Tests setting tile count with various values.
    @Test("Setting tile count with various values", arguments: [1, 2, 3, 5, 10])
    func testSetTileCountVariousValues(count: Int) {
        let configuration = AppScreenshotConfiguration()

        let updatedConfiguration = configuration.tileCount(count)

        #expect(updatedConfiguration.tileCount == count)
    }

    // MARK: - Environment Generation Tests

    /// Tests environment generation with default configuration.
    @Test("Environment generation with default configuration")
    func testEnvironmentGenerationDefault() {
        let configuration = AppScreenshotConfiguration()

        let environments = configuration.environments()

        #expect(environments.count == 1)

        let environment = environments[0]
        #expect(environment.locale == .current)
        #expect(environment.tileCount == 1)
        #expect(environment.canvasSize.width == environment.screenshotSize.width)
        #expect(environment.canvasSize.height == environment.screenshotSize.height)
    }

    /// Tests environment generation with multiple locales.
    @Test("Environment generation with multiple locales")
    func testEnvironmentGenerationMultipleLocales() {
        let testLocales = [
            Locale(identifier: "en_US"),
            Locale(identifier: "ja_JP"),
        ]
        let configuration = AppScreenshotConfiguration()
            .locales(testLocales)

        let environments = configuration.environments()

        #expect(environments.count == 2)
        #expect(environments[0].locale == testLocales[0])
        #expect(environments[1].locale == testLocales[1])
    }

    /// Tests environment generation with multiple sizes.
    @Test("Environment generation with multiple sizes")
    func testEnvironmentGenerationMultipleSizes() {
        let configuration = AppScreenshotConfiguration(
            .iPad97Inch(),
            .iPad97Inch(size: .w2160h1620)
        )

        let environments = configuration.environments()

        #expect(environments.count == 2)
        // Both should use the current locale
        #expect(environments.allSatisfy { $0.locale == .current })
    }

    /// Tests environment generation with tile count.
    @Test("Environment generation with tile count")
    func testEnvironmentGenerationWithTileCount() {
        let tileCount = 3
        let configuration = AppScreenshotConfiguration()
            .tileCount(tileCount)

        let environments = configuration.environments()

        #expect(environments.count == 1)

        let environment = environments[0]
        #expect(environment.tileCount == tileCount)
        #expect(environment.canvasSize.width == environment.screenshotSize.width * Double(tileCount))
        #expect(environment.canvasSize.height == environment.screenshotSize.height)
    }

    /// Tests environment generation with complex configuration.
    @Test("Environment generation with complex configuration")
    func testEnvironmentGenerationComplex() {
        let testLocales = [
            Locale(identifier: "en_US"),
            Locale(identifier: "ja_JP"),
        ]
        let tileCount = 2
        let configuration = AppScreenshotConfiguration(
            .iPad97Inch(),
            .iPad97Inch(size: .w2160h1620)
        )
        .locales(testLocales)
        .tileCount(tileCount)

        let environments = configuration.environments()

        // 2 sizes × 2 locales = 4 environments
        #expect(environments.count == 4)

        // Check that all combinations are present
        let localeCount = testLocales.count
        for (index, environment) in environments.enumerated() {
            let expectedLocale = testLocales[index % localeCount]
            #expect(environment.locale == expectedLocale)
            #expect(environment.tileCount == tileCount)
        }
    }

    // MARK: - Option Enum Tests

    /// Tests Option enum locale case.
    @Test("Option enum locale case")
    func testOptionEnumLocale() {
        let testLocales = [Locale(identifier: "en_US")]
        let option = AppScreenshotConfiguration.Option.locale(testLocales)

        switch option {
        case .locale(let locales):
            #expect(locales == testLocales)
        case .tiles:
            Issue.record("Expected locale case, got tiles")
        }
    }

    /// Tests Option enum tiles case.
    @Test("Option enum tiles case")
    func testOptionEnumTiles() {
        let testCount = 5
        let option = AppScreenshotConfiguration.Option.tiles(testCount)

        switch option {
        case .tiles(let count):
            #expect(count == testCount)
        case .locale:
            Issue.record("Expected tiles case, got locale")
        }
    }
}

// MARK: - Integration Tests

/// Tests for integration scenarios with AppScreenshotConfiguration.
@Suite("AppScreenshotConfiguration Integration Tests")
struct AppScreenshotConfigurationIntegrationTests {

    /// Tests method chaining with multiple configurations.
    @Test("Method chaining with multiple configurations")
    func testMethodChaining() {
        let configuration = AppScreenshotConfiguration()
            .locale(Locale(identifier: "en_US"))
            .tileCount(3)

        #expect(configuration.locales == [Locale(identifier: "en_US")])
        #expect(configuration.tileCount == 3)
    }

    /// Tests immutability of configuration objects.
    @Test("Configuration immutability")
    func testConfigurationImmutability() {
        let originalConfiguration = AppScreenshotConfiguration()
        let modifiedConfiguration =
            originalConfiguration
            .locale(Locale(identifier: "ja_JP"))
            .tileCount(5)

        // Original should remain unchanged
        #expect(originalConfiguration.locales == [.current])
        #expect(originalConfiguration.tileCount == 1)

        // Modified should have new values
        #expect(modifiedConfiguration.locales == [Locale(identifier: "ja_JP")])
        #expect(modifiedConfiguration.tileCount == 5)
    }

    /// Tests environments generation with realistic scenarios.
    @Test("Realistic environments generation")
    func testRealisticEnvironmentsGeneration() {
        let configuration = AppScreenshotConfiguration(
            .iPad97Inch(),
            options: .locale([
                Locale(identifier: "en_US"),
                Locale(identifier: "ja_JP"),
                Locale(identifier: "fr_FR"),
            ]),
            .tiles(2)
        )

        let environments = configuration.environments()

        // Should have 1 size × 3 locales = 3 environments
        #expect(environments.count == 3)

        // All environments should have correct tile count
        #expect(environments.allSatisfy { $0.tileCount == 2 })

        // All environments should have correct canvas width
        for environment in environments {
            let expectedCanvasWidth = environment.screenshotSize.width * 2.0
            #expect(environment.canvasSize.width == expectedCanvasWidth)
        }
    }
}
