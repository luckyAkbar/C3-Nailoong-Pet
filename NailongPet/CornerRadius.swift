//
//  CornerRadius.swift
//  NailongPet
//
//  Created by Fakhri Djamaris on 05/06/26.
//

import Foundation
import SwiftUI

enum CornerRadius {
    /// 8px rounded - Untuk kotak galeri (GalleryItem) dan susunan kotak menyamping
    case small
    
    /// 22px rounded - Untuk Card, MenuSelection, GradientShape, InstructionPanel, dan TextArea
    case medium
    
    /// Fully Rounded - Untuk tombol navigasi, tips, label, dan pill button
    case full
    
    var value: CGFloat {
        switch self {
        case .small:
            return 8
        case .medium:
            return 22
        case .full:
            return 100 // Nilai tinggi konstan untuk memicu bentuk kapsul sempurna
        }
    }
}
