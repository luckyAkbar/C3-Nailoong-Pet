//
//  SharpImageSelection.swift
//  NailongPet
//
//  Created by carstenz meru phantara on 07/06/26.
//

import SwiftUI
import PhotosUI

struct SharpImageSelectionView: View {
    @EnvironmentObject private var router: AppRouter
    @Environment(\.dismiss) private var dismiss

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: Image? = nil
    @State private var isShowingInstructionSheet: Bool = true

    var body: some View {
        VStack {
            // MARK: - Top Navigation Bar
            HStack {
                // Tombol Cancel/Close (Ikon X)
                Button(action: { dismiss() }) {
                    AppIcon.close.image
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.blackPrimaryText)
                        .padding(10)
                        .background(Color.blackSecondarySurface.opacity(0.1))
                        .clipShape(Circle())
                }

                Spacer()

                // Tombol Tips untuk memicu sheet instruksi muncul kembali
                Button(action: { isShowingInstructionSheet = true }) {
                    HStack(spacing: 4) {
                        AppIcon.infoTips.image
                        Text("Tips")
                            .font(.footnoteRegular)
                    }
                    .foregroundColor(.blackPrimaryText)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.blackSecondarySurface.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.full.value))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)

            Spacer()

            // MARK: - Photo Picker
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
                        subtitle: "Preserve the moment with your pet"
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

            // MARK: - Start Button
            Button(action: { router.navigate(to: .processPage) }) {
                BrandButton(text: "Start")
            }
        }
        // MARK: - Instruction Sheet
        .sheet(isPresented: $isShowingInstructionSheet) {
            SharpInstructionSheet()
                .presentationDetents([.fraction(0.85)])
                .presentationDragIndicator(.visible)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    SharpImageSelectionView()
        .environmentObject(AppRouter())
}
