//
//  LidarStepRow.swift
//  NailongPet
//
//  Created by Fakhri Djamaris on 05/06/26.
//

import SwiftUI

struct LidarStepRow: View {
    var icon: AppIcon
    var text: String
    var showLine: Bool = true // Menentukan apakah garis vertikal di bawah ikon muncul
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Kolom Kiri: Ikon dan Garis Penghubung
            VStack(spacing: 8) {
                icon.image
                    .font(.subheadRegular)
                    .foregroundColor(.beigeTertiaryBrand) // Token Warna
                
                if showLine {
                    // Garis putus-putus vertikal
                    VStack {}
                        .frame(width: 2, height: 24)
                        .background(
                            Color.beigeTertiaryBrand
                                .opacity(0.5)
                        )
                }
            }
            .frame(width: 24)
            
            // Kolom Kanan: Teks Panduan
            Text(text)
                .font(.subheadRegular) // Token Font
                .foregroundColor(.whitePrimarySurface) // Token Warna
                .padding(.top, 2)
            
            Spacer()
        }
    }
}

#Preview {
    LidarStepRow(icon: AppIcon.pawLoading, text: "Step 1", showLine: false)
}
