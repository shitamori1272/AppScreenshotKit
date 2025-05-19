import Foundation
import Testing
@testable import AppScreenshotKitCLI

struct RSSHandlerTests {
    @Test
    func fetch_returnsCorrectDMGLinkURL() {
        let xml = """
        <rss>
            <channel>
                <item>
                    <link>https://example.com/test.dmg</link>
                </item>
            </channel>
        </rss>
        """
        let pattern = #"https://.*?\.dmg"#
        let regex = try? NSRegularExpression(pattern: pattern)
        let matches = regex?.matches(in: xml, range: NSRange(xml.startIndex..., in: xml)) ?? []
        let urls = matches.compactMap {
            Range($0.range, in: xml).flatMap { URL(string: String(xml[$0])) }
        }
        #expect(urls.first?.absoluteString == "https://example.com/test.dmg")
    }
}
