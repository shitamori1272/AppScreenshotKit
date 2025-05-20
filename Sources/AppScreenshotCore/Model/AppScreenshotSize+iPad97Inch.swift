//
//  AppScreenshotSize+iPad97Inch.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/04/27.
//

import Foundation

// iPad 9.7インチ
extension AppScreenshotSize {

    public static func iPad97Inch(
        model: IPad97InchModel = .iPad(),
        size: IPad97InchModel.AppScreenshotSizeOption = .w1620h2160
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

    public struct IPad97InchModel {
        let orientation: DeviceOrientation
        let color: DeviceColor
        let model: DeviceModel

        public enum IPadColor {
            case silver
        }

        public enum IPadMiniColor {
            case starlight
        }

        public enum AppScreenshotSizeOption: SizeOption {
            case w1620h2160
            case w2160h1620
            var size: CGSize {
                switch self {
                case .w1620h2160: CGSize(width: 1620, height: 2160)
                case .w2160h1620: CGSize(width: 2160, height: 1620)
                }
            }
        }

        public static func iPad(
            color: IPadColor = .silver,
            orientation: DeviceOrientation = .portrait
        ) -> IPad97InchModel {
            Self.init(
                orientation: orientation,
                color: color.deviceColor,
                model: .iPad
            )
        }

        public static func iPadMini(
            color: IPadMiniColor = .starlight,
            orientation: DeviceOrientation = .portrait
        ) -> IPad97InchModel {
            Self.init(
                orientation: orientation,
                color: color.deviceColor,
                model: .iPadMini
            )
        }
    }
}

extension AppScreenshotSize.IPad97InchModel.IPadColor: DeviceColorConvertable {
    var deviceColor: DeviceColor {
        switch self {
        case .silver: .silver
        }
    }
}

extension AppScreenshotSize.IPad97InchModel.IPadMiniColor: DeviceColorConvertable {
    var deviceColor: DeviceColor {
        switch self {
        case .starlight: .starlight
        }
    }
}

extension AppScreenshotSize.IPad97InchModel.IPadColor: CaseIterable {}
extension AppScreenshotSize.IPad97InchModel.IPadMiniColor: CaseIterable {}
extension AppScreenshotSize.IPad97InchModel.AppScreenshotSizeOption: CaseIterable {}

extension AppScreenshotSize {
    static var iPadAll: [AppScreenshotSize] {
        allCases(
            of: .iPad,
            color: IPad97InchModel.IPadColor.self,
            size: IPad97InchModel.AppScreenshotSizeOption.self
        )
    }
    static var iPadMiniAll: [AppScreenshotSize] {
        allCases(
            of: .iPadMini,
            color: IPad97InchModel.IPadMiniColor.self,
            size: IPad97InchModel.AppScreenshotSizeOption.self
        )
    }
    static var iPad97InchAll: [AppScreenshotSize] {
        iPadAll + iPadMiniAll
    }
}
