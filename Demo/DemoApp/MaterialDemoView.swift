//
//  MaterialDemoView.swift
//  DemoApp
//

import SwiftUI

struct MaterialDemoView: View {
    private let materials: [(String, Material)] = [
        (".ultraThinMaterial", .ultraThinMaterial),
        (".thinMaterial", .thinMaterial),
        (".regularMaterial", .regularMaterial),
        (".thickMaterial", .thickMaterial),
    ]

    var body: some View {
        ZStack {
            MaterialDemoBackground()

            VStack(spacing: 80) {
                ForEach(materials, id: \.0) { title, material in
                    Text(title)
                        .materialCard(material)
                }
            }
            .padding(.top, 80)
        }
        .ignoresSafeArea()
    }
}

private struct MaterialDemoBackground: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                LinearGradient(
                    colors: [.red, .orange, .yellow, .green, .blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                VStack(spacing: 0) {
                    ForEach(0..<48, id: \.self) { index in
                        Rectangle()
                            .fill(index.isMultiple(of: 2) ? Color.black.opacity(0.35) : .clear)
                            .frame(height: proxy.size.height / 48)
                    }
                }

                HStack(spacing: 0) {
                    ForEach(0..<16, id: \.self) { index in
                        Rectangle()
                            .fill(index.isMultiple(of: 2) ? Color.white.opacity(0.22) : .clear)
                    }
                }
            }
        }
    }
}

extension View {
    fileprivate func materialCard(_ material: Material) -> some View {
        self
            .font(.system(size: 68, weight: .bold, design: .rounded))
            .foregroundStyle(.black.opacity(0.75))
            .frame(width: 980)
            .padding(.vertical, 52)
            .background(material, in: RoundedRectangle(cornerRadius: 44))
            .overlay {
                RoundedRectangle(cornerRadius: 44)
                    .stroke(.white.opacity(0.55), lineWidth: 3)
            }
    }
}
