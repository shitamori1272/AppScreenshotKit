//
//  AppleDesignResourceBezelDefinition.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/01.
//
// This struct defines bezel image and screen rect information for Apple device models and orientations.

import Foundation

/// Defines bezel image and screen rect information for Apple device models and orientations.
struct AppleDesignResourceBezelDefinition {
    let imageSize: CGSize
    let screenRect: CGRect

    /// Initializes bezel definition for a given device model and orientation.
    /// - Parameters:
    ///   - deviceModel: The device model (e.g., iPhone16ProMax).
    ///   - orientation: The device orientation (portrait or landscape).
    init(deviceModel: DeviceModel, orientation: DeviceOrientation) {
        switch deviceModel {
        case .iPhone17ProMax:
            switch orientation {
            case .portrait:
                self.imageSize = CGSize(width: 1470, height: 3000)
                self.screenRect = CGRect(x: 75, y: 66, width: 1320, height: 2868)
            case .landscape:
                self.imageSize = CGSize(width: 3000, height: 1470)
                self.screenRect = CGRect(x: 66, y: 75, width: 2868, height: 1320)
            }
        case .iPhoneAir:
            switch orientation {
            case .portrait:
                self.imageSize = CGSize(width: 1380, height: 2880)
                self.screenRect = CGRect(x: 60, y: 72, width: 1260, height: 2736)
            case .landscape:
                self.imageSize = CGSize(width: 2880, height: 1380)
                self.screenRect = CGRect(x: 72, y: 60, width: 2736, height: 1260)
            }
        case .iPhone17Pro:
            switch orientation {
            case .portrait:
                self.imageSize = CGSize(width: 1350, height: 2760)
                self.screenRect = CGRect(x: 72, y: 69, width: 1206, height: 2622)
            case .landscape:
                self.imageSize = CGSize(width: 2760, height: 1350)
                self.screenRect = CGRect(x: 69, y: 72, width: 2622, height: 1206)
            }
        case .iPhone17:
            switch orientation {
            case .portrait:
                self.imageSize = CGSize(width: 1350, height: 2760)
                self.screenRect = CGRect(x: 72, y: 69, width: 1206, height: 2622)
            case .landscape:
                self.imageSize = CGSize(width: 2760, height: 1350)
                self.screenRect = CGRect(x: 69, y: 72, width: 2622, height: 1206)
            }
        case .iPhone16ProMax:
            switch orientation {
            case .portrait:
                self.imageSize = CGSize(width: 1470, height: 3000)
                self.screenRect = CGRect(x: 75, y: 66, width: 1320, height: 2868)
            case .landscape:
                self.imageSize = CGSize(width: 3000, height: 1470)
                self.screenRect = CGRect(x: 66, y: 75, width: 2868, height: 1320)
            }
        case .iPhone16Plus:
            switch orientation {
            case .portrait:
                self.imageSize = CGSize(width: 1470, height: 2970)
                self.screenRect = CGRect(x: 90, y: 87, width: 1290, height: 2796)
            case .landscape:
                self.imageSize = CGSize(width: 2970, height: 1470)
                self.screenRect = CGRect(x: 87, y: 90, width: 2796, height: 1290)
            }
        case .iPhone15ProMax:
            switch orientation {
            case .portrait:
                self.imageSize = CGSize(width: 1530, height: 3036)
                self.screenRect = CGRect(x: 120, y: 120, width: 1290, height: 2796)
            case .landscape:
                self.imageSize = CGSize(width: 3036, height: 1530)
                self.screenRect = CGRect(x: 120, y: 120, width: 2796, height: 1290)
            }
        case .iPhone15Plus:
            switch orientation {
            case .portrait:
                self.imageSize = CGSize(width: 1530, height: 3036)
                self.screenRect = CGRect(x: 120, y: 120, width: 1290, height: 2796)
            case .landscape:
                self.imageSize = CGSize(width: 3036, height: 1530)
                self.screenRect = CGRect(x: 120, y: 120, width: 2796, height: 1290)
            }
        case .iPhone14ProMax:
            switch orientation {
            case .portrait:
                self.imageSize = CGSize(width: 1450, height: 2936)
                self.screenRect = CGRect(x: 80, y: 70, width: 1290, height: 2796)
            case .landscape:
                self.imageSize = CGSize(width: 2936, height: 1450)
                self.screenRect = CGRect(x: 70, y: 80, width: 2796, height: 1290)
            }
        case .iPhone14Plus:
            switch orientation {
            case .portrait:
                self.imageSize = CGSize(width: 1464, height: 2978)
                self.screenRect = CGRect(x: 90, y: 100, width: 1284, height: 2778)
            case .landscape:
                self.imageSize = CGSize(width: 2978, height: 1464)
                self.screenRect = CGRect(x: 100, y: 90, width: 2778, height: 1284)
            }
        case .iPhone16Pro:
            switch orientation {
            case .portrait:
                self.imageSize = CGSize(width: 1350, height: 2760)
                self.screenRect = CGRect(x: 72, y: 69, width: 1206, height: 2622)
            case .landscape:
                self.imageSize = CGSize(width: 2760, height: 1350)
                self.screenRect = CGRect(x: 69, y: 72, width: 2622, height: 1206)
            }
        case .iPhone16:
            switch orientation {
            case .portrait:
                self.imageSize = CGSize(width: 1359, height: 2736)
                self.screenRect = CGRect(x: 90, y: 90, width: 1179, height: 2556)
            case .landscape:
                self.imageSize = CGSize(width: 2736, height: 1359)
                self.screenRect = CGRect(x: 90, y: 90, width: 2556, height: 1179)
            }
        case .iPhone15Pro:
            switch orientation {
            case .portrait:
                self.imageSize = CGSize(width: 1419, height: 2796)
                self.screenRect = CGRect(x: 120, y: 120, width: 1179, height: 2556)
            case .landscape:
                self.imageSize = CGSize(width: 2796, height: 1419)
                self.screenRect = CGRect(x: 120, y: 120, width: 2556, height: 1179)
            }
        case .iPhone15:
            switch orientation {
            case .portrait:
                self.imageSize = CGSize(width: 1419, height: 2796)
                self.screenRect = CGRect(x: 120, y: 120, width: 1179, height: 2556)
            case .landscape:
                self.imageSize = CGSize(width: 2796, height: 1419)
                self.screenRect = CGRect(x: 120, y: 120, width: 2556, height: 1179)
            }
        case .iPhone14Pro:
            switch orientation {
            case .portrait:
                self.imageSize = CGSize(width: 1339, height: 2716)
                self.screenRect = CGRect(x: 80, y: 80, width: 1179, height: 2556)
            case .landscape:
                self.imageSize = CGSize(width: 2716, height: 1339)
                self.screenRect = CGRect(x: 80, y: 79, width: 2556, height: 1179)
            }
        case .iPhone14:
            switch orientation {
            case .portrait:
                self.imageSize = CGSize(width: 1370, height: 2732)
                self.screenRect = CGRect(x: 100, y: 101, width: 1170, height: 2531)
            case .landscape:
                self.imageSize = CGSize(width: 2732, height: 1370)
                self.screenRect = CGRect(x: 101, y: 100, width: 2531, height: 1170)
            }
        case .iPadPro11M4:
            switch orientation {
            case .portrait:
                self.imageSize = CGSize(width: 1880, height: 2640)
                self.screenRect = CGRect(x: 106, y: 110, width: 1668, height: 2420)
            case .landscape:
                self.imageSize = CGSize(width: 2640, height: 1880)
                self.screenRect = CGRect(x: 110, y: 106, width: 2420, height: 1668)
            }
        case .iPadPro13M4:
            switch orientation {
            case .portrait:
                self.imageSize = CGSize(width: 2300, height: 3000)
                self.screenRect = CGRect(x: 118, y: 124, width: 2064, height: 2752)
            case .landscape:
                self.imageSize = CGSize(width: 3000, height: 2300)
                self.screenRect = CGRect(x: 124, y: 118, width: 2752, height: 2064)
            }
        case .iPadAir11M2:
            switch orientation {
            case .portrait:
                self.imageSize = CGSize(width: 1900, height: 2620)
                self.screenRect = CGRect(x: 130, y: 130, width: 1640, height: 2360)
            case .landscape:
                self.imageSize = CGSize(width: 2620, height: 1900)
                self.screenRect = CGRect(x: 130, y: 130, width: 2360, height: 1640)
            }
        case .iPadAir13M2:
            switch orientation {
            case .portrait:
                self.imageSize = CGSize(width: 2300, height: 2980)
                self.screenRect = CGRect(x: 126, y: 124, width: 2048, height: 2732)
            case .landscape:
                self.imageSize = CGSize(width: 2980, height: 2300)
                self.screenRect = CGRect(x: 124, y: 126, width: 2732, height: 2048)
            }
        case .iPadMini:
            switch orientation {
            case .portrait:
                self.imageSize = CGSize(width: 1780, height: 2550)
                self.screenRect = CGRect(x: 146, y: 142, width: 1488, height: 2266)
            case .landscape:
                self.imageSize = CGSize(width: 2550, height: 1780)
                self.screenRect = CGRect(x: 142, y: 146, width: 2266, height: 1488)
            }
        case .iPad:
            switch orientation {
            case .portrait:
                self.imageSize = CGSize(width: 1840, height: 2660)
                self.screenRect = CGRect(x: 110, y: 250, width: 1620, height: 2160)
            case .landscape:
                self.imageSize = CGSize(width: 2660, height: 1840)
                self.screenRect = CGRect(x: 250, y: 110, width: 2160, height: 1620)
            }
        }
    }
}
