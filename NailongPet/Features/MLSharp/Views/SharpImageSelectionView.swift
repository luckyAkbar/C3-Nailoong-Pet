//
//  SharpImageSelection.swift
//  NailongPet
//

import SwiftUI
import PhotosUI

struct SharpImageSelectionView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var sharpViewModel: SHARPViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: Image? = nil
    @State private var isShowingInstructionSheet: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack{
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    selectionCard
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 24)
                .onChange(of: selectedItem) {
                    Task {
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            sharpViewModel.selectedImage = uiImage
                            selectedImage = Image(uiImage: uiImage)
                        }
                    }
                }
                VStack{
                    Spacer()
                    
                    Button(action: {
                        if let uiImage = sharpViewModel.selectedImage {
                            Task {
                                await sharpViewModel.process(uiImage: uiImage)
                            }
                            router.navigate(to: .processPage(.mlSharp))
                        }
                    }) {
                        Text("Create 3D")
                            .font(.subheadBold)
                            .foregroundColor(sharpViewModel.selectedImage != nil ? .textPrimary : Color.white.opacity(0.5))
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(
                                sharpViewModel.selectedImage != nil
                                    ? Color.surfaceCard        // neutral brown/gray when active
                                    : Color.brandPrimary.opacity(0.4)  // muted when disabled
                            )
                            .clipShape(Capsule())
                            .padding(.horizontal, 100)
                            .padding(.bottom, 24)
                    }
                    .disabled(sharpViewModel.selectedImage == nil)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                }
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundLayer.ignoresSafeArea())
        }
        .sheet(isPresented: $isShowingInstructionSheet) {
            SharpPhotoInstructionSheet()
                .presentationDetents([.fraction(0.85)])
                .presentationDragIndicator(.visible)
        }
        .navigationTitle("Best Photo for Best Moment")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { isShowingInstructionSheet = true }) {
                    HStack(spacing: 4) {
                        AppIcon.infoTips.image
                            .font(.system(size: 14))
                        Text("Tips")
                            .font(.footnoteRegular)
                    }
                    .foregroundColor(.textPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.thinMaterial, in: Capsule())
                    .overlay(Capsule().strokeBorder(Color.primary.opacity(0.12), lineWidth: 0.5))
                }
                .buttonStyle(.plain)  // plain — no system button chrome
            }
        }
    }

    private var selectionCard: some View {
        GeometryReader { cardGeometry in
            ZStack {
                if let selectedImage {
                    selectedImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: cardGeometry.size.width, height: cardGeometry.size.height)
                        .clipped()
                } else {
                    Color.clear
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.ultraThinMaterial)
                    
                    VStack(spacing: 18) {
                        AppIcon.imagePlaceholder.image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 112, height: 112)
                            .foregroundColor(.textTertiary)

                        VStack(spacing: 10) {
                            Text("Pick a Photo")
                                .font(.title1Bold)
                                .foregroundColor(.textPrimary)

                            Text("To ensure the highest quality 3D model, please prepare a clean photo of your pet with bright, even lighting, making sure their entire body is fully visible from a slightly high angle.")
                                .font(.footnoteRegular)
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.horizontal, 28)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium.value, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium.value, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.9),
                                Color.white.opacity(0.3),
                                Color.white.opacity(0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
        }
    }

    private var backgroundLayer: some View {
        Color.surfaceCanvas
    }
}

#Preview {
    NavigationStack {
        SharpImageSelectionView()
            .environmentObject(AppRouter())
            .environmentObject(SHARPViewModel())
    }
}
