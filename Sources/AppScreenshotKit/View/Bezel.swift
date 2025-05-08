import SwiftUI

/// A view that renders app content within a device bezel frame
struct Bezel<Content: View>: View {
    @Environment(\.deviceModel) var model: DeviceViewModel
    let bezelImageData: Data
    let content: Content

    init(bezelImageData: Data, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.bezelImageData = bezelImageData
    }

    var body: some View {
        bezelImage
            .resizable()
            .aspectRatio(contentMode: .fit)
            .background {
                GeometryReader { proxy in
                    ScreenContentView {
                        content
                    }
                    .scaleEffect(
                        CGSize(
                            width: proxy.size.width / model.deviceViewSize.width,
                            height: proxy.size.height / model.deviceViewSize.height
                        )
                    )
                    .position(x: proxy.frame(in: .local).midX, y: proxy.frame(in: .local).midY)
                }
            }
    }

    var bezelImage: Image {
        let image = UIImage(data: bezelImageData)
        return Image(uiImage: image ?? UIImage())
    }
}

/// UIViewControllerRepresentableプロトコルを準拠するViewControllerを作成する
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
