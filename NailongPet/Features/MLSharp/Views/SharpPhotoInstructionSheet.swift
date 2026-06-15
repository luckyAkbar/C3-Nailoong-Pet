//
//  SharpPhotoInstructionSheet.swift
//  NailongPet
//
//  Layar instruksi penuh dengan native liquid glass style untuk alur foto (MLSharp).
//

import SwiftUI

struct SharpPhotoInstructionSheet: View {
    var onBack: () -> Void = {}
    var onStart: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Navigation Bar
            ZStack {
                HStack {
                    Button(action: onBack) {
                        AppIcon.back.image
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.textPrimary)
                    }
                    .buttonStyle(.glass)
                    Spacer()
                }

                Text("Best Photo for the Best Moment")
                    .font(.subheadBold)
                    .foregroundColor(.textPrimary)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)

            Spacer()

            // MARK: - Illustration
            AppIcon.photoSearch.image
                .resizable()
                .scaledToFit()
                .frame(height: 160)
                .foregroundColor(.textPrimary)

            Spacer()

            // MARK: - Text Content
            VStack(alignment: .leading, spacing: 12) {
                Text("Prepare a Clear Photo of Your Pet")
                    .font(.title2Bold)
                    .foregroundColor(.textPrimary)

                Text("To ensure the highest quality 3D model, please prepare a clean photo of your pet with bright, even lighting, making sure their entire body is fully visible from a slightly high angle.")
                    .font(.footnoteRegular)
                    .foregroundColor(Color.textPrimary.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)

            Spacer()

            // MARK: - Action Button
            Button(action: onStart) {
                Text("Choose Photo")
                    .font(.subheadBold)
                    .foregroundColor(.textPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
            }
            .buttonStyle(.glass)
            .padding(.horizontal, 40)
            .padding(.bottom, 34)
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.white.ignoresSafeArea()
        SharpPhotoInstructionSheet()
    }
}
