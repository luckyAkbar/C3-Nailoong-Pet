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
            VStack(alignment: .leading, spacing: 16) {
                Text("Walk Around Your Pet to Scan in 3D")
                    .font(.title2Bold)
                    .foregroundColor(.textPrimary)

                VStack(alignment: .leading, spacing: 10) {
                    ScanningTipRow(number: "1", text: "Make sure the room is bright and evenly lit")
                    ScanningTipRow(number: "2", text: "Place your pet in the center, then tap Record")
                    ScanningTipRow(number: "3", text: "Walk slowly in a full circle (360°) around your pet — don't stay in one spot")
                    ScanningTipRow(number: "4", text: "Keep scanning until the bar turns green (minimum 20 shots)")
                }
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

// MARK: - Private Sub-views

private struct ScanningTipRow: View {
    var number: String
    var text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.textPrimary)
                .frame(width: 22, height: 22)
                .background(Color.textPrimary.opacity(0.12))
                .clipShape(Circle())

            Text(text)
                .font(.footnoteRegular)
                .foregroundColor(Color.textPrimary.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
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
