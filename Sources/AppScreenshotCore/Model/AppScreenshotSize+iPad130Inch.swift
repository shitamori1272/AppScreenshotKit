//
//  ScreenshotSize+iPad130Inch.swift
//  FocusForFun
//
//  Created by Shuhei Shitamori on 2025/04/27.
//

import Foundation

extension AppScreenshotSize {
    // iPad 13.0インチ
    public static func iPad130Inch(
        model: IPad130InchModel = .iPadPro13M4(),
        size: IPad130InchModel.AppScreenshotSizeOption = .W2048H2732
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

    public struct IPad130InchModel {
        let orientation: DeviceOrientation
        let color: DeviceColor
        let model: DeviceModel

        public enum IPadPro13Color {
            case spaceGray
            case silver
        }

        public enum IPadAirColor {
            case stardust
            case spaceGray
            case blue
            case purple
        }

        public enum AppScreenshotSizeOption: SizeOption {
            case W2048H2732
            case W2732H2048

            var size: CGSize {
                switch self {
                case .W2048H2732: CGSize(width: 2048, height: 2732)
                case .W2732H2048: CGSize(width: 2732, height: 2048)
                }
            }
        }

        public static func iPadPro13M4(
            color: IPadPro13Color = .spaceGray, orientation: DeviceOrientation = .portrait
        ) -> IPad130InchModel {
            Self.init(orientation: orientation, color: color.deviceColor, model: .iPadPro13M4)
        }

        public static func iPadAir13M2(
            color: IPadAirColor = .stardust, orientation: DeviceOrientation = .portrait
        ) -> IPad130InchModel {
            Self.init(orientation: orientation, color: color.deviceColor, model: .iPadAir13M2)
        }
    }
}

extension AppScreenshotSize.IPad130InchModel.IPadPro13Color: DeviceColorConvertable {
    var deviceColor: DeviceColor {
        switch self {
        case .spaceGray: .spaceGray
        case .silver: .silver
        }
    }
}

extension AppScreenshotSize.IPad130InchModel.IPadAirColor: DeviceColorConvertable {
    var deviceColor: DeviceColor {
        switch self {
        case .stardust: .stardust
        case .spaceGray: .spaceGray
        case .blue: .blue
        case .purple: .purple
        }
    }
}

extension AppScreenshotSize.IPad130InchModel.IPadPro13Color: CaseIterable {}
extension AppScreenshotSize.IPad130InchModel.IPadAirColor: CaseIterable {}
extension AppScreenshotSize.IPad130InchModel.AppScreenshotSizeOption: CaseIterable {}

extension AppScreenshotSize {

    static var iPadPro13M4All: [AppScreenshotSize] {
        allCases(
            of: .iPadPro13M4,
            color: IPad130InchModel.IPadPro13Color.self,
            size: IPad130InchModel.AppScreenshotSizeOption.self
        )
    }
    static var iPadAir13M2All: [AppScreenshotSize] {
        allCases(
            of: .iPadAir13M2,
            color: IPad130InchModel.IPadAirColor.self,
            size: IPad130InchModel.AppScreenshotSizeOption.self
        )
    }

    static var iPad130InchAll: [AppScreenshotSize] {
        iPadPro13M4All + iPadAir13M2All
    }
}
