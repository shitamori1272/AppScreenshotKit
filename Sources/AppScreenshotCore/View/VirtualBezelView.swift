//  VirtualBezelView.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/04/25.
//

import SwiftUI

/// A device-agnostic view that simulates a bezel for screenshot rendering.
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
        }
    }
    .environment(
        \.deviceModel,
        AppScreenshotDevice(
            orientation: .portrait,
            color: .black,
            model: .iPhone17
        )
    )
    .frame(width: 600, height: 600)
}
