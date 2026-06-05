//
//  AppIcon.swift
//  NailongPet
//
//  Created by Fakhri Djamaris on 05/06/26.
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
    
    // MARK: - App Features & States
    case bringTo3D = "square.stack"
    case pawLoading = "pawprint.fill"
    case cameraGuideline = "camera"
    case recordingPause = "pause.circle"
    
    /// Properti pembantu untuk langsung mengeluarkan komponen Image siap pakai
    var image: Image {
        return Image(systemName: self.rawValue)
    }
}
