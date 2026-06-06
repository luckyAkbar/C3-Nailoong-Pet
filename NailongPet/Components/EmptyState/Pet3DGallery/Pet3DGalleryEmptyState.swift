//
//  Pet3DGalleryEmptyState.swift
//  NailongPet
//
//  Created by Lucky Akbar on 06/06/26.
//

import SwiftUI

struct Pet3DGalleryEmptyState: View {
    var onAddNow: () -> Void = {}

    var body: some View {
        VStack(spacing: 24) {
            Pet3DPawPrintCluster()
                .frame(height: 80)

            VStack(spacing: 8) {
                Text("There is no pet yet to interact.")
                    .font(.title2Bold)
                    .foregroundColor(.blackPrimaryText)
                    .multilineTextAlignment(.center)

                Text("Create your first companion from a photo or scan of your pet.")
                    .font(.subheadRegular)
                    .foregroundColor(.graySecondaryText)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)

            Button(action: onAddNow) {
                Text("Add Now")
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
        }
    }
}

struct Pet3DPawPrintCluster: View {
    var color: Color = .blackPrimaryText

    var body: some View {
        ZStack {
            AppIcon.pawLoading.image
                .font(.system(size: 48, weight: .bold))
                .offset(x: -22, y: -35)
                .rotationEffect(.degrees(-15))
                

            AppIcon.pawLoading.image
                .font(.system(size: 34, weight: .bold))
                .offset(x: 28, y: -8)
                .rotationEffect(.degrees(12))

            AppIcon.pawLoading.image
                .font(.system(size: 34, weight: .bold))
                .offset(x: -22, y: 35)
                .rotationEffect(.degrees(-12))
        }
        .foregroundColor(color)
        .accessibilityHidden(true)
    }
}

#Preview {
    Pet3DGalleryEmptyState()
        .padding()
        .background(Color.beigeTertiaryBrand)
}
