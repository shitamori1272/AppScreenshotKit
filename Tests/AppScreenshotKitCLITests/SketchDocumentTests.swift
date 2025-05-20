import Foundation
import Testing

@testable import AppScreenshotKitCLI

struct SketchDocumentTests {
    @Test
    func imageNameMap_returnsCorrectMap() throws {
        let json = """
            {
                "layers": [
                    {
                        "name": "Layer1",
                        "layers": [
                            {
                                "name": "Bitmap1",
                                "image": { "filePath": "path/to/image1.png", "_ref": "dummy1" }
                            }
                        ]
                    },
                    {
                        "name": "Layer2",
                        "layers": [
                            {
                                "name": "Bitmap2",
                                "image": { "filePath": "path/to/image2.png", "_ref": "dummy2" }
                            }
                        ]
                    }
                ]
            }
            """
        let data = json.data(using: .utf8)!
        let page = try JSONDecoder().decode(SketchPage.self, from: data)
        let map = try page.imageNameMap()
        #expect(map["Layer1"] == "dummy1")
        #expect(map["Layer2"] == "dummy2")
    }
}
