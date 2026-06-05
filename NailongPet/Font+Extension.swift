//
//  Font+Extension.swift
//  NailongPet
//
//  Created by Fakhri Djamaris on 05/06/26.
//

import Foundation
import SwiftUI

extension Font {
    /// Title 1 (SF Pro Rounded, Bold, 28) - Tulisan di homepage
    static let title1Bold = Font.system(size: 28, weight: .bold, design: .rounded)
    
    /// Title 2 (SF Pro Rounded, Bold, 22) - Title tiap page
    static let title2Bold = Font.system(size: 22, weight: .bold, design: .rounded)
    
    /// Subhead (SF Pro Rounded, Regular, 15) - Bodytext, guideline
    static let subheadRegular = Font.system(size: 15, weight: .regular, design: .rounded)
    
    /// Footnote (SF Pro Rounded, Regular, 13) - Keterangan interaksi kecil
    static let footnoteRegular = Font.system(size: 13, weight: .regular, design: .rounded)
}
