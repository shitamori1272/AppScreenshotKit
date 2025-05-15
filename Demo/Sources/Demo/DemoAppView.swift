//
//  DemoAppView.swift
//  Demo
//
//  Created by Shuhei Shitamori on 2025/05/15.
//

import SwiftUI

struct DemoAppView: View {

    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<10) { index in
                    HStack {
                        Text("Item \(index)", bundle: .module)
                    }
                }
            }
            .navigationTitle(Text("Navigation", bundle: .module))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DemoAppView()
}
