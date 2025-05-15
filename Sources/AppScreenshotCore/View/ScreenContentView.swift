//
//  ScreenContentView.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/04/25.
//

import SwiftUI

/// A view that renders the main screen content for a device, including status bar handling.
struct ScreenContentView<Content: View>: View {

    let content: Content
    @Environment(\.deviceModel) var model: DeviceViewModel
    @Environment(\.statusBarShown) var statusBarShown

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        HostingViewWrap {
            content
                .overlay(alignment: .top) {
                    if statusBarShown {
                        HStack(spacing: 0) {
                            Text("09:41")
                                .font(.system(size: 17, weight: .semibold))
                                .padding(.leading)
                                .padding(.leading)
                                .padding(.trailing, 6)

                            if let dynamicIdsand = model.dynamicIdsand {
                                Spacer()
                                    .frame(minWidth: dynamicIdsand.size.width)
                            } else {
                                Spacer()
                            }

                            HStack(spacing: 7) {

                                Image(systemName: "cellularbars")
                                    .font(.system(size: 17))
                                    .padding(.leading, 6)

                                Image(systemName: "wifi")
                                    .font(.system(size: 17))

                                Image(systemName: "battery.100percent")
                                    .font(.system(size: 17))
                                    .padding(.trailing)
                            }
                            .padding(.trailing)
                        }
                        .foregroundStyle(.primary)
                        .frame(height: model.safeAreaInsets.top)
                        .ignoresSafeArea()
                    }
                }
        }
        .frame(width: model.screenSize.width, height: model.screenSize.height)
        #if canImport(UIKit)
            .background(Color(uiColor: .systemBackground))
        #elseif canImport(AppKit)
            .background(Color(NSColor.windowBackgroundColor))
        #endif
        .clipShape(
            RoundedRectangle(
                cornerRadius: model.bezelRadius
            )
        )
    }
}
