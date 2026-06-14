//
//  Color.swift
//  NailongPet
//

import SwiftUI
import UIKit

extension Color {
    // MARK: - Brand Colors
    static let brandPrimary   = Color(hex: 0xC9865A)
    static let brandSecondary = Color(hex: 0x8D7966)
    static let brandTertiary  = Color(hex: 0xE2DEDB)

    // MARK: - Text Colors
    static let textPrimary   = Color(light: 0x000000, dark: 0xFFFFFF)
    static let textSecondary = Color(light: 0x8E8E93, dark: 0x8E8E93)

    // MARK: - Surface Colors
    static let surfacePrimary   = Color(light: 0xFFFFFF, dark: 0x1C1C1E)
    static let surfaceSecondary = Color(light: 0x000000, dark: 0xFFFFFF)
    static let surfaceCanvas    = Color(light: 0xE2DEDB, dark: 0x000000)
    static let surfaceCard      = Color(light: 0x8D7966, dark: 0x2C2C2E)

    // MARK: - Fixed Content Colors
    static let onBrand = Color.white
    static let scrim   = Color.black

    // MARK: - Action Colors
    static let actionDefault  = Color(hex: 0x007AFF)
    static let actionSucceed  = Color(hex: 0x34C759)
    static let actionDisabled = Color(hex: 0x8E8E93)
}

// MARK: - Initializers
extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double(hex & 0xff) / 255,
            opacity: alpha
        )
    }

    init(light: UInt, dark: UInt) {
        self = Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(Color(hex: dark))
                : UIColor(Color(hex: light))
        })
    }
}
