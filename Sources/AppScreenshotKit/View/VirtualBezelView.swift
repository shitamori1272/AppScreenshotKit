import SwiftUI

// Modified to be device-agnostic
struct VirtualBezelView<Content: View>: View {
    let content: Content
    @Environment(\.deviceModel) var model: DeviceViewModel

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ScaleView {
            ZStack(alignment: .center) {
                ScreenContentView {
                    content
                }

                RoundedRectangle(cornerRadius: model.bezelRadius, style: .continuous)
                    .inset(by: -model.bezelWidth / 2)
                    .stroke(lineWidth: model.bezelWidth)
                    .foregroundStyle(.black)
                    .frame(width: model.screenSize.width, height: model.screenSize.height)
                    .overlay {
                        if let dynamicIsland = model.dynamicIdsand {
                            VStack {
                                RoundedRectangle(
                                    cornerRadius: dynamicIsland.radius
                                )
                                .foregroundStyle(.black)
                                .frame(
                                    width: dynamicIsland.size.width,
                                    height: dynamicIsland.size.height
                                )
                                .padding(.top, dynamicIsland.topPadding)
                                Spacer()
                            }
                        }
                    }

                RoundedRectangle(cornerRadius: model.bezelRadius, style: .continuous)
                    .inset(by: -model.deviceFrameWidth / 2 - model.bezelWidth)
                    .stroke(lineWidth: model.deviceFrameWidth)
                    .foregroundStyle(model.deviceColor)
                    .frame(width: model.screenSize.width, height: model.screenSize.height)
            }
            .frame(width: model.deviceViewSize.width, height: model.deviceViewSize.height)
        }
    }
}

/// UIViewControllerRepresentableプロトコルを準拠するViewControllerを作成する
struct HostingViewWrap<Content: View>: UIViewControllerRepresentable {

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    // UIViewControllerを作成するメソッド
    func makeUIViewController(context: Context) -> UIViewController {
        // 指定のUIViewControllerを作成する
        let myViewController = UIHostingController(
            rootView: content
        )

        // Use safeAreaInsets from environment's deviceModel if available
        let deviceModel = context.environment.deviceModel
        let insets = deviceModel.safeAreaInsets
        myViewController.additionalSafeAreaInsets = UIEdgeInsets(
            top: insets.top,
            left: insets.leading,
            bottom: insets.bottom,
            right: insets.trailing
        )

        return myViewController
    }

    // UIViewControllerを更新するメソッド
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update safe area insets if device model changes
        let deviceModel = context.environment.deviceModel
        let insets = deviceModel.safeAreaInsets
        uiViewController.additionalSafeAreaInsets = UIEdgeInsets(
            top: insets.top,
            left: insets.leading,
            bottom: insets.bottom,
            right: insets.trailing
        )
    }
}

#Preview {
    VirtualBezelView {
        NavigationStack {
            VStack {
                Text("Helloworkd")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.red)
            }
            .navigationTitle("Hellowold")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    .environment(
        \.deviceModel,
         AppScreenshotDevice(
            orientation: .portrait,
            color: .black,
            model: .iPhone16
         )
    )
    .frame(width: 600, height: 600)
}
