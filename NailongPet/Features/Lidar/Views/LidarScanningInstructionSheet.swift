//
//  LidarScanningInstructionSheet.swift
//  NailongPet
//
//  Layar instruksi penuh dengan native liquid glass style untuk alur LiDAR scanning.
//

import SwiftUI

struct LidarScanningInstructionSheet: View {
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

                Text("Pet Scanning")
                    .font(.subheadBold)
                    .foregroundColor(.textPrimary)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)

            Spacer()

            // MARK: - Illustration
            Image(AppIcon.assetScanLidarSvg.rawValue)
                .resizable()
                .scaledToFit()
                .scaleEffect(2)
                .frame(height: 160)
                .foregroundColor(.textPrimary)

            Spacer()

            // MARK: - Text Content
            VStack(alignment: .leading, spacing: 12) {
                Text("Scan Pet While They’re Stay Still")
                    .font(.title2Bold)
                    .foregroundColor(.textPrimary)

                Text("""
                For the best scan:

                •    Use bright, even lighting.
                •    Keep your pet and nearby items fully in frame.
                •    Walk slowly in a full 360° circle around your sleeping pet.
                •    Avoid sudden movements or changing the camera distance.
                """)
                    .font(.footnoteRegular)
                    .foregroundColor(Color.textPrimary.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)

            Spacer()

            // MARK: - Action Button
            Button(action: onStart) {
                Text("Start Scanning")
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
        LidarScanningInstructionSheet()
    }
}
