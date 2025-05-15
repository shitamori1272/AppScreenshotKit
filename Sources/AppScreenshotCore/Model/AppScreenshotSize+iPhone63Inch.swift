//
//  AppScreenshotSize+iPhone63Inch.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/04/27.
//

import Foundation

extension AppScreenshotSize {

    // iPhone 6.3インチ
    public static func iPhone63Inch(
        model: IPhone63InchModel = .iPhone16Pro(),
        size: IPhone63InchModel.AppScreenshotSizeOption = .W1206H2622
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
    public struct IPhone63InchModel {
        let orientation: DeviceOrientation
        let color: DeviceColor
        let model: DeviceModel

        public enum iPhone16ProColor {
            case blackTitanium
            case whiteTitanium
            case naturalTitanium
            case desertTitanium
        }

        public enum iPhone16Color {
            case black
            case white
            case pink
            case teal
            case ultramarine
        }

        public enum iPhone15ProColor {
            case blackTitanium
            case blueTitanium
            case naturalTitanium
            case whiteTitanium
        }

        public enum iPhone15Color {
            case black
            case blue
            case green
            case yellow
            case pink
        }

        public enum iPhone14ProColor {
            case spaceBlack
            case silver
            case gold
            case deepPurple
        }

        public enum AppScreenshotSizeOption: SizeOption {
            case W1179H2556
            case W2556H1179
            case W1206H2622
            case W2622H1206

            var size: CGSize {
                switch self {
                case .W1179H2556: CGSize(width: 1179, height: 2556)
                case .W2556H1179: CGSize(width: 2556, height: 1179)
                case .W1206H2622: CGSize(width: 1206, height: 2622)
                case .W2622H1206: CGSize(width: 2622, height: 1206)
                }
            }
        }

        public static func iPhone16Pro(
            color: iPhone16ProColor = .blackTitanium, orientation: DeviceOrientation = .portrait
        ) -> IPhone63InchModel {
            Self.init(orientation: orientation, color: color.deviceColor, model: .iPhone16Pro)
        }

        public static func iPhone16(
            color: iPhone16Color = .black, orientation: DeviceOrientation = .portrait
        ) -> IPhone63InchModel {
            Self.init(orientation: orientation, color: color.deviceColor, model: .iPhone16)
        }

        public static func iPhone15Pro(
            color: iPhone15ProColor = .blackTitanium, orientation: DeviceOrientation = .portrait
        ) -> IPhone63InchModel {
            Self.init(orientation: orientation, color: color.deviceColor, model: .iPhone15Pro)
        }

        public static func iPhone15(
            color: iPhone15Color = .black, orientation: DeviceOrientation = .portrait
        ) -> IPhone63InchModel {
            Self.init(orientation: orientation, color: color.deviceColor, model: .iPhone15)
        }

        public static func iPhone14Pro(
            color: iPhone14ProColor = .spaceBlack, orientation: DeviceOrientation = .portrait
        ) -> IPhone63InchModel {
            Self.init(orientation: orientation, color: color.deviceColor, model: .iPhone14Pro)
        }
    }
}

extension AppScreenshotSize.IPhone63InchModel.iPhone16ProColor: DeviceColorConvertable {
    var deviceColor: DeviceColor {
        switch self {
        case .blackTitanium: .blackTitanium  // Maps to "Black Titanium" in the PNG filename
        case .whiteTitanium: .whiteTitanium  // Maps to "White Titanium" in the PNG filename
        case .naturalTitanium: .naturalTitanium  // Maps to "Natural Titanium" in the PNG filename
        case .desertTitanium: .desertTitanium  // Maps to "Desert Titanium" in the PNG filename
        }
    }
}

extension AppScreenshotSize.IPhone63InchModel.iPhone16Color: DeviceColorConvertable {
    var deviceColor: DeviceColor {
        switch self {
        case .black: .black
        case .white: .white
        case .pink: .pink
        case .teal: .teal
        case .ultramarine: .ultramarine
        }
    }
}

extension AppScreenshotSize.IPhone63InchModel.iPhone15ProColor: DeviceColorConvertable {
    var deviceColor: DeviceColor {
        switch self {
        case .blackTitanium: .blackTitanium  // Maps to "Black Titanium" in the PNG filename
        case .blueTitanium: .blueTitanium  // Maps to "Blue Titanium" in the PNG filename
        case .naturalTitanium: .naturalTitanium  // Maps to "Natural Titanium" in the PNG filename
        case .whiteTitanium: .whiteTitanium  // Maps to "White Titanium" in the PNG filename
        }
    }
}

extension AppScreenshotSize.IPhone63InchModel.iPhone15Color: DeviceColorConvertable {
    var deviceColor: DeviceColor {
        switch self {
        case .black: .black
        case .blue: .blue
        case .green: .green
        case .yellow: .yellow
        case .pink: .pink
        }
    }
}

extension AppScreenshotSize.IPhone63InchModel.iPhone14ProColor: DeviceColorConvertable {
    var deviceColor: DeviceColor {
        switch self {
        case .spaceBlack: .spaceBlack
        case .silver: .silver
        case .gold: .gold
        case .deepPurple: .deepPurple
        }
    }
}

extension AppScreenshotSize.IPhone63InchModel.iPhone16ProColor: CaseIterable {}
extension AppScreenshotSize.IPhone63InchModel.iPhone16Color: CaseIterable {}
extension AppScreenshotSize.IPhone63InchModel.iPhone15ProColor: CaseIterable {}
extension AppScreenshotSize.IPhone63InchModel.iPhone15Color: CaseIterable {}
extension AppScreenshotSize.IPhone63InchModel.iPhone14ProColor: CaseIterable {}
extension AppScreenshotSize.IPhone63InchModel.AppScreenshotSizeOption: CaseIterable {}

extension AppScreenshotSize {

    static var iPhone16ProAll: [AppScreenshotSize] {
        allCases(
            of: .iPhone16Pro,
            color: IPhone63InchModel.iPhone16ProColor.self,
            size: IPhone63InchModel.AppScreenshotSizeOption.self
        )
    }
    static var iPhone16All: [AppScreenshotSize] {
        allCases(
            of: .iPhone16,
            color: IPhone63InchModel.iPhone16Color.self,
            size: IPhone63InchModel.AppScreenshotSizeOption.self
        )
    }
    static var iPhone15ProAll: [AppScreenshotSize] {
        allCases(
            of: .iPhone15Pro,
            color: IPhone63InchModel.iPhone15ProColor.self,
            size: IPhone63InchModel.AppScreenshotSizeOption.self
        )
    }
    static var iPhone15All: [AppScreenshotSize] {
        allCases(
            of: .iPhone15,
            color: IPhone63InchModel.iPhone15Color.self,
            size: IPhone63InchModel.AppScreenshotSizeOption.self
        )
    }
    static var iPhone14ProAll: [AppScreenshotSize] {
        allCases(
            of: .iPhone14Pro,
            color: IPhone63InchModel.iPhone14ProColor.self,
            size: IPhone63InchModel.AppScreenshotSizeOption.self
        )
    }
    static var iPhone63InchAll: [AppScreenshotSize] {
        iPhone16ProAll + iPhone16All + iPhone15ProAll + iPhone15All + iPhone14ProAll
    }
}
