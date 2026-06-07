//
//  LidarControlPanel.swift
//  NailongPet
//
//  Created by Fakhri Djamaris on 05/06/26.
//

import SwiftUI

struct LidarControlPanel: View {
    var body: some View {
        VStack(spacing: 24) {
            // Baris Tombol Kontrol
            HStack {
                // Tombol Finish (Statis Gray/Disabled)
                Text("Finish")
                    .font(.subheadRegular)
                    .foregroundColor(.blackPrimaryText)
                    .frame(width: 85, height: 44)
                    .background(Color.whitePrimarySurface.opacity(0.5))
                    .cornerRadius(CornerRadius.full.value) // Token Radius (Pill)
                
                Spacer()
                
                // Tombol Shutter Kamera
                ZStack {
                    Circle()
                        .stroke(Color.whitePrimarySurface, lineWidth: 4)
                        .frame(width: 72, height: 72)
                    Circle()
                        .fill(Color.whitePrimarySurface)
                        .frame(width: 58, height: 58)
                }
                
                Spacer()
                
                // Placeholder Spacing untuk Thumbnail di kanan agar seimbang
                Color.clear
                    .frame(width: 85, height: 44)
            }
            .padding(.horizontal, 24)
            
            // Baris Slider Progress Durasi Scan
            VStack(spacing: 8) {
                // Batang Slider Statis
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.whitePrimarySurface.opacity(0.3))
                        .frame(height: 6)
                    Capsule()
                        .fill(Color.whitePrimarySurface)
                        .frame(width: 80, height: 6) // Lebar statis untuk tampilan awal
                }
                
                // Label Angka Limit
                HStack {
                    Text("20 (min)")
                    Spacer()
                    Text("100 (max)")
                }
                .font(.footnoteRegular) // Token Font
                .foregroundColor(.whitePrimarySurface.opacity(0.8))
            }
            .padding(.horizontal, 24)
        }
        .padding(.vertical, 28)
        .background(Color.blackSecondarySurface.opacity(0.4)) // Token Warna + Opacity
    }
}

#Preview {
    LidarControlPanel()
}
