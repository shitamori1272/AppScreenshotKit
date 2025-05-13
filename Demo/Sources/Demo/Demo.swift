// The Swift Programming Language
// https://docs.swift.org/swift-book

import AppScreenshotKit
import SwiftUI

@AppScreenshot(.iPhone69Inch(), .iPad130Inch(), options: .tiles(4))
struct READMEDemo: View {

    @Environment(\.appScreenshotEnvironment) var environment

    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Group {
                    VStack(spacing: 0) {
                        TitleView(title: "Define screenshot with")

                        Text("SwiftUI")
                            .font(.system(size: 220, weight: .black, design: .default))
                            .foregroundStyle(
                                .linearGradient(
                                    colors: [.pink, .purple, .blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Spacer().frame(height: 180)

                        Image(.swiftUIIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 1000)

                        Spacer()
                    }

                    VStack {
                        TitleView(title: "Always\n up-to-date\nwith your code")

                        Spacer()
                    }

                    VStack {
                        TitleView(title: "Easy to preview,\nexport")

                        Spacer()

                        Image(.screenshot)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                            .shadow(radius: 100)
                            .padding(.horizontal, 50)

                        Spacer()
                    }

                    VStack {
                        TitleView(title: "Multilingual,\n multi-size")
                        ZStack {
                            DeviceView {
                                VStack {
                                    Text("你好，世界！")
                                        .font(.system(size: 60, design: .default))
                                        .padding()
                                    Spacer()
                                }
                            }
                            .frame(width: 1200)
                            .rotationEffect(.degrees(-90))
                            .offset(x: 1200, y: -200)

                            DeviceView {
                                VStack {
                                    Text("¡Hola, mundo!")
                                        .font(.system(size: 60, design: .default))
                                        .padding()
                                    Spacer()
                                }
                            }
                            .frame(width: 1200)
                            .rotationEffect(.degrees(90))
                            .offset(x: -1200, y: -200)

                            DeviceView {
                                VStack {
                                    Text("Hello, world!")
                                        .font(.system(size: 60, design: .default))
                                        .padding()
                                    Spacer()
                                }
                            }
                            .frame(width: 1200)
                            .offset(x: 0, y: 1400)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                    .navigationTitle("Navigation")
                    .navigationBarTitleDisplayMode(.inline)
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
                gradient: Gradient(colors: [.cyan, .orange]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

struct TitleView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 180, weight: .black, design: .default))
            .multilineTextAlignment(.center)
            .padding(.top, 400)
    }
}


#Preview(traits: .sizeThatFitsLayout) {
    READMEDemo.preview()
        .frame(width: 5280/2, height: 2868/2)
}
