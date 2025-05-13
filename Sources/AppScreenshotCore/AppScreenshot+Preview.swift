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
                            if configuration.tileCount > 1 {
                                VerticalLinesView(divisionCount: configuration.tileCount)
                            }
                        }
                }
            }
        }
    }
}
