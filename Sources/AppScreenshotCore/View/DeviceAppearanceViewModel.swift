//
//  DeviceAppearanceViewModel.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/05.
//

import Foundation
import SwiftUI

/// Protocol for providing device appearance information for rendering device frames.
protocol DeviceAppearanceViewModel {
    var bezelWidth: CGFloat { get }
    var bezelRadius: CGFloat { get }
    var deviceViewSize: CGSize { get }
    var deviceFrameWidth: CGFloat { get }
    var deviceColor: Color { get }
    var dynamicIdsand: DynamicIsLandViewModel? { get }
    var orientation: DeviceOrientation { get }
    var appldeBezelDefinition: AppleDesignResourceBezelDefinition { get }
}

/// ViewModel for Dynamic Island feature.
struct DynamicIsLandViewModel {
    let size: CGSize
    let radius: CGFloat
    let topPadding: CGFloat
}

extension AppScreenshotDevice: DeviceAppearanceViewModel {

    var appldeBezelDefinition: AppleDesignResourceBezelDefinition {
        AppleDesignResourceBezelDefinition(
            deviceModel: model,
            orientation: orientation
        )
    }

    var deviceViewSize: CGSize {
        let logicalScreenSize = screenSize
        let imageScreenSize = appldeBezelDefinition.screenRect.size
        let ratio =
            (logicalScreenSize.width / imageScreenSize.width + logicalScreenSize.height
                / imageScreenSize.height) / 2
        let deviceWidth = appldeBezelDefinition.imageSize.width * ratio
        let deviceHeight = appldeBezelDefinition.imageSize.height * ratio
        return CGSize(width: deviceWidth, height: deviceHeight)
    }

    var deviceColor: Color {
        switch color {
        case .black: Color(red: 0x1F / 255, green: 0x20 / 255, blue: 0x20 / 255)
        case .white: Color(red: 0xF9 / 255, green: 0xF6 / 255, blue: 0xEF / 255)
        case .blue: Color(red: 0x27 / 255, green: 0x67 / 255, blue: 0x87 / 255)
        case .pink: Color(red: 0xE3 / 255, green: 0xC8 / 255, blue: 0xCA / 255)
        case .yellow: Color(red: 0xF9 / 255, green: 0xE4 / 255, blue: 0x79 / 255)
        case .green: Color(red: 0xCA / 255, green: 0xD4 / 255, blue: 0xC5 / 255)
        case .purple: Color(red: 0xB7 / 255, green: 0xAF / 255, blue: 0xE6 / 255)
        case .red: Color(red: 0xBF / 255, green: 0x00 / 255, blue: 0x13 / 255)
        case .teal: Color(red: 0xB0 / 255, green: 0xD4 / 255, blue: 0xD2 / 255)
        case .ultramarine: Color(red: 0x9A / 255, green: 0xAD / 255, blue: 0xF6 / 255)
        case .lavender: Color(red: 165 / 255, green: 155 / 255, blue: 177 / 255)
        case .sage: Color(red: 118 / 255, green: 132 / 255, blue: 99 / 255)
        case .mistBlue: Color(red: 120 / 255, green: 135 / 255, blue: 158 / 255)
        case .cosmicOrange: Color(red: 231 / 255, green: 113 / 255, blue: 49 / 255)
        case .deepBlue: Color(red: 62 / 255, green: 69 / 255, blue: 87 / 255)
        case .blackTitanium: Color(red: 0x1B / 255, green: 0x1B / 255, blue: 0x1B / 255)
        case .whiteTitanium: Color(red: 0xDD / 255, green: 0xDD / 255, blue: 0xDD / 255)
        case .naturalTitanium: Color(red: 0x83 / 255, green: 0x7F / 255, blue: 0x7D / 255)
        case .desertTitanium: Color(red: 0xBF / 255, green: 0xA4 / 255, blue: 0x8F / 255)
        case .blueTitanium: Color(red: 0x2F / 255, green: 0x44 / 255, blue: 0x52 / 255)
        case .spaceBlack: Color(red: 0x40 / 255, green: 0x3E / 255, blue: 0x3D / 255)
        case .gold: Color(red: 0xF4 / 255, green: 0xE8 / 255, blue: 0xCE / 255)
        case .deepPurple: Color(red: 0x59 / 255, green: 0x4F / 255, blue: 0x63 / 255)
        case .midnight: Color(red: 0x23 / 255, green: 0x2A / 255, blue: 0x31 / 255)
        case .silver: Color(red: 0xF0 / 255, green: 0xF2 / 255, blue: 0xF2 / 255)
        case .skyBlue: Color(red: 106 / 255, green: 121 / 255, blue: 131 / 255)
        case .lightGold: Color(red: 130 / 255, green: 117 / 255, blue: 88 / 255)
        case .cloudWhite: Color(red: 125 / 255, green: 125 / 255, blue: 123 / 255)
        case .spaceGray: Color(red: 0x26 / 255, green: 0x25 / 255, blue: 0x29 / 255)
        case .starlight: Color(red: 0xFA / 255, green: 0xF6 / 255, blue: 0xF2 / 255)
        // Using Starlight color as fallback
        case .stardust: Color(red: 0xFA / 255, green: 0xF6 / 255, blue: 0xF2 / 255)
        }
    }

