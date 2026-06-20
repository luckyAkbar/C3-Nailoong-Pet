//
//  Color.swift
//  NailongPet
//

import SwiftUI
import UIKit

@available(*, deprecated, message: "Warna ini sudah deprecated (tidak digunakan). Harap gunakan warna dari sistem desain terbaru.")
extension Color {
    // Brand Colors
    static let orangePrimaryBrand = Color(hex: 0xC9865A)
    static let brownSecondaryBrand = Color(hex: 0x8D7966)
    static let beigeTertiaryBrand = Color(hex: 0xE2DEDB)
    
    // Text Colors
    static let blackPrimaryText = Color(hex: 0x000000)
    static let graySecondaryText = Color(hex: 0x8E8E93)
    
    // Surface Colors
    static let whitePrimarySurface = Color(hex: 0xFFFFFF)
    static let blackSecondarySurface = Color(hex: 0x000000)
    
    // MARK: - Action & Utility Colors
    static let blueDefaultAction = Color(hex: 0x007AFF)   // Label fully rounded / tips
    static let greenSucceedAction = Color(hex: 0x34C759)   // Button ARAction Succeed
    static let grayDisabledAction = Color(hex: 0x8E8E93)   // Button ARAction Disabled
}


extension Color {
    // MARK: - Brand Colors
    static let brandPrimary   = Color(hex: 0xD7B655)
    static let brandSecondary = Color(hex: 0x2C2520)
    static let brandTertiary  = Color(hex: 0xE2DEDB)

    
    // MARK: - Text Colors
    static let textPrimary   = Color(hex: 0x4B3F1C)
    static let textSecondary = Color(hex: 0x736744)
    static let textTertiary  = Color(light: 0x8E8E93, dark: 0x8E8E93)


    // MARK: - Surface Colors
    static let surfacePrimary   = Color(light: 0xFFFFFF, dark: 0x1C1C1E)
    static let surfaceSecondary = Color(light: 0x000000, dark: 0xFFFFFF)
    static let surfaceCanvas    = Color(light: 0xE2DEDB, dark: 0x000000)
    static let surfaceCard      = Color(light: 0x8D7966, dark: 0x2C2C2E)
    static let surfacePetItem   = Color(light: 0xE8E8E8, dark: 0xE8E8E8)

    // MARK: - Fixed Content Colors
    static let onBrand = Color.white
    static let scrim   = Color.black
    static let avatarPetItem   = Color(light: 0x767676, dark: 0x767676)

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
