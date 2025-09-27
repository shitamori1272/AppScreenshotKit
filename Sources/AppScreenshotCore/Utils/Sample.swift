//
//  AppScreenshoSamples.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/11.
//

import SwiftUI

package protocol AppScreenshoSample: AppScreenshot {
}

extension AppScreenshoSample {
    @MainActor package static func body(environment: AppScreenshotEnvironment) -> some View {
        VStack {
            DeviceView {
                NavigationStack {
                    VStack {
                        Text("Helloworld")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.green)
                    }
                    .navigationTitle("Hellowold")
                    #if os(iOS)
                        .navigationBarTitleDisplayMode(.inline)
                    #endif
                }
            }
            .statusBarShown()
            .frame(
                width: environment.screenshotSize.width * 0.9,
                height: environment.screenshotSize.height * 0.9
            )
        }.background(.orange)
    }
}

package enum AppScreenshoSamples {

    package enum AppScreenshotAny: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.all
                .filter { $0.device.orientation == .portrait }
        )
    }

    package enum AppScreenshotIPad: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPadAll
        )
    }
    package enum AppScreenshotIPadMini: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPadMiniAll
        )
    }
    package enum AppScreenshotIpadPro11M4: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPadPro11M4All
        )
    }
    package enum AppScreenshotIpadAir11M2: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPadAir11M2All
        )
    }
    package enum AppScreenshotIpadPro13M4: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPadPro13M4All
        )
    }
    package enum AppScreenshotIpadAir13M2: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPadAir13M2All
        )
    }
    package enum AppScreenshotIPhone14: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone14All
        )
    }
    package enum AppScreenshotIPhone16Pro: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone16ProAll
        )
    }
    package enum AppScreenshotIPhone17Pro: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone17ProAll
        )
    }
    package enum AppScreenshotIPhone16: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone16All
        )
    }
    package enum AppScreenshotIPhone17: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone17All
        )
    }
    package enum AppScreenshotIPhone15Pro: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone15ProAll
        )
    }
    package enum AppScreenshotIPhone15: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone15All
        )
    }
    package enum AppScreenshotIPhone14Pro: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone14ProAll
        )
    }
    package enum AppScreenshotIPhone16ProMax: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone16ProMaxAll
        )
    }
    package enum AppScreenshotIPhone17ProMax: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone17ProMaxAll
        )
    }
    package enum AppScreenshotIPhone16Plus: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone16PlusAll
        )
    }
    package enum AppScreenshotIPhoneAir: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhoneAirAll
        )
    }
    package enum AppScreenshotIPhone15ProMax: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone15ProMaxAll
        )
    }
    package enum AppScreenshotIPhone15Plus: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone15PlusAll
        )
    }
    package enum AppScreenshotIPhone14ProMax: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone14ProMaxAll
        )
    }
}
