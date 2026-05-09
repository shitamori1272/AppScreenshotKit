import SwiftUI

#if canImport(UIKit)
    import UIKit
#endif

@MainActor
struct PNGDataConverter {
    func convert<Content: View>(
        _ content: Content,
        rect: CGRect? = nil,
        scale: CGFloat = 1,
        imageFormat: AppScreenshotImageFormat = .png
    ) throws -> Data {
        #if canImport(UIKit)
            return try convertUIKit(
                content,
                rect: rect,
                scale: scale,
                imageFormat: imageFormat
            )
        #elseif canImport(AppKit)
            return convertAppKit(
                content,
                rect: rect,
                scale: scale,
                imageFormat: imageFormat
            )
        #endif
    }
}

#if canImport(UIKit)
    extension PNGDataConverter {
        fileprivate func convertUIKit<Content: View>(
            _ content: Content,
            rect: CGRect?,
            scale: CGFloat,
            imageFormat: AppScreenshotImageFormat
        ) throws -> Data {
            let controller = UIHostingController(rootView: content)
            if #available(iOS 16.4, *) {
                controller.safeAreaRegions = []
            }

            let view = controller.view!
            view.backgroundColor = .clear

            let targetSize = controller.sizeThatFits(
                in: CGSize(
                    width: CGFloat.greatestFiniteMagnitude,
                    height: CGFloat.greatestFiniteMagnitude
                )
            )
            let resolvedSize: CGSize
            if targetSize.width > 0, targetSize.height > 0 {
                resolvedSize = targetSize
            } else {
                resolvedSize = CGSize(width: 1290, height: 2796)
            }

            let keyWindowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first

            let screenScale = keyWindowScene?.screen.scale ?? UIScreen.main.scale
            let screenSize = keyWindowScene?.screen.bounds.size ?? UIScreen.main.bounds.size

            view.frame = CGRect(origin: .zero, size: resolvedSize)
            view.setNeedsLayout()
            view.layoutIfNeeded()

            let captureRect = rect ?? CGRect(origin: .zero, size: resolvedSize)

            let scaleFactorX = screenSize.width / resolvedSize.width
            let scaleFactorY = screenSize.height / resolvedSize.height
            let fitScale = min(scaleFactorX, scaleFactorY) * 1.0025

            if let keyWindowScene {
                let hiddenWindows = keyWindowScene.windows.filter { !$0.isHidden }
                hiddenWindows.forEach { $0.isHidden = true }

                let renderWindow = UIWindow(windowScene: keyWindowScene)
                renderWindow.frame = CGRect(origin: .zero, size: screenSize)
                renderWindow.backgroundColor = .systemBackground
                renderWindow.rootViewController = controller
                renderWindow.isHidden = false
                renderWindow.makeKeyAndVisible()

                view.transform = CGAffineTransform(scaleX: fitScale, y: fitScale)

                for _ in 0..<30 {
                    RunLoop.main.run(until: Date().addingTimeInterval(0.05))
                    view.setNeedsLayout()
                    view.layoutIfNeeded()
                }

                let rendererFormat = UIGraphicsImageRendererFormat()
                rendererFormat.scale = screenScale
                rendererFormat.opaque = false

                let renderer = UIGraphicsImageRenderer(size: screenSize, format: rendererFormat)
                let capturedData: Data
                switch imageFormat {
                case .png:
                    capturedData = renderer.pngData { ctx in
                        renderWindow.drawHierarchy(in: renderWindow.bounds, afterScreenUpdates: true)
                    }
                case .jpeg:
                    capturedData = renderer.jpegData(
                        withCompressionQuality: imageFormat.clampedCompressionQuality
                    ) { ctx in
                        renderWindow.drawHierarchy(in: renderWindow.bounds, afterScreenUpdates: true)
                    }
                }

                renderWindow.isHidden = true
                hiddenWindows.forEach { $0.isHidden = false }

                let targetPixelSize = CGSize(
                    width: captureRect.size.width * scale,
                    height: captureRect.size.height * scale
                )
                guard let sourceImage = UIImage(data: capturedData),
                    let cgSource = sourceImage.cgImage,
                    let scaledImage = cgSource.resized(to: targetPixelSize)
                else { return capturedData }

                switch imageFormat {
                case .png:
                    return scaledImage.pngData() ?? capturedData
                case .jpeg:
                    return UIImage(cgImage: scaledImage).jpegData(
                        compressionQuality: imageFormat.clampedCompressionQuality
                    ) ?? capturedData
                }
            }

            view.transform = CGAffineTransform(scaleX: fitScale, y: fitScale)

            for _ in 0..<20 {
                RunLoop.main.run(until: Date().addingTimeInterval(0.05))
                view.setNeedsLayout()
                view.layoutIfNeeded()
            }

            let rendererFormat = UIGraphicsImageRendererFormat()
            rendererFormat.scale = scale
            rendererFormat.opaque = false

            let renderer = UIGraphicsImageRenderer(size: captureRect.size, format: rendererFormat)
            switch imageFormat {
            case .png:
                return renderer.pngData { ctx in
                    ctx.cgContext.translateBy(x: -captureRect.origin.x, y: -captureRect.origin.y)
                    view.layer.render(in: ctx.cgContext)
                }
            case .jpeg:
                return renderer.jpegData(
                    withCompressionQuality: imageFormat.clampedCompressionQuality
                ) { ctx in
                    ctx.cgContext.translateBy(x: -captureRect.origin.x, y: -captureRect.origin.y)
                    view.layer.render(in: ctx.cgContext)
                }
            }
        }
    }
#endif

#if canImport(AppKit) && !canImport(UIKit)
    import AppKit

    extension PNGDataConverter {
        fileprivate func convertAppKit<Content: View>(
            _ content: Content,
            rect: CGRect?,
            scale: CGFloat,
            imageFormat: AppScreenshotImageFormat
        ) -> Data {
            let view = NSHostingView(rootView: content)
            let targetSize = view.intrinsicContentSize
            view.frame = NSRect(origin: .zero, size: targetSize)

            guard let bitmapRep = view.bitmapImageRepForCachingDisplay(in: view.bounds) else {
                return Data()
            }

            view.cacheDisplay(in: view.bounds, to: bitmapRep)
            let data: Data?
            switch imageFormat {
            case .png:
                data = bitmapRep.representation(using: .png, properties: [:])
            case .jpeg:
                data = bitmapRep.representation(
                    using: .jpeg,
                    properties: [.compressionFactor: imageFormat.clampedCompressionQuality]
                )
            }
            guard let data else { return Data() }

            return data
        }
    }
#endif

#if canImport(UIKit)
    extension CGImage {
        func resized(to size: CGSize) -> CGImage? {
            guard let context = CGContext(
                data: nil,
                width: Int(size.width),
                height: Int(size.height),
                bitsPerComponent: 8,
                bytesPerRow: 0,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            ) else { return nil }
            context.interpolationQuality = .high
            context.draw(self, in: CGRect(origin: .zero, size: size))
            return context.makeImage()
        }

        func pngData() -> Data? {
            guard let mutableData = CFDataCreateMutable(nil, 0),
                let destination = CGImageDestinationCreateWithData(
                    mutableData, "public.png" as CFString, 1, nil
                )
            else { return nil }
            CGImageDestinationAddImage(destination, self, nil)
            CGImageDestinationFinalize(destination)
            return mutableData as Data
        }
    }
#endif
