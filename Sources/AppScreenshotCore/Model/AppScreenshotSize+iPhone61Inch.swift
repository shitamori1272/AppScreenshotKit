//
//  AppScreenshotSize+iPhone61Inch.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/04/27.
//

import Foundation

extension AppScreenshotSize {
    // iPhone 6.1インチ
    public static func iPhone61Inch(
        model: IPhone61InchModel = .iPhone14(),
        size: IPhone61InchModel.AppScreenshotSizeOption = .W1170H2532
    ) -> AppScreenshotSize {
        AppScreenshotSize(
            device: AppScreenshotDevice(
                orientation: model.orientation,
                color: model.color,
                model: model.model
            ),
            size: size
        )
    }

    public struct IPhone61InchModel {
        let orientation: DeviceOrientation
        let color: DeviceColor
        let model: DeviceModel

        public enum iPhone14Color {
            case blue
            case midnight
            case purple
            case red
            case starlight
        }

        public enum AppScreenshotSizeOption: SizeOption {
            case W1170H2532
            case W2532H1170

            var size: CGSize {
                switch self {
                case .W1170H2532: CGSize(width: 1170, height: 2532)
                case .W2532H1170: CGSize(width: 2532, height: 1170)
                }
            }
        }

        public static func iPhone14(
            color: iPhone14Color = .blue, orientation: DeviceOrientation = .portrait
        ) -> IPhone61InchModel {
            Self.init(orientation: orientation, color: color.deviceColor, model: .iPhone14)
        }
    }
}

extension AppScreenshotSize.IPhone61InchModel.iPhone14Color: DeviceColorConvertable {
    var deviceColor: DeviceColor {
        switch self {
        case .blue: .blue
        case .midnight: .midnight
        case .purple: .purple
        case .red: .red
        case .starlight: .starlight
        }
    }
}

extension AppScreenshotSize.IPhone61InchModel.iPhone14Color: CaseIterable {}
extension AppScreenshotSize.IPhone61InchModel.AppScreenshotSizeOption: CaseIterable {}

extension AppScreenshotSize {
    static var iPhone14All: [AppScreenshotSize] {
        allCases(
            of: .iPhone14,
            color: IPhone61InchModel.iPhone14Color.self,
            size: IPhone61InchModel.AppScreenshotSizeOption.self
        )
    }
    static var iPhone61InchAll: [AppScreenshotSize] {
        iPhone14All
    }
}