    // Virtual bezel settings
    // TODO: More configuration required
    var bezelWidth: CGFloat {
        switch model {
        case .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax,
            .iPhone16, .iPhone16Plus, .iPhone16Pro, .iPhone16ProMax,
            .iPhone17, .iPhone17Pro, .iPhone17ProMax, .iPhoneAir,
            .iPhone14ProMax, .iPhone14Plus, .iPhone14Pro, .iPhone14:
            10
        case .iPadAir13M2, .iPadPro13M4: 44
        case .iPadMini, .iPad: 60
        case .iPadAir11M2, .iPadPro11M4: 54
        }
    }

    var deviceFrameWidth: CGFloat {
        switch model {
        case .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax,
            .iPhone16, .iPhone16Plus, .iPhone16Pro, .iPhone16ProMax,
            .iPhone17, .iPhone17Pro, .iPhone17ProMax, .iPhoneAir,
            .iPhone14ProMax, .iPhone14Plus, .iPhone14Pro, .iPhone14:
            return 6
        case .iPadMini, .iPadAir11M2, .iPadAir13M2, .iPadPro11M4, .iPadPro13M4, .iPad:
            return 8
        }
    }

    var dynamicIdsand: DynamicIsLandViewModel? {
        switch model {
        case .iPhone15Pro, .iPhone15ProMax, .iPhone15, .iPhone15Plus,
            .iPhone16, .iPhone16Plus, .iPhone16Pro, .iPhone16ProMax,
            .iPhone17, .iPhone17Pro, .iPhone17ProMax, .iPhoneAir,
            .iPhone14Pro, .iPhone14ProMax:
            DynamicIsLandViewModel(
                size: CGSize(width: 123, height: 36),
                radius: 100,
                topPadding: 14
            )
        default: nil
        }
    }

    var bezelRadius: CGFloat {
        switch model {
        case .iPhone17ProMax, .iPhoneAir, .iPhone16ProMax, .iPhone16Plus,
            .iPhone15ProMax, .iPhone15Plus, .iPhone14Plus, .iPhone14ProMax:
            55
        case .iPhone17Pro, .iPhone16Pro: 62
        case .iPhone17, .iPhone16, .iPhone15, .iPhone15Pro, .iPhone14Pro, .iPhone14: 47.33
        case .iPadPro11M4, .iPadPro13M4: 30
        case .iPadAir11M2, .iPadAir13M2: 18
        case .iPadMini: 21.5
        case .iPad: 0
        }
    }
}
