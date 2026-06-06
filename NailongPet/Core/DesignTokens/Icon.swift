//
//  Icon.swift
//  NailongPet
//
//  Design Token - Single Source of Truth untuk semua ikon SF Symbol aplikasi
//

import Foundation
import SwiftUI

enum AppIcon: String {
    // MARK: - Button Actions
    case add = "plus"
    case edit = "pencil"
    case close = "xmark"
    case check = "checkmark"
    case back = "chevron.left"
    case infoTips = "lightbulb"
    case moli = "Moli"
    
    // MARK: - App Features & States
    case bringTo3D = "square.2.layers.3d"
    case interact = "hands.clap"
    case pawLoading = "pawprint.fill"
    case cameraGuideline = "camera"
    case recordingPause = "pause.circle"
    case imagePlaceholder = "photo"
    case favoriteMoment = "square.grid.3x3.square"
    case scanCompanion = "camera.fill"
    
    /// Properti pembantu untuk langsung mengeluarkan komponen Image siap pakai
    var image: Image {
        return Image(systemName: self.rawValue)
    }
}
