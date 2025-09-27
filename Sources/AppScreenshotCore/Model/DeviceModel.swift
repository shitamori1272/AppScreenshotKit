//
//  DeviceModel.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/05.
//

import Foundation

public enum DeviceModel: String, Sendable {
    case iPhone17ProMax = "iPhone 17 Pro Max"
    case iPhone17Pro = "iPhone 17 Pro"
    case iPhone17 = "iPhone 17"
    case iPhoneAir = "iPhone Air"

    case iPhone16ProMax = "iPhone 16 Pro Max"
    case iPhone16Plus = "iPhone 16 Plus"
    case iPhone15ProMax = "iPhone 15 Pro Max"
    case iPhone15Plus = "iPhone 15 Plus"
    case iPhone14ProMax = "iPhone 14 Pro Max"
    case iPhone14Plus = "iPhone 14 Plus"
    case iPhone16Pro = "iPhone 16 Pro"
    case iPhone16 = "iPhone 16"
    case iPhone15Pro = "iPhone 15 Pro"
    case iPhone15 = "iPhone 15"
    case iPhone14Pro = "iPhone 14 Pro"
    case iPhone14 = "iPhone 14"
    case iPadPro11M4 = "iPad Pro 11 - M4"
    case iPadPro13M4 = "iPad Pro 13 - M4"
    case iPadAir11M2 = "iPad Air 11\" - M2"
    case iPadAir13M2 = "iPad Air 13\" - M2"
    case iPad = "iPad"
    case iPadMini = "iPad mini"

    public var category: DeviceCategory {
        switch self {
        case .iPadPro11M4, .iPadPro13M4, .iPadAir11M2, .iPadAir13M2, .iPadMini, .iPad: .iPad
        default: .iPhone
        }
    }

    // https://developer.apple.com/help/app-store-connect/reference/screenshot-specifications
    public var displayInch: String {
        switch self {
        case .iPhoneAir, .iPhone17ProMax, .iPhone16ProMax,
            .iPhone16Plus, .iPhone15ProMax, .iPhone15Plus, .iPhone14ProMax: "6_9"
        case .iPhone14Plus: "6_5"
        case .iPhone17Pro, .iPhone17, .iPhone16Pro, .iPhone16, .iPhone15Pro, .iPhone15, .iPhone14Pro: "6_3"
        case .iPhone14: "6_1"
        case .iPadAir13M2, .iPadPro13M4: "13"
        case .iPadAir11M2, .iPadPro11M4: "11"
        case .iPad, .iPadMini: "9_7"
        }
    }
}
