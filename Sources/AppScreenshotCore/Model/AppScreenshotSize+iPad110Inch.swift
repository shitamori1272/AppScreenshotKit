//
//  AppScreenshotSize+iPad110Inch.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/04/27.
//

import Foundation

extension AppScreenshotSize {
    // iPad 11.0インチ
    public static func iPad110Inch(
        model: IPad110InchModel = .iPadPro11M4(),
        size: IPad110InchModel.AppScreenshotSizeOption = .W1668H2388
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

    public struct IPad110InchModel {
        let orientation: DeviceOrientation
        let color: DeviceColor
        let model: DeviceModel

        public enum IPadPro11Color {
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
            case W1668H2388
            case W2388H1668
            case W1640H2360
            case W2360H1640

            var size: CGSize {
                switch self {
                case .W1668H2388: CGSize(width: 1668, height: 2388)
                case .W2388H1668: CGSize(width: 2388, height: 1668)
                case .W1640H2360: CGSize(width: 1640, height: 2360)
                case .W2360H1640: CGSize(width: 2360, height: 1640)
                }
            }
        }

        public static func iPadPro11M4(
            color: IPadPro11Color = .spaceGray,
            orientation: DeviceOrientation = .portrait
        ) -> IPad110InchModel {
            Self.init(orientation: orientation, color: color.deviceColor, model: .iPadPro11M4)
        }

        public static func iPadAir11M2(
            color: IPadAirColor = .stardust,
            orientation: DeviceOrientation = .portrait
        ) -> IPad110InchModel {
            Self.init(orientation: orientation, color: color.deviceColor, model: .iPadAir11M2)
        }
    }
}

extension AppScreenshotSize.IPad110InchModel.IPadPro11Color: DeviceColorConvertable {
    var deviceColor: DeviceColor {
        switch self {
        case .spaceGray: .spaceGray
        case .silver: .silver
        }
    }
}

extension AppScreenshotSize.IPad110InchModel.IPadAirColor: DeviceColorConvertable {
    var deviceColor: DeviceColor {
        switch self {
        case .stardust: .stardust
        case .spaceGray: .spaceGray
        case .blue: .blue
        case .purple: .purple
        }
    }
}

extension AppScreenshotSize.IPad110InchModel.IPadPro11Color: CaseIterable {}
extension AppScreenshotSize.IPad110InchModel.IPadAirColor: CaseIterable {}
extension AppScreenshotSize.IPad110InchModel.AppScreenshotSizeOption: CaseIterable {}

extension AppScreenshotSize {
    static var iPadPro11M4All: [AppScreenshotSize] {
        allCases(
            of: .iPadPro11M4,
            color: IPad110InchModel.IPadPro11Color.self,
            size: IPad110InchModel.AppScreenshotSizeOption.self
        )
    }
    static var iPadAir11M2All: [AppScreenshotSize] {
        allCases(
            of: .iPadAir11M2,
            color: IPad110InchModel.IPadAirColor.self,
            size: IPad110InchModel.AppScreenshotSizeOption.self
        )
    }
    static var iPad110InchAll: [AppScreenshotSize] {
        iPadPro11M4All + iPadAir11M2All
    }
}
