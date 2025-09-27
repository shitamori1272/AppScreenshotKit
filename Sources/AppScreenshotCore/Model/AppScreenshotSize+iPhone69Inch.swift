//
//  AppScreenshotSize+iPhone69Inch.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/04/27.
//

import Foundation

// IPhone69InchModel
extension AppScreenshotSize {

    /// Returns an AppScreenshotSize for a 6.9-inch iPhone model.
    ///
    /// - Parameters:
    ///   - model: The device model configuration (default: iPhone16ProMax).
    ///   - size: The screenshot size option (default: W1320H2868).
    /// - Returns: An AppScreenshotSize configured for the specified model and size.
    public static func iPhone69Inch(
        model: IPhone69InchModel = .iPhone16ProMax(),
        size: IPhone69InchModel.AppScreenshotSizeOption = .w1320h2868
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

    /// Represents the configuration for a 6.9-inch iPhone model, including orientation, color, and device model.
    public struct IPhone69InchModel {
        let orientation: DeviceOrientation
        let color: DeviceColor
        let model: DeviceModel

        /// Color options for iPhone 17 Pro Max.
        public enum IPhone17ProMaxColor {
            case cosmicOrange
            case deepBlue
            case silver
        }

        /// Color options for iPhone Air.
        public enum IPhoneAirColor {
            case skyBlue
            case lightGold
            case cloudWhite
            case spaceBlack
        }

        /// Color options for iPhone 16 Pro Max.
        public enum IPhone16ProMaxColor {
            case blackTitanium
            case whiteTitanium
            case naturalTitanium
            case desertTitanium
        }

        /// Color options for iPhone 16 Plus.
        public enum IPhone16PlusColor {
            case black
            case white
            case pink
            case teal
            case ultramarine
        }

        /// Color options for iPhone 15 Pro Max.
        public enum IPhone15ProMaxColor {
            case blackTitanium
            case whiteTitanium
            case naturalTitanium
            case blueTitanium
        }

        /// Color options for iPhone 15 Plus.
        public enum IPhone15PlusColor {
            case black
            case blue
            case green
            case yellow
            case pink
        }

        /// Color options for iPhone 14 Pro Max.
        public enum IPhone14ProMaxColor {
            case deepPurple
            case gold
            case silver
            case spaceBlack
        }

        /// Screenshot size options for 6.9-inch iPhone models.
        public enum AppScreenshotSizeOption: SizeOption {
            case w1260h2736
            case w2736h1260
            case w1290h2796
            case w2796h1290
            case w1320h2868
            case w2868h1320

            var size: CGSize {
                switch self {
                case .w1260h2736: CGSize(width: 1260, height: 2736)
                case .w2736h1260: CGSize(width: 2736, height: 1260)
                case .w1290h2796: CGSize(width: 1290, height: 2796)
                case .w2796h1290: CGSize(width: 2796, height: 1290)
                case .w1320h2868: CGSize(width: 1320, height: 2868)
                case .w2868h1320: CGSize(width: 2868, height: 1320)
                }
            }
        }

        /// Returns a configuration for iPhone 17 Pro Max.
        ///
        /// - Parameters:
        ///   - color: The color option (default: cosmicOrange).
        ///   - orientation: The device orientation (default: portrait).
        /// - Returns: An IPhone69InchModel for iPhone 17 Pro Max.
        public static func iPhone17ProMax(
            color: IPhone17ProMaxColor = .cosmicOrange,
            orientation: DeviceOrientation = .portrait
        ) -> IPhone69InchModel {
            Self.init(
                orientation: orientation,
                color: color.deviceColor,
                model: .iPhone17ProMax
            )
        }

        /// Returns a configuration for iPhone Air.
        ///
        /// - Parameters:
        ///   - color: The color option (default: skyBlue).
        ///   - orientation: The device orientation (default: portrait).
        /// - Returns: An IPhone69InchModel for iPhone Air.
        public static func iPhoneAir(
            color: IPhoneAirColor = .skyBlue,
            orientation: DeviceOrientation = .portrait
        ) -> IPhone69InchModel {
            Self.init(
                orientation: orientation,
                color: color.deviceColor,
                model: .iPhoneAir
            )
        }

        /// Returns a configuration for iPhone 16 Pro Max.
        ///
        /// - Parameters:
        ///   - color: The color option (default: blackTitanium).
        ///   - orientation: The device orientation (default: portrait).
        /// - Returns: An IPhone69InchModel for iPhone 16 Pro Max.
        public static func iPhone16ProMax(
            color: IPhone16ProMaxColor = .blackTitanium,
            orientation: DeviceOrientation = .portrait
        ) -> IPhone69InchModel {
            Self.init(
                orientation: orientation,
                color: color.deviceColor,
                model: .iPhone16ProMax
            )
        }

        /// Returns a configuration for iPhone 16 Plus.
        ///
        /// - Parameters:
        ///   - color: The color option (default: black).
        ///   - orientation: The device orientation (default: portrait).
        /// - Returns: An IPhone69InchModel for iPhone 16 Plus.
        public static func iPhone16Plus(
            color: IPhone16PlusColor = .black,
            orientation: DeviceOrientation = .portrait
        ) -> IPhone69InchModel {
            Self.init(
                orientation: orientation,
                color: color.deviceColor,
                model: .iPhone16Plus
            )
        }

        /// Returns a configuration for iPhone 15 Pro Max.
        ///
        /// - Parameters:
        ///   - color: The color option (default: blackTitanium).
        ///   - orientation: The device orientation (default: portrait).
        /// - Returns: An IPhone69InchModel for iPhone 15 Pro Max.
        public static func iPhone15ProMax(
            color: IPhone15ProMaxColor = .blackTitanium,
            orientation: DeviceOrientation = .portrait
        ) -> IPhone69InchModel {
            Self.init(
                orientation: orientation,
                color: color.deviceColor,
                model: .iPhone15ProMax
            )
        }

        /// Returns a configuration for iPhone 15 Plus.
        ///
        /// - Parameters:
        ///   - color: The color option (default: black).
        ///   - orientation: The device orientation (default: portrait).
        /// - Returns: An IPhone69InchModel for iPhone 15 Plus.
        public static func iPhone15Plus(
            color: IPhone15PlusColor = .black,
            orientation: DeviceOrientation = .portrait
        ) -> IPhone69InchModel {
            Self.init(
                orientation: orientation,
                color: color.deviceColor,
                model: .iPhone15Plus
            )
        }

        /// Returns a configuration for iPhone 14 Pro Max.
        ///
        /// - Parameters:
        ///   - color: The color option (default: spaceBlack).
        ///   - orientation: The device orientation (default: portrait).
        /// - Returns: An IPhone69InchModel for iPhone 14 Pro Max.
        public static func iPhone14ProMax(
            color: IPhone14ProMaxColor = .spaceBlack,
            orientation: DeviceOrientation = .portrait
        ) -> IPhone69InchModel {
            Self.init(
                orientation: orientation,
                color: color.deviceColor,
                model: .iPhone14ProMax
            )
        }
    }
}

extension AppScreenshotSize.IPhone69InchModel.IPhone16ProMaxColor: DeviceColorConvertable {
    var deviceColor: DeviceColor {
        switch self {
        case .blackTitanium: .blackTitanium  // Maps to "Black Titanium" in the PNG filename
        case .whiteTitanium: .whiteTitanium  // Maps to "White Titanium" in the PNG filename
        case .naturalTitanium: .naturalTitanium  // Maps to "Natural Titanium" in the PNG filename
        case .desertTitanium: .desertTitanium  // Maps to "Desert Titanium" in the PNG filename
        }
    }
}

extension AppScreenshotSize.IPhone69InchModel.IPhone17ProMaxColor: DeviceColorConvertable {
    var deviceColor: DeviceColor {
        switch self {
        case .cosmicOrange: .cosmicOrange
        case .deepBlue: .deepBlue
        case .silver: .silver
        }
    }
}

extension AppScreenshotSize.IPhone69InchModel.IPhoneAirColor: DeviceColorConvertable {
    var deviceColor: DeviceColor {
        switch self {
        case .skyBlue: .skyBlue
        case .lightGold: .lightGold
        case .cloudWhite: .cloudWhite
        case .spaceBlack: .spaceBlack
        }
    }
}

extension AppScreenshotSize.IPhone69InchModel.IPhone15ProMaxColor: DeviceColorConvertable {
    var deviceColor: DeviceColor {
        switch self {
        case .blackTitanium: .blackTitanium  // Maps to "Black Titanium" in the PNG filename
        case .whiteTitanium: .whiteTitanium  // Maps to "White Titanium" in the PNG filename
        case .naturalTitanium: .naturalTitanium  // Maps to "Natural Titanium" in the PNG filename
        case .blueTitanium: .blueTitanium  // Maps to "Blue Titanium" in the PNG filename
        }
    }
}

extension AppScreenshotSize.IPhone69InchModel.IPhone15PlusColor: DeviceColorConvertable {
    var deviceColor: DeviceColor {
        switch self {
        case .black: .black  // Maps to "Black" in the PNG filename
        case .blue: .blue  // Maps to "Blue" in the PNG filename
        case .green: .green  // Maps to "Green" in the PNG filename
        case .yellow: .yellow  // Maps to "Yellow" in the PNG filename
        case .pink: .pink  // Maps to "Pink" in the PNG filename
        }
    }
}

extension AppScreenshotSize.IPhone69InchModel.IPhone16PlusColor: DeviceColorConvertable {
    var deviceColor: DeviceColor {
        switch self {
        case .black: .black  // Maps to "Black" in the PNG filename
        case .white: .white  // Maps to "White" in the PNG filename
        case .pink: .pink  // Maps to "Pink" in the PNG filename
        case .teal: .teal  // Maps to "Teal" in the PNG filename
        case .ultramarine: .ultramarine  // Maps to "Ultramarine" in the PNG filename
        }
    }
}

extension AppScreenshotSize.IPhone69InchModel.IPhone14ProMaxColor: DeviceColorConvertable {
    var deviceColor: DeviceColor {
        switch self {
        case .deepPurple: .deepPurple  // Maps to "Deep Purple" in the PNG filename
        case .gold: .gold  // Maps to "Gold" in the PNG filename
        case .silver: .silver  // Maps to "Silver" in the PNG filename
        case .spaceBlack: .spaceBlack  // Maps to "Space Black" in the PNG filename
        }
    }
}

extension AppScreenshotSize.IPhone69InchModel.IPhone17ProMaxColor: CaseIterable {}
extension AppScreenshotSize.IPhone69InchModel.IPhoneAirColor: CaseIterable {}
extension AppScreenshotSize.IPhone69InchModel.IPhone16ProMaxColor: CaseIterable {}
extension AppScreenshotSize.IPhone69InchModel.IPhone16PlusColor: CaseIterable {}
extension AppScreenshotSize.IPhone69InchModel.IPhone15ProMaxColor: CaseIterable {}
extension AppScreenshotSize.IPhone69InchModel.IPhone15PlusColor: CaseIterable {}
extension AppScreenshotSize.IPhone69InchModel.IPhone14ProMaxColor: CaseIterable {}
extension AppScreenshotSize.IPhone69InchModel.AppScreenshotSizeOption: CaseIterable {}

extension AppScreenshotSize {

