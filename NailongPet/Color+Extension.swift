//
//  Color+Extension.swift
//  NailongPet
//
//  Created by Fakhri Djamaris on 05/06/26.
//

import Foundation
import SwiftUI

extension Color {
    // MARK: - Brand Colors
    static let orangePrimaryBrand = Color("#C9865A")
    static let brownSecondaryBrand = Color("#8D7966")
    static let beigeTertiaryBrand = Color("#E2DEDB")
    
    // MARK: - Text Colors
    static let blackPrimaryText = Color("#000000")
    static let graySecondaryText = Color("#8E8E93")
    
    // MARK: - Surface Colors
    static let whitePrimarySurface = Color("#FFFFFF")
    static let blackSecondarySurface = Color("#000000")
    
    // MARK: - Action & Utility Colors
    static let blueDefaultAction = Color("#007AFF") // Label fully rounded / tips
    static let greenSucceedAction = Color("#34C759") // Button ARAction Succeed
    static let grayDisabledAction = Color("#8E8E93") // Button ARAction Disabled
    
    // MARK: - Hex Initializer
    init(_ hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
