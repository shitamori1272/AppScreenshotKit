//
//  PNGDataConverter.swift
//  FocusForFun
//
//  Created by Shuhei Shitamori on 2025/04/25.
//

import SwiftUI


@MainActor
struct PNGDataConverter {
    /// Convert a SwiftUI view to PNG Data
    func convert<Content: View>(_ content: Content, rect: CGRect? = nil, scale: CGFloat = 1) throws -> Data {
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
        controller.view.setNeedsLayout()
        controller.view.layoutIfNeeded()

        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        format.opaque = false

        let rect = rect ?? CGRect(origin: .zero, size: targetSize)
        let renderer = UIGraphicsImageRenderer(size: rect.size, format: format)
        return renderer.pngData { ctx in
            ctx.cgContext.translateBy(x: -rect.origin.x, y: -rect.origin.y)
            view.layer.render(in: ctx.cgContext)
        }
    }
}
