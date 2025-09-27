//
//  DeviceScreenViewModel.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/05.
//

import Foundation
import SwiftUI

/// Protocol for providing device screen information for rendering screenshots.
protocol DeviceScreenViewModel {
    var screenSize: CGSize { get }
    var safeAreaInsets: EdgeInsets { get }
    var horizontalSizeClass: UserInterfaceSizeClass { get }
    var verticalSizeClass: UserInterfaceSizeClass { get }
}

/// Extension that can not be estimated from Bezel Image
extension AppScreenshotDevice: DeviceScreenViewModel {

    var screenSize: CGSize {
        switch model {
        case .iPhone17ProMax, .iPhone16ProMax:
            return switch orientation {
            case .portrait: CGSize(width: 440, height: 956)
            case .landscape: CGSize(width: 956, height: 440)
            }
        case .iPhoneAir, .iPhone14ProMax, .iPhone15Plus, .iPhone15ProMax, .iPhone16Plus:
            return switch orientation {
            case .portrait: CGSize(width: 430, height: 932)
            case .landscape: CGSize(width: 932, height: 430)
            }
        case .iPhone14Plus:
            return switch orientation {
            case .portrait: CGSize(width: 428, height: 926)
            case .landscape: CGSize(width: 926, height: 428)
            }
        case .iPhone17Pro, .iPhone16Pro:
            return switch orientation {
            case .portrait: CGSize(width: 402, height: 874)
            case .landscape: CGSize(width: 874, height: 402)
            }
        case .iPhone15Pro, .iPhone14Pro:
            return switch orientation {
            case .portrait: CGSize(width: 393, height: 852)
            case .landscape: CGSize(width: 852, height: 393)
            }
        case .iPhone17, .iPhone16, .iPhone15, .iPhone14:
            return switch orientation {
            case .portrait: CGSize(width: 390, height: 844)
            case .landscape: CGSize(width: 844, height: 390)
            }
        case .iPadPro11M4:
            return switch orientation {
            case .portrait: CGSize(width: 834, height: 1194)
            case .landscape: CGSize(width: 1194, height: 834)
            }
        case .iPadPro13M4:
            return switch orientation {
            case .portrait: CGSize(width: 1024, height: 1366)
            case .landscape: CGSize(width: 1366, height: 1024)
            }
        case .iPadAir11M2:
            return switch orientation {
            case .portrait: CGSize(width: 820, height: 1180)
            case .landscape: CGSize(width: 1180, height: 820)
            }
        case .iPadAir13M2:
            return switch orientation {
            case .portrait: CGSize(width: 1024, height: 1366)
            case .landscape: CGSize(width: 1366, height: 1024)
            }
        case .iPad:
            return switch orientation {
            case .portrait: CGSize(width: 768, height: 1024)
            case .landscape: CGSize(width: 1024, height: 768)
            }
        case .iPadMini:
            return switch orientation {
            case .portrait: CGSize(width: 744, height: 1133)
            case .landscape: CGSize(width: 1133, height: 744)
            }
        }
    }
    var safeAreaInsets: EdgeInsets {
        switch model {
        case .iPhone17ProMax, .iPhone16ProMax, .iPhone17Pro, .iPhone16Pro:
            return switch orientation {
            case .portrait: EdgeInsets(top: 62, leading: 0, bottom: 34, trailing: 0)
            case .landscape: EdgeInsets(top: 0, leading: 62, bottom: 21, trailing: 62)
            }
        case .iPhoneAir, .iPhone14ProMax, .iPhone15Plus, .iPhone15ProMax, .iPhone16Plus:
            return switch orientation {
            case .portrait: EdgeInsets(top: 59, leading: 0, bottom: 34, trailing: 0)
            case .landscape: EdgeInsets(top: 0, leading: 59, bottom: 21, trailing: 59)
            }
        case .iPhone14Plus, .iPhone14:
            return switch orientation {
            case .portrait: EdgeInsets(top: 47, leading: 0, bottom: 34, trailing: 0)
            case .landscape: EdgeInsets(top: 0, leading: 47, bottom: 21, trailing: 47)
            }
        case .iPhone17, .iPhone16, .iPhone15, .iPhone14Pro, .iPhone15Pro:
            return switch orientation {
            case .portrait: EdgeInsets(top: 59, leading: 0, bottom: 34, trailing: 0)
            case .landscape: EdgeInsets(top: 0, leading: 59, bottom: 21, trailing: 59)
            }
        case .iPad:
            return EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
        case .iPadMini:
            return EdgeInsets(top: 24, leading: 0, bottom: 20, trailing: 0)
        case .iPadPro13M4, .iPadPro11M4, .iPadAir13M2, .iPadAir11M2:
            return EdgeInsets(top: 24, leading: 0, bottom: 20, trailing: 0)
        }
    }

    var horizontalSizeClass: UserInterfaceSizeClass {
        switch model.category {
        case .iPad:
            // iPadは常にregular
            return .regular
        case .iPhone:
            switch orientation {
            case .portrait:
                return .compact
            case .landscape:
                // Plus/Max系はlandscapeでregular
                switch model {
                case .iPhone17ProMax, .iPhoneAir, .iPhone16ProMax, .iPhone16Plus,
                    .iPhone15ProMax, .iPhone15Plus, .iPhone14ProMax, .iPhone14Plus:
                    return .regular
                default:
                    return .compact
                }
            }
        }
    }

    var verticalSizeClass: UserInterfaceSizeClass {
        switch model.category {
        case .iPad:
            // iPadは常にregular
            return .regular
        case .iPhone:
            switch orientation {
            case .portrait:
                return .regular
            case .landscape:
                return .compact
            }
        }
    }
}
