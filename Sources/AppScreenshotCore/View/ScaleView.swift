//
//  ScaleView.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/09.
//

import SwiftUI

struct ScaleView<Content: View>: View {

    @State var scale: CGFloat = 0.1
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        GeometryReader { containerGeometry in
            let containerGeometrySize = containerGeometry.size
            content
                .onGeometryChange(for: CGFloat.self) { geometry in
                    let contentSize = geometry.size
                    let containerSize = containerGeometrySize
                    let widthScale = containerSize.width / contentSize.width
                    let heightScale = containerSize.height / contentSize.height
                    return min(widthScale, heightScale)
                } action: { newScale in
                    scale = newScale
                }
                .scaleEffect(scale)
                .position(x: containerGeometry.size.width / 2, y: containerGeometry.size.height / 2)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
