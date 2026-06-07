//
//  LidarCaptureThumbnail.swift
//  NailongPet
//
//  Created by Fakhri Djamaris on 05/06/26.
//

import SwiftUI

struct LidarCaptureThumbnail: View {
    // Parameter input opsional: menerima nama aset atau UIImage dari kamera
    var imageName: String?
    
    var body: some View {
        Group {
            if let name = imageName {
                Image(name)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48, height: 48)
                    .cornerRadius(CornerRadius.small.value)
                    .clipped()
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.small.value)
                            .stroke(Color.whitePrimarySurface.opacity(0.4), lineWidth: 1)
                    )
            } else {
                // Jika belum ada gambar yang tercapture, sembunyikan / beri space kosong
                Color.clear
                    .frame(width: 48, height: 48)
            }
        }
    }
}

// MARK: - Previews
#Preview("Belum Ada Capture") {
    LidarCaptureThumbnail(imageName: nil)
        .padding()
        .background(Color.blackSecondarySurface)
}

#Preview("Sudah Ter-capture") {
    LidarCaptureThumbnail(imageName: "Moli")
        .padding()
        .background(Color.blackSecondarySurface)
}
