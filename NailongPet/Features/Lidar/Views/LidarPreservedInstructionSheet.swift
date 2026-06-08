//
//  LidarPreservedInstructionSheet.swift
//  NailongPet
//
//  Created by Fakhri Djamaris on 05/06/26.
//

import SwiftUI

struct LidarPreservedInstructionSheet: View {
    @Environment(\.dismiss) var dismiss

    private let steps: [StepItem] = [
        StepItem(icon: .pawLoading,      text: "Scan while your pet is sleeping soundly"),
        StepItem(icon: .infoTips,        text: "Ensure even, bright room lighting"),
        StepItem(icon: .walkAround,      text: "Walk 360° around your pet slowly"),
        StepItem(icon: .cameraGuideline, text: "Keep the collar, toy, or pet fully inside the box"),
    ]

    var body: some View {
        VStack(spacing: 0) {
            SheetHeaderBar(title: "3D Lidar Preserved", onClose: { dismiss() })

            CardInstructionPanelDefault(steps: steps)
                .padding(.horizontal, 20)
                .padding(.top, 24)

            Spacer()

            AppIcon.moli.image
                .resizable()
                .scaledToFit()
                .frame(height: 160)

            Spacer()

            Button(action: { dismiss() }) {
                Text("Start")
                    .font(.subheadRegular)
                    .foregroundColor(.whitePrimarySurface)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.orangePrimaryBrand)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.full.value))
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 34)
        }
        .background(Color.whitePrimarySurface)
    }
}

// MARK: - Private Sub-views

private struct SheetHeaderBar: View {
    var title: String
    var onClose: () -> Void = {}

    var body: some View {
        HStack {
            CircularIconButton(
                icon: .close,
                background: Color.graySecondaryText.opacity(0.15),
                action: onClose
            )

            Spacer()

            Text(title)
                .font(.title2Bold)
                .foregroundColor(.blackPrimaryText)

            Spacer()

            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

#Preview {
    Text("Background")
        .sheet(isPresented: .constant(true)) {
            LidarPreservedInstructionSheet()
                .presentationDetents([.fraction(0.85)])
                .presentationDragIndicator(.visible)
        }
}
