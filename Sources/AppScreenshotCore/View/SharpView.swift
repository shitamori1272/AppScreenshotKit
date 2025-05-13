//
//  SharpView.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/10.
//

#if canImport(UIKit)
import SwiftUI
import UIKit

struct SharpView<Content: View>: UIViewRepresentable {

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    // MARK: - UIViewRepresentable
      func makeUIView(context: Context) -> UIImageView {
          let imageView = UIImageView()
          imageView.contentMode = .scaleAspectFit
          imageView.backgroundColor = .clear
          imageView.image = makeUIImage(context: context)
          return imageView
      }

      func updateUIView(_ uiView: UIImageView, context: Context) {
          uiView.image = makeUIImage(context: context)
      }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIViewType, context: Context) -> CGSize? {
        guard let width = proposal.width, let height = proposal.height else {
            return nil
        }
        return .init(width: width, height: height)
    }

    private func makeUIImage(context: Context) -> UIImage {
        let pngDataConverter = PNGDataConverter()
        guard let pngData = try? pngDataConverter.convert(
            content
                .environment(\.deviceModel, context.environment.deviceModel),
            scale: 3
        ),
              let image = UIImage(data: pngData) else {
            return UIImage()
        }
        return image
    }
}

#endif
