//
//  Color.swift
//  NailongPet
//
//  Created by Lucky Akbar on 05/06/26.
//

import SwiftUI

extension Color {
    static let BrandColorPrimary = Color(hex: 0xC9865A)
    static let BrandColorSecondary = Color(hex: 0x8D7966)
    static let BrandColorTertiary = Color(hex: 0xE2DEDB)
}

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
