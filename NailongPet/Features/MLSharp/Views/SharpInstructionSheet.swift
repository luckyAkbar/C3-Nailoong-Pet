//
//  SharpInstructionSheet.swift
//  NailongPet
//
//  Created by carstenz meru phantara on 07/06/26.
//

import SwiftUI

struct SharpInstructionSheet: View {
    // Environment property untuk menutup sheet saat tombol close/start ditekan
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Drag Indicator & Header Bar
            // Drag indicator bawaan iOS akan otomatis muncul jika menggunakan modifier presentationDetents
            HStack {
                Button(action: { dismiss() }) {
                    AppIcon.close.image
                        .font(.calloutBold)
                        .foregroundColor(.blackPrimaryText)
                        .padding(10)
                        .background(Color.graySecondaryText.opacity(0.15))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text("Single Image Preserved")
                    .font(.title2Bold) // Token Font (Size 22)
                    .foregroundColor(.blackPrimaryText)
                
                Spacer()
                
                // Invisible spacer untuk penyeimbang tombol close di kiri
                Color.clear
                    .frame(width: 36, height: 36)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            CardInstructionPanelDefault(steps: [
                StepItem(icon: .pawLoading,      text: "Prepare a clean photo of your pet"),
                StepItem(icon: .infoTips,        text: "Ensure the photo has a proper lighting"),
                StepItem(icon: .cameraGuideline, text: "Show a full body of your pet. For a better result, the photo preferably from a high/slightly high angle"),
            ])
            .padding(.horizontal, 20)
            .padding(.top, 24)
            
            Spacer()
            
            // MARK: - Center Illustration (Simulasi Gambar Kucing Moli)
            Image(AppIcon.moli.rawValue)
                .resizable()
                .scaledToFit()
                .frame(height: 160)
            
            Spacer()
            
            // MARK: - Bottom Action Button
            ButtonPrimaryDefault(
                text: "Start",
                action: { dismiss() }
            )
        }
        .background(Color.whitePrimarySurface) // Token Warna Latar Sheet
    }
}

// MARK: - Preview Sheet
#Preview {
    // Preview langsung disimulasikan di dalam kontainer sheet pop-up
    Text("Main Background View")
        .sheet(isPresented: .constant(true)) {
            SharpInstructionSheet()
                .presentationDetents([.fraction(0.85)]) // Membatasi tinggi sheet setinggi ~85% layar
                .presentationDragIndicator(.visible)    // Menampilkan garis pill drag di atas sheet
        }
}
