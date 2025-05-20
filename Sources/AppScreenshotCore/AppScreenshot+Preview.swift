//
//  File.swift
//  FocusForFun
//
//  Created by Shuhei Shitamori on 2025/04/25.
//

import Foundation
import SwiftUI

// MARK: - Preview Extension
extension AppScreenshot {
    /**
     * Creates a preview of the screenshot for use in SwiftUI previews.
     *
     * This method provides a convenient way to preview how your App Store screenshots
     * will look during development without generating the actual export files.
     *
     * - Returns: A SwiftUI view displaying the screenshot with its configured environment.
     */
    @MainActor
    public static func preview(
        environmentPredicate: ((AppScreenshotEnvironment) -> Bool)? = nil
    )
        -> some View
    {
        var environments = configuration.environments()
        if let predicate = environmentPredicate {
            environments = environments.filter(predicate)
        }

        let maxPreviewWidth = 2000.0
        let maxPreviewHeight = 2000.0
        let canvasSpace: CGFloat = 50.0

        let actualWidth = environments.map(\.canvasSize.width).max() ?? 0
        let actualHeight =
            environments.map(\.canvasSize.height).reduce(0, +) + (canvasSpace * CGFloat(environments.count - 1))

        let preferredPreviewScale = min(maxPreviewWidth / actualWidth, maxPreviewHeight / actualHeight, 1)

        let preferredPreviewWidth = actualWidth * preferredPreviewScale
        let preferredPreviewHeight = actualHeight * preferredPreviewScale

        return PreviewLayout(preferredSize: CGSize(width: preferredPreviewWidth, height: preferredPreviewHeight)) {
            ScaleView {
                VStack(spacing: canvasSpace) {
                    ForEach(environments, id: \.self) { environment in
                        screenshotView(environment: environment)
                            .overlay {
                                if configuration.tileCount > 1 {
                                    VerticalLinesView(divisionCount: configuration.tileCount)
                                }
                            }
                    }
                }
            }
        }
    }
}

private struct PreviewLayout: Layout {

    let preferredSize: CGSize

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        return preferredSize
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard let subview = subviews.first else { return }
        subview.place(at: .init(x: bounds.midX, y: bounds.midY), anchor: .center, proposal: proposal)
    }
}
