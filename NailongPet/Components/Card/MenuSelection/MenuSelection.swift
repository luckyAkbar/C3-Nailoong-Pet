//
//  MenuSelection.swift
//  NailongPet
//
//  Created by Lucky Akbar on 05/06/26.
//

import SwiftUI

struct MenuSelection: View {
    let icon: AppIcon
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: CornerRadius.medium.value)
                    .stroke(Color.graySecondaryText.opacity(0.35), lineWidth: 1)

                AppIcon.imagePlaceholder.image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .foregroundColor(Color.graySecondaryText.opacity(0.6))
            }
            .frame(height: 220)

            HStack(spacing: 12) {
                icon.image
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color.blackPrimaryText)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.title2Bold)
                        .foregroundColor(Color.blackPrimaryText)
                    Text(subtitle)
                        .font(.subheadRegular)
                        .foregroundColor(Color.blackPrimaryText)
                }

                Spacer()
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 4)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.medium.value)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.beigeTertiaryBrand.opacity(0.4),
                            Color.orangePrimaryBrand
                        ],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium.value)
                .stroke(Color.graySecondaryText.opacity(0.35), lineWidth: 1)
        )
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack(spacing: 20) {
        MenuSelection(
            icon: .bringTo3D,
            title: "Bring Pet to 3D",
            subtitle: "Preserve the moment with your pet"
        )
        MenuSelection(
            icon: .interact,
            title: "Interact",
            subtitle: "Feel the presence of your 3D companion"
        )
    }
    .padding()
}
