//
//  Color.swift
//  NailongPet
//
//  Design Token - Single Source of Truth untuk semua warna aplikasi
//

import SwiftUI

extension Color {
    // MARK: - Brand Colors
    static let orangePrimaryBrand = Color(hex: 0xC9865A)
    static let brownSecondaryBrand = Color(hex: 0x8D7966)
    static let beigeTertiaryBrand = Color(hex: 0xE2DEDB)
    
    // MARK: - Text Colors
    static let blackPrimaryText = Color(hex: 0x000000)
    static let graySecondaryText = Color(hex: 0x8E8E93)
    
    // MARK: - Surface Colors
    static let whitePrimarySurface = Color(hex: 0xFFFFFF)
    static let blackSecondarySurface = Color(hex: 0x000000)
    
    // MARK: - Action & Utility Colors
    static let blueDefaultAction = Color(hex: 0x007AFF)   // Label fully rounded / tips
    static let greenSucceedAction = Color(hex: 0x34C759)   // Button ARAction Succeed
    static let grayDisabledAction = Color(hex: 0x8E8E93)   // Button ARAction Disabled
}

// MARK: - Hex Initializer
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
}
