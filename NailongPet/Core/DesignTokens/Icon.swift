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
    case delete = "trash"
    case more = "ellipsis"
    case close = "xmark"
    case check = "checkmark"
    case back = "chevron.left"
    case infoTips = "lightbulb"
    case moli = "Moli"
    
    // MARK: - App Features & States
    case bringTo3D = "square.2.layers.3d"
    case interact = "hands.clap"
    case pawLoading = "pawprint.fill"
    case walkAround = "arrow.clockwise"
    case cameraGuideline = "camera"
    case recordingPause = "pause.circle"
    case imagePlaceholder = "photo"
    case favoriteMoment = "square.grid.3x3.square"
    case scanCompanion = "camera.fill"
    case photoSearch = "photo.badge.magnifyingglass"
    
    //AR interaction Icon
    static let chevronLeft = "chevron.left"
    static let pawPrint = "pawprint.fill"
    static let handRaised = "hand.raised.fill"
    static let handTap = "hand.tap.fill"
    static let personWave = "person.wave.2.fill"
    
    //asset collection
    case firstOnboardingImg = "AssetOnboardingSatu"
    case secondOnboardingImg = "AssetOnboardingDua"
    
    /// Properti pembantu untuk langsung mengeluarkan komponen Image siap pakai.
    /// Case .moli menggunakan Image asset, sisanya SF Symbol.
    var image: Image {
        switch self {
        case .moli: return Image(self.rawValue)
        default:    return Image(systemName: self.rawValue)
        }
    }
}
