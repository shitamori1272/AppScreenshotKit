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
    public static func preview(environmentPredicate: ((AppScreenshotEnvironment) -> Bool)? = nil)
        -> some View
    {
        var environments = configuration.environments()
        if let predicate = environmentPredicate {
            environments = environments.filter(predicate)
        }

        return ScaleView {
            VStack {
                ForEach(environments, id: \.self) { environment in
                    screenshotView(environment: environment)
                        .overlay {
                            if configuration.count > 1 {
                                VerticalLinesView(divisionCount: configuration.count)
                            }
                        }
                }
            }
        }
    }

    /**
     * Creates a preview of the screenshot within a device bezel for SwiftUI previews.
     *
     * This method shows how the screenshot will appear within the physical device frame,
     * providing a more realistic representation of the final App Store screenshot.
     *
     * - Returns: A SwiftUI view displaying the screenshot within a device bezel.
     */
    @MainActor
    public static func bezelPreview(
        environmentPredicate: ((AppScreenshotEnvironment) -> Bool)? = nil
    ) -> some View {
        var environments = configuration.environments()
        if let predicate = environmentPredicate {
            environments = environments.filter(predicate)
        }

        return ScaleView {
            VStack {
                ForEach(environments, id: \.self) { environment in
                    screenshotView(environment: environment)
                        .overlay {
                            if configuration.count > 1 {
                                VerticalLinesView(divisionCount: configuration.count)
                            }
                        }
                }
            }
        }
    }
}

/// Example implementation of a screenshot generator
struct SampleScreenshotGenerator: AppScreenshot {
    /// Custom configuration with multiple screenshots
    static let configuration =
        AppScreenshotConfiguration(
            .iPhone69Inch(model: .iPhone15Plus(color: .yellow)),
            .iPad130Inch()
        )
        .locales([Locale(identifier: "ja_JP"), Locale(identifier: "en_US")])

    /// The content to display in the screenshot
    @MainActor
    public static func body(environment: AppScreenshotEnvironment) -> some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue, .black]),
                startPoint: .leading, endPoint: .trailing
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                Text(
                    environment.locale.language.languageCode == .japanese ? "サンプルアプリ" : "Sample App"
                )
                .font(.largeTitle)
                .foregroundColor(.white)

                Spacer()
                DeviceView {
                    Text("Screen Content")
                        .font(.title)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(uiColor: .systemBackground))
                }
                .frame(width: 1000, height: 1500)
                .rotationEffect(.degrees(50))
                Spacer()
                Text("AppStore Screenshot Generator")
                    .foregroundColor(.white)
            }
            .environment(\.colorScheme, .dark)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    HStack {
        SampleScreenshotGenerator.preview()
        SampleScreenshotGenerator.preview()
    }
}
