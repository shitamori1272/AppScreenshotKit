import Foundation
import Testing

@testable import AppScreenshotKitCLI

struct RSSHandlerTests {
    let urlSessionMock = URLSessionMock()
    let rssURL = URL(string: "https://example.com/feed.rss")!

    @Test
    func test_fetch_success() async throws {
        let expectedURL = URL(string: "https://example.com/product.dmg")!
        let rssXML = """
            <rss>
                <channel>
                    <title>Test Feed</title>
                    <item>
                        <title>Test Item</title>
                        <link>https://example.com/product.dmg</link>
                    </item>
                </channel>
            </rss>
            """

        urlSessionMock.dataHandler = { url in
            #expect(url.absoluteString == self.rssURL.absoluteString)
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (rssXML.data(using: .utf8)!, response)
        }

        let rssHandler = RSSHandler(rssURL: rssURL, urlSession: urlSessionMock)
        let content = try await rssHandler.fetch()

        #expect(content.dmgLinkURL.absoluteString == expectedURL.absoluteString)
        #expect(urlSessionMock.dataCallCount == 1)
    }

    @Test
    func test_fetch_invalidUtf8Data() async {
        urlSessionMock.dataHandler = { _ in
            let invalidData = Data([0xFF, 0xFE, 0xFD])  // Invalid UTF-8 sequence
            let response = HTTPURLResponse(
                url: self.rssURL,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (invalidData, response)
        }

        let rssHandler = RSSHandler(rssURL: rssURL, urlSession: urlSessionMock)

        // エラーがスローされるかチェック
        var didThrowError = false
        var capturedError: Error?

        do {
            _ = try await rssHandler.fetch()
        } catch {
            didThrowError = true
            capturedError = error
        }

        #expect(didThrowError)

        if let cliError = capturedError as? CLIError {
            #expect(cliError.message.contains("Failed to parse RSS feed as UTF-8"))
        } else {
            let errorType = String(describing: type(of: capturedError))
            #expect(false && errorType.isEmpty, "Expected CLIError but got \(errorType)")
        }
    }

    @Test
    func test_fetch_noDmgLinkFound() async {
        let rssXML = """
            <rss>
                <channel>
                    <title>Test Feed</title>
                    <item>
                        <title>Test Item</title>
                        <link>https://example.com/no-dmg-link-here.html</link>
                    </item>
                </channel>
            </rss>
            """

        urlSessionMock.dataHandler = { _ in
            let response = HTTPURLResponse(
                url: self.rssURL,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (rssXML.data(using: .utf8)!, response)
        }

        let rssHandler = RSSHandler(rssURL: rssURL, urlSession: urlSessionMock)

        // エラーがスローされるかチェック
        var didThrowError = false
        var capturedError: Error?

        do {
            _ = try await rssHandler.fetch()
        } catch {
            didThrowError = true
            capturedError = error
        }

        #expect(didThrowError)

        if let cliError = capturedError as? CLIError {
            #expect(cliError.message.contains("No DMG link found in the RSS feed"))
        } else {
            let errorType = String(describing: type(of: capturedError))
            #expect(false && errorType.isEmpty, "Expected CLIError but got \(errorType)")
        }
    }

    @Test
    func test_fetch_networkError() async {
        struct TestError: Error {
            let message: String
        }

        urlSessionMock.dataHandler = { _ in
            throw TestError(message: "Network connection failed")
        }

        let rssHandler = RSSHandler(rssURL: rssURL, urlSession: urlSessionMock)

        // エラーがスローされるかチェック
        var didThrowError = false
        var capturedError: Error?

        do {
            _ = try await rssHandler.fetch()
        } catch {
            didThrowError = true
            capturedError = error
        }

        #expect(didThrowError)
        #expect(capturedError is TestError)
    }
}
