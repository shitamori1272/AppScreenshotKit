//
//  PNGDataConverter.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/04/25.
//

import SwiftUI

@MainActor
struct PNGDataConverter {
    /// Convert a SwiftUI view to image data in the specified format
    func convert<Content: View>(
        _ content: Content,
        rect: CGRect? = nil,
        scale: CGFloat = 1,
        imageFormat: AppScreenshotImageFormat = .png
    ) throws -> Data {
        #if canImport(UIKit)
            if let data = try renderInHostApp(
                content: content,
                rect: rect,
                scale: scale,
                imageFormat: imageFormat
            ) {
                return data
            }

            let controller = UIHostingController(rootView: content)
            if #available(iOS 16.4, *) {
                controller.safeAreaRegions = []
            }
            let view = controller.view!
            let targetSize = controller.view.intrinsicContentSize
            view.bounds = CGRect(origin: .zero, size: targetSize)
            view.backgroundColor = .clear

            let window = UIWindow()
            window.frame = CGRect(origin: .zero, size: targetSize)
            window.rootViewController = controller
            window.makeKeyAndVisible()

            view.sizeToFit()
            view.setNeedsLayout()
            view.layoutIfNeeded()

            // Move the view far off-screen before rendering.
            // This is intentional: positioning the view away from (0, 0) avoids
            // transient layout/animation artifacts and composition glitches that
            // can occur when rendering SwiftUI content into a UIKit-backed window,
            // particularly with newer Xcode / iOS toolchains (e.g. Xcode 26).
            // Do not change this without re-validating screenshot output.
            view.frame.origin = .init(x: 10_000, y: 10_000)
            let format = UIGraphicsImageRendererFormat()
            format.scale = scale
            format.opaque = false

            let rect = rect ?? CGRect(origin: .zero, size: targetSize)
            let renderer = UIGraphicsImageRenderer(size: rect.size, format: format)
            let render: (UIGraphicsImageRendererContext) -> Void = { ctx in
                ctx.cgContext.translateBy(x: -rect.origin.x, y: -rect.origin.y)
                view.layer.render(in: ctx.cgContext)
            }
            switch imageFormat {
            case .png:
                return renderer.pngData(actions: render)
            case .jpeg:
                return renderer.jpegData(
                    withCompressionQuality: imageFormat.clampedCompressionQuality,
                    actions: render
                )
            }
        #elseif canImport(AppKit)
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
        #endif
    }
}

#if canImport(UIKit)
    extension PNGDataConverter {
        fileprivate func renderInHostApp<Content: View>(
            content: Content,
            rect: CGRect?,
            scale: CGFloat,
            imageFormat: AppScreenshotImageFormat
        ) throws -> Data? {
            guard
                let scene = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first(where: { !$0.windows.isEmpty }),
                let keyWindow = scene.windows.first(where: \.isKeyWindow)
                    ?? scene.windows.first
            else { return nil }

            let nativeScale = scene.screen.scale
            let screenPointSize = scene.screen.bounds.size

            let controller = UIHostingController(rootView: content)
            if #available(iOS 16.4, *) {
                controller.safeAreaRegions = []
            }
            controller.view.backgroundColor = .clear

            let pixelSize = controller.view.intrinsicContentSize
            let pointSize = CGSize(
                width: pixelSize.width / nativeScale,
                height: pixelSize.height / nativeScale
            )

            // drawHierarchy clips outside the window; let the existing fallback
            // handle oversized compositions.
            guard
                pointSize.width <= screenPointSize.width,
                pointSize.height <= screenPointSize.height
            else { return nil }

            let originalRoot = keyWindow.rootViewController
            keyWindow.rootViewController = controller
            defer { keyWindow.rootViewController = originalRoot }

            controller.view.bounds = CGRect(origin: .zero, size: pixelSize)
            controller.view.transform = CGAffineTransform(
                scaleX: 1 / nativeScale,
                y: 1 / nativeScale
            )
            controller.view.center = CGPoint(
                x: pointSize.width / 2,
                y: pointSize.height / 2
            )
            controller.view.setNeedsLayout()
            controller.view.layoutIfNeeded()

            let cropPixelRect = rect ?? CGRect(origin: .zero, size: pixelSize)
            let cropPointRect = CGRect(
                x: cropPixelRect.origin.x / nativeScale,
                y: cropPixelRect.origin.y / nativeScale,
                width: cropPixelRect.size.width / nativeScale,
                height: cropPixelRect.size.height / nativeScale
            )

            let format = UIGraphicsImageRendererFormat()
            format.scale = nativeScale * scale
            format.opaque = false

            let renderer = UIGraphicsImageRenderer(size: cropPointRect.size, format: format)
            let render: (UIGraphicsImageRendererContext) -> Void = { ctx in
                ctx.cgContext.translateBy(
                    x: -cropPointRect.origin.x,
                    y: -cropPointRect.origin.y
                )
                controller.view.drawHierarchy(
                    in: controller.view.frame,
                    afterScreenUpdates: true
                )
            }

            switch imageFormat {
            case .png:
                return renderer.pngData(actions: render)
            case .jpeg:
                return renderer.jpegData(
                    withCompressionQuality: imageFormat.clampedCompressionQuality,
                    actions: render
                )
            }
        }
    }
#endif
