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
                height: environment.screenshotSize.height * 0.9)
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
            sizes: AppScreenshotSize.iPadAll)
    }
    package enum AppScreenshotIPadMini: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPadMiniAll)
    }
    package enum AppScreenshotIpadPro11M4: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPadPro11M4All)
    }
    package enum AppScreenshotIpadAir11M2: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPadAir11M2All)
    }
    package enum AppScreenshotIpadPro13M4: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPadPro13M4All)
    }
    package enum AppScreenshotIpadAir13M2: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPadAir13M2All)
    }
    package enum AppScreenshotIPhone14: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone14All)
    }
    package enum AppScreenshotIPhone16Pro: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone16ProAll)
    }
    package enum AppScreenshotIPhone16: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone16All)
    }
    package enum AppScreenshotIPhone15Pro: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone15ProAll)
    }
    package enum AppScreenshotIPhone15: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone15All)
    }
    package enum AppScreenshotIPhone14Pro: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone14ProAll)
    }
    package enum AppScreenshotIPhone16ProMax: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone16ProMaxAll)
    }
    package enum AppScreenshotIPhone16Plus: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone16PlusAll)
    }
    package enum AppScreenshotIPhone15ProMax: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone15ProMaxAll)
    }
    package enum AppScreenshotIPhone15Plus: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone15PlusAll)
    }
    package enum AppScreenshotIPhone14ProMax: AppScreenshoSample {
        package static let configuration = AppScreenshotConfiguration(
            sizes: AppScreenshotSize.iPhone14ProMaxAll)
    }

    package enum AppScreenshotKitREADME: AppScreenshot {

        package static let configuration = AppScreenshotConfiguration(.iPhone69Inch()).count(4)

        package static func body(environment: AppScreenshotEnvironment) -> some View {
            ZStack {
                HStack(spacing: 0) {
                    Group {
                        VStack(spacing: 0) {
                            Spacer()
                                .frame(height: 400)
                            Text("Define screenshot with")
                                .font(.system(size: 180, weight: .black, design: .default))
                                .multilineTextAlignment(.center)
                            LinearGradient(
                                colors: [.pink, .purple, .blue],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                            .frame(width: 1200, height: 220)
                            .mask {
                                Text("SwiftUI")
                                    .font(.system(size: 220, weight: .black, design: .default))
                            }

                            Spacer()
                        }

                        VStack {
                            Spacer()
                                .frame(height: 400)
                            Text("Always\n up-to-date")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 180, weight: .black, design: .default))

                            Spacer()
                        }

                        VStack {
                            Spacer()
                                .frame(height: 400)
                            Text("Easy to preview,\nexport")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 180, weight: .black, design: .default))

                            Spacer()
                        }


                        VStack {
                            Spacer()
                                .frame(height: 400)

                            Text("Multilingual,\n multi-size")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 180, weight: .black, design: .default))

                            ZStack {

                                DeviceView {
                                    Text("你好，世界！")
                                        .font(.system(size: 78, weight: .bold, design: .default))
                                        .padding()
                                    Spacer()
                                }
                                .frame(width: 1200)
                                .rotationEffect(.degrees(-90))
                                .offset(x: 1000, y: -200)
                                .environment(
                                    \.deviceModel,
                                     AppScreenshotDevice(
                                        orientation: .portrait,
                                        color: .spaceGray,
                                        model: .iPadPro11M4
                                     )
                                )

                                DeviceView {
                                    Text("¡Hola, mundo!")
                                        .font(.system(size: 78, weight: .bold, design: .default))
                                        .padding()
                                    Spacer()
                                }
                                .frame(width: 1200)
                                .rotationEffect(.degrees(90))
                                .offset(x: -1000, y: -200)
                                .environment(
                                    \.deviceModel,
                                     AppScreenshotDevice(
                                        orientation: .portrait,
                                        color: .spaceGray,
                                        model: .iPadPro11M4
                                     )
                                )

                                DeviceView {
                                    Text("Hello, world!")
                                        .font(.system(size: 78, weight: .bold, design: .default))
                                        .padding()
                                    Spacer()
                                }
                                .frame(width: 1200)
                                .offset(x: 0, y: 1400)
                                .environment(
                                    \.deviceModel,
                                     AppScreenshotDevice(
                                        orientation: .portrait,
                                        color: .spaceGray,
                                        model: .iPadPro11M4
                                     )
                                )
                            }
                            .clipped()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                DeviceView {
                    NavigationStack {
                        List {
                            ForEach(0..<10) { index in
                                Text("Item \(index)")
                            }
                        }
                    }
                }
                .statusBarShown()
                .frame(width: 1000)
                .rotationEffect(.degrees(45))
                .position(x: environment.rect(for: 0).maxX * 1.5, y: environment.rect(for: 0).midY * 1.5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                LinearGradient(
                    gradient: Gradient(colors: [.cyan, .gray, .green]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }
}
struct AppScreenshotKitREADME_Previews: PreviewProvider {
    static var previews: some View {
        AppScreenshoSamples.AppScreenshotKitREADME.preview()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
