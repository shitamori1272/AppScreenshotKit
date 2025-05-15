//
//  VerticalLinesView.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/04/25.
//

import SwiftUI

/// View that draws vertical lines to help with screenshot framing.
struct VerticalLinesView: View {
    let divisionCount: Int

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<divisionCount, id: \.self) { index in
                    Path { path in
                        let xPosition =
                            CGFloat(index + 1) / CGFloat(divisionCount) * geometry.size.width
                        path.move(to: CGPoint(x: xPosition, y: 0))
                        path.addLine(to: CGPoint(x: xPosition, y: geometry.size.height))
                    }
                    .stroke(style: StrokeStyle(dash: [4, 2]))
                    .foregroundStyle(.gray)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
