//
//  LocaleDemo.swift
//  Demo
//
//  Created by Shuhei Shitamori on 2025/05/15.
//

import AppScreenshotKit
import SwiftUI

@AppScreenshot(.iPhone69Inch(), options: .locale([Locale(identifier: "ja_JP"),Locale(identifier: "en_US")]))
struct LocaleDemo: View {

    @Environment(\.appScreenshotEnvironment) var environment

    var body: some View {
        VStack {

            Spacer().frame(height: 100)

            Text("Locale Demo", bundle: .module)
                .font(.system(size: 150, weight: .bold))

            Spacer()

            DeviceView {
                DemoAppView()
            }
            .frame(height: environment.screenshotSize.height * 0.7)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    LocaleDemo.preview()
}


