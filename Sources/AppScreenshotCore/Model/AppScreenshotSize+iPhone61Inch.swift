//
//  AppScreenshotSize+iPhone61Inch.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/04/27.
//

import Foundation

extension AppScreenshotSize {
    /// iPhone 6.1インチ
    public static func iPhone61Inch(
        model: IPhone61InchModel = .iPhone14(),
        size: IPhone61InchModel.AppScreenshotSizeOption = .w1170h2532
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

        public enum IPhone14Color {
            case blue
            case midnight
            case purple
            case red
            case starlight
        }

        public enum AppScreenshotSizeOption: SizeOption {
            case w1170h2532
            case w2532h1170

            var size: CGSize {
                switch self {
                case .w1170h2532: CGSize(width: 1170, height: 2532)
                case .w2532h1170: CGSize(width: 2532, height: 1170)
                }
            }
        }

        public static func iPhone14(
            color: IPhone14Color = .blue,
            orientation: DeviceOrientation = .portrait
        ) -> IPhone61InchModel {
            Self.init(orientation: orientation, color: color.deviceColor, model: .iPhone14)
        }
    }
}

extension AppScreenshotSize.IPhone61InchModel.IPhone14Color: DeviceColorConvertable {
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

extension AppScreenshotSize.IPhone61InchModel.IPhone14Color: CaseIterable {}
extension AppScreenshotSize.IPhone61InchModel.AppScreenshotSizeOption: CaseIterable {}

extension AppScreenshotSize {
    static var iPhone14All: [AppScreenshotSize] {
        allCases(
            of: .iPhone14,
            color: IPhone61InchModel.IPhone14Color.self,
            size: IPhone61InchModel.AppScreenshotSizeOption.self
        )
    }
    static var iPhone61InchAll: [AppScreenshotSize] {
        iPhone14All
    }
}
