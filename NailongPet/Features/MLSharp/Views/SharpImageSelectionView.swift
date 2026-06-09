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
                CircularIconButton(
                    icon: .close,
                    background: Color.blackSecondarySurface.opacity(0.1),
                    foreground: .blackPrimaryText,
                    action: { dismiss() }
                )
                Spacer()
                TipsButton(action: { isShowingInstructionSheet = true })
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)

            Spacer()

            // MARK: - Photo Picker
            PhotosPicker(selection: $selectedItem, matching: .images) {
                if selectedImage != nil {
                    CardMenuSelectionDefault(
                        icon: .cameraGuideline,
                        title: "Choose your pet photo",
                        subtitle: "Preserve the moment with your pet",
                        selectedImage: $selectedImage
                    ).padding()
                } else {
                    CardMenuSelectionDefault(
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
            ButtonPrimaryDefault(
                text: "Start",
                action: { router.navigate(to: .processPage) }
            )
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
