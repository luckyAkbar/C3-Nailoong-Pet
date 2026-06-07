//
//  SharpImageSelection.swift
//  NailongPet
//
//  Created by carstenz meru phantara on 07/06/26.
//

import SwiftUI
import PhotosUI

struct SharpImageSelectionView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: Image? = nil
    @State private var isShowingInstructionSheet: Bool = true
    
    var body: some View {
        VStack{
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
                            .background(Color.blackSecondarySurface.opacity(0.1))
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
                        .background(Color.blackSecondarySurface.opacity(0.1))
                        .cornerRadius(CornerRadius.full.value) // Token Radius (Pill)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            
            Spacer()
            // MARK: - Content


            PhotosPicker(selection: $selectedItem, matching: .images) {
                if selectedImage != nil {
                    MenuSelection(
                        icon: .cameraGuideline,
                        title: "Choose your pet photo",
                        subtitle: "Preserve the moment with your pet",
                        selectedImage: $selectedImage
                    ).padding()
                } else {
                    MenuSelection(
                        icon: .cameraGuideline,
                        title: "Choose your pet photo",
                        subtitle: "Preserve the moment with your pet",
                    ).padding()
                }
            }
            .onChange(of: selectedItem) {
                Task {
                    if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = Image(uiImage: uiImage)
                    }
                }
            }
                    
            
            Spacer()
            
            BrandButton(
                text: "Start"
            )
    
            // MARK: - Instruction Sheet
            
            .sheet(isPresented: $isShowingInstructionSheet) {
                SharpInstructionSheet()
                    .presentationDetents([.fraction(0.85)]) // Setinggi 85% layar sesuai mockup
                    .presentationDragIndicator(.visible)    // Menampilkan handle garis abu-abu di atas modal
            }
        }
    }
}

#Preview {
    SharpImageSelectionView()
}
