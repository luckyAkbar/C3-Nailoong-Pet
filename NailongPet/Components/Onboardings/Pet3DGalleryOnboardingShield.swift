//
//  Pet3DGalleryOnboardingShield.swift
//  NailongPet
//
//  Created by Lucky Akbar on 06/06/26.
//

import SwiftUI

struct Pet3DGalleryOnboardingShield: View {
    var onStart: () -> Void = {}

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()

            Color.blackSecondarySurface.opacity(0.45)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                ZStack {
                    Pet3DPawPrintCluster(color: .blackPrimaryText)
                        .scaleEffect(1.2)
                        .offset(x: -8, y: -12)

                    RoundedRectangle(cornerRadius: CornerRadius.medium.value)
                        .fill(Color.graySecondaryText.opacity(0.35))
                        .frame(width: 120, height: 120)
                }
                .frame(height: 140)

                VStack(spacing: 12) {
                    Text("Your beloved pet, forever live in here")
                        .font(.title2Bold)
                        .foregroundColor(.whitePrimarySurface)
                        .multilineTextAlignment(.center)

                    Text("Every shared moment becomes a memory. Create a companion and interact with them whenever you want to feel close again.")
                        .font(.subheadRegular)
                        .foregroundColor(.whitePrimarySurface.opacity(0.85))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 32)

                Button(action: onStart) {
                    Text("Start")
                        .font(.subheadRegular)
                        .foregroundColor(.whitePrimarySurface)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.orangePrimaryBrand)
                        .cornerRadius(CornerRadius.full.value)
                        .shadow(color: Color.orangePrimaryBrand.opacity(0.35), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 40)
                .padding(.top, 8)

                Spacer()
            }
        }
        .accessibilityAddTraits(.isModal)
    }
}

#Preview {
    ZStack {
        Color.beigeTertiaryBrand.ignoresSafeArea()
        Pet3DGalleryEmptyState()
        Pet3DGalleryOnboardingShield()
    }
}
