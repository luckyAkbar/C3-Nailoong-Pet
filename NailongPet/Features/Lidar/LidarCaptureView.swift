//
//  LidarCaptureView.swift
//  NailongPet
//
//  Created by Fakhri Djamaris on 05/06/26.
//

import SwiftUI

struct LidarCaptureView: View {
    // State management untuk mengontrol kemunculan pop-up sheet instruksi
    @State private var isShowingInstructionSheet: Bool = true
    
    var body: some View {
        ZStack {
            // Background dasar (Simulasi Kamera Feed LiDAR menggunakan token abu-abu)
            Color.graySecondaryText
                .ignoresSafeArea()
            
            // Konten UI Utama Kamera
            VStack {
                // MARK: - Top Navigation Bar
                HStack {
                    // Tombol Cancel/Close (Ikon X)
                    Button(action: {
                        // Aksi untuk kembali ke halaman sebelumnya
                    }) {
                        AppIcon.close.image
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.blackPrimaryText)
                            .padding(10)
                            .background(Color.whitePrimarySurface.opacity(0.8))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    // Tombol Tips untuk memicu sheet instruksi muncul kembali
                    Button(action: {
                        isShowingInstructionSheet = true
                    }) {
                        HStack(spacing: 4) {
                            AppIcon.infoTips.image
                            Text("Tips")
                                .font(.footnoteRegular) // Token Font
                        }
                        .foregroundColor(.blackPrimaryText)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.whitePrimarySurface.opacity(0.8))
                        .cornerRadius(CornerRadius.full.value) // Token Radius (Pill)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                Spacer()
                
                // MARK: - Center Floating Instruction Bubble
                Text("Point your camera at your pet,\nthen tap record to begin")
                    .font(.subheadRegular) // Token Font
                    .foregroundColor(.blackPrimaryText) // Token Warna
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.whitePrimarySurface.opacity(0.9)) // Token Warna
                    .cornerRadius(CornerRadius.small.value) // Token Radius (8px)
                    .padding(.bottom, 24)
                    .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
                
                // MARK: - Bottom Reusable Control Panel
                // Kita panggil komponen panel bawah yang sudah diisolasi sebelumnya
                LidarControlPanel()
            }
        }
        // MARK: - Sheet Presentation Modifier
        // Menampilkan lembar panduan otomatis saat halaman pertama kali terbuka
        .sheet(isPresented: $isShowingInstructionSheet) {
            LidarPreservedInstructionSheet()
                .presentationDetents([.fraction(0.85)]) // Setinggi 85% layar sesuai mockup
                .presentationDragIndicator(.visible)    // Menampilkan handle garis abu-abu di atas modal
        }
    }
}

#Preview {
    LidarCaptureView()
}
