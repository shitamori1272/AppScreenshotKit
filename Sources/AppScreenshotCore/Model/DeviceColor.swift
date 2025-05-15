//
//  DeviceColor.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/04/25.
//

// Device colors
public enum DeviceColor: String, CaseIterable, Sendable {
    // iPhone colors
    case black = "Black"
    case white = "White"
    case blue = "Blue"
    case pink = "Pink"
    case yellow = "Yellow"
    case green = "Green"
    case purple = "Purple"
    case red = "Red"
    case teal = "Teal"
    case ultramarine = "Ultramarine"
    case blackTitanium = "Black Titanium"
    case whiteTitanium = "White Titanium"
    case naturalTitanium = "Natural Titanium"
    case desertTitanium = "Desert Titanium"
    case blueTitanium = "Blue Titanium"
    case spaceBlack = "Space Black"
    case gold = "Gold"
    case deepPurple = "Deep Purple"
    case midnight = "Midnight"

    // iPad colors
    case silver = "Silver"
    case spaceGray = "Space Gray"
    case starlight = "Starlight"
    case stardust = "Stardust"
}

protocol DeviceColorConvertable {
    var deviceColor: DeviceColor { get }
}
