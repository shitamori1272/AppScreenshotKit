// import SwiftUI
// import Testing
// import CoreImage
// import CoreImage.CIFilterBuiltins

// @testable import AppScreenshotKit

// @Suite
// struct ScreenShotGeneratorTests {

//     let packageRootURL = URL(fileURLWithPath: #filePath)
//         .deletingLastPathComponent()
//         .deletingLastPathComponent()
//         .deletingLastPathComponent()

// #if canImport(UIKit)
//     @Test(
//         arguments: [
// //            AppScreenshotIPad.self as any AppScreenshot.Type,
// //            AppScreenshotIPadMini.self as any AppScreenshot.Type,
// //            AppScreenshotIpadPro11M4.self as any AppScreenshot.Type,
// //            AppScreenshotIpadAir11M2.self as any AppScreenshot.Type,
// //            AppScreenshotIpadPro13M4.self as any AppScreenshot.Type,
// //            AppScreenshotIpadAir13M2.self as any AppScreenshot.Type,
// //            AppScreenshotIPhone14.self as any AppScreenshot.Type,
// //            AppScreenshotIPhone16Pro.self as any AppScreenshot.Type,
// //            AppScreenshotIPhone16.self as any AppScreenshot.Type,
// //            AppScreenshotIPhone15Pro.self as any AppScreenshot.Type,
// //            AppScreenshotIPhone15.self as any AppScreenshot.Type,
// //            AppScreenshotIPhone14Pro.self as any AppScreenshot.Type,
// //            AppScreenshotIPhone16ProMax.self as any AppScreenshot.Type,
// //            AppScreenshotIPhone16Plus.self as any AppScreenshot.Type,
// //            AppScreenshotIPhone15ProMax.self as any AppScreenshot.Type,
// //            AppScreenshotIPhone15Plus.self as any AppScreenshot.Type,
// //            AppScreenshotIPhone14ProMax.self as any AppScreenshot.Type,
//             SampleScreenshotGenerator.self
//         ]
//     )
//     func generateScreenShots(screenshot: any AppScreenshot.Type) async throws {

//         let context = CIContext()

//         let virualBezelImages = try await screenshot.export()
//         let realBezelImages = try await screenshot.export(
//             resourceBaseURL: packageRootURL.appending(path: "Sources/AppScreenshotKit/Resources/AppleDesignResource")
//         )

//         let compareResults = try zip(virualBezelImages, realBezelImages).map { virtual, real in
//             let virtualCIImage = CIImage(data: virtual.pngData)
//             let realCIImage = CIImage(data: real.pngData)
//             let diffFilter = CIFilter.colorAbsoluteDifference()
//             diffFilter.inputImage = virtualCIImage
//             diffFilter.inputImage2 = realCIImage
//             let diffCIImage = try #require(diffFilter.outputImage)

//             let cgImage = try #require(context.createCGImage(diffCIImage, from: diffCIImage.extent))
//             let uiImage = UIImage(cgImage: cgImage)

//             let averageFilter = CIFilter.areaAverage()
//             averageFilter.inputImage = diffCIImage
//             averageFilter.extent = diffCIImage.extent
//             let averageCIImage = try #require(averageFilter.outputImage)

//             var bitmap = [UInt8](repeating: 0, count: 4)
//             context.render(
//                 averageCIImage,
//                 toBitmap: &bitmap,
//                 rowBytes: 4,
//                 bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
//                 format: .RGBA8,
//                 colorSpace: nil
//             )
//             let averageDiff = bitmap.reduce(0) { Int($0) + Int($1) } / bitmap.count

//             let virtualUIImage = try #require(UIImage(data: virtual.pngData))
//             let realUIImage = try #require(UIImage(data: real.pngData))

//             return CompareResult(
//                 environment: virtual.environment,
//                 virtual: virtualUIImage,
//                 real: realUIImage,
//                 diff: uiImage,
//                 averageDiff: averageDiff
//             )
//         }

//         try compareResults.forEach {

//             let mergedSize = CGSize(
//                 width: $0.virtual.size.width * 3,
//                 height: $0.virtual.size.height
//             )

//             let images = [$0.real, $0.virtual, $0.diff]
//             UIGraphicsBeginImageContextWithOptions(mergedSize, false, 0.0)
//             for (index, image) in images.enumerated() {
//                 let origin = CGPoint(x: $0.virtual.size.width * CGFloat(index), y: 0)
//                 image.draw(at: origin)
//             }
//             let combinedImage = try #require(UIGraphicsGetImageFromCurrentImageContext())
//             UIGraphicsEndImageContext()

//             let fileName = "\($0.environment.device.model.rawValue) - \($0.environment.device.color.rawValue) - \($0.environment.device.orientation.rawValue).png"
//             try FileManager.default.createDirectory(
//                 atPath: packageRootURL.appending(path: "Tests/AppScreenshotKitTests/Results/Compare").path(),
//                 withIntermediateDirectories: true
//             )
//             FileManager.default
//                 .createFile(
//                     atPath: packageRootURL
//                         .appending(path: "Tests/AppScreenshotKitTests/Results/Compare/\(fileName)")
//                         .path(percentEncoded: false),
//                     contents: combinedImage.pngData()!
//                 )
//         }
//     }
// #endif
// }

// #if canImport(UIKit)
// struct CompareResult {
//     let environment: AppScreenshotEnvironment
//     let virtual: UIImage
//     let real: UIImage
//     let diff: UIImage
//     let averageDiff: Int
// }
// #endif