    static var iPhone17ProMaxAll: [AppScreenshotSize] {
        allCases(
            of: .iPhone17ProMax,
            color: IPhone69InchModel.IPhone17ProMaxColor.self,
            size: IPhone69InchModel.AppScreenshotSizeOption.self
        )
    }

    static var iPhoneAirAll: [AppScreenshotSize] {
        allCases(
            of: .iPhoneAir,
            color: IPhone69InchModel.IPhoneAirColor.self,
            size: IPhone69InchModel.AppScreenshotSizeOption.self
        )
    }

    static var iPhone16ProMaxAll: [AppScreenshotSize] {
        allCases(
            of: .iPhone16ProMax,
            color: IPhone69InchModel.IPhone16ProMaxColor.self,
            size: IPhone69InchModel.AppScreenshotSizeOption.self
        )
    }
    static var iPhone16PlusAll: [AppScreenshotSize] {
        allCases(
            of: .iPhone16Plus,
            color: IPhone69InchModel.IPhone16PlusColor.self,
            size: IPhone69InchModel.AppScreenshotSizeOption.self
        )
    }
    static var iPhone15ProMaxAll: [AppScreenshotSize] {
        allCases(
            of: .iPhone15ProMax,
            color: IPhone69InchModel.IPhone15ProMaxColor.self,
            size: IPhone69InchModel.AppScreenshotSizeOption.self
        )
    }
    static var iPhone15PlusAll: [AppScreenshotSize] {
        allCases(
            of: .iPhone15Plus,
            color: IPhone69InchModel.IPhone15PlusColor.self,
            size: IPhone69InchModel.AppScreenshotSizeOption.self
        )
    }
    static var iPhone14ProMaxAll: [AppScreenshotSize] {
        allCases(
            of: .iPhone14ProMax,
            color: IPhone69InchModel.IPhone14ProMaxColor.self,
            size: IPhone69InchModel.AppScreenshotSizeOption.self
        )
    }
    static var iPhone69InchAll: [AppScreenshotSize] {
        iPhone17ProMaxAll + iPhoneAirAll + iPhone16ProMaxAll + iPhone16PlusAll
            + iPhone15ProMaxAll + iPhone15PlusAll + iPhone14ProMaxAll
    }
}
