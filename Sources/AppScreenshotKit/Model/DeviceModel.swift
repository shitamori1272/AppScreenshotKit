//
//  DeviceModel.swift
//  FocusForFun
//
//  Created by Shuhei Shitamori on 2025/05/05.
//

import Foundation

public enum DeviceModel: String, Sendable {
    case iPhone16ProMax = "iPhone 16 Pro Max"
    case iPhone16Plus = "iPhone 16 Plus"
    case iPhone15ProMax = "iPhone 15 Pro Max"
    case iPhone15Plus = "iPhone 15 Plus"
    case iPhone14ProMax = "iPhone 14 Pro Max"
    case iPhone14Plus = "iPhone 14 Plus"
    // 6.3インチ
    case iPhone16Pro = "iPhone 16 Pro"
    case iPhone16 = "iPhone 16"
    case iPhone15Pro = "iPhone 15 Pro"
    case iPhone15 = "iPhone 15"
    case iPhone14Pro = "iPhone 14 Pro"
    // 6.1インチ
    case iPhone14 = "iPhone 14"
    // iPad
    case iPadPro11M4 = "iPad Pro 11 - M4"
    case iPadPro13M4 = "iPad Pro 13 - M4"
    case iPadAir11M2 = "iPad Air 11\" - M2"
    case iPadAir13M2 = "iPad Air 13\" - M2"
    case iPad = "iPad"
    case iPadMini = "iPad mini"
    //case iPad = "IPad"

    public var category: DeviceCategory {
        switch self {
        case .iPadPro11M4, .iPadPro13M4, .iPadAir11M2, .iPadAir13M2, .iPadMini, .iPad: .iPad
        default: .iPhone
        }
    }
}
