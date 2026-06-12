//
//  MenuSelection.swift
//  NailongPet
//
//  Created by Lucky Akbar on 05/06/26.
//

import SwiftUI

//previously MenuSelection
struct CardMenuSelectionDefault: View {
    let icon: AppIcon
    let title: String
    let subtitle: String
    
    //variable for changing the photo mid application
    @Binding var selectedImage: Image?
    
    //add constructor for nil state of the image
    init(icon: AppIcon, title: String, subtitle: String, selectedImage: Binding<Image?> = .constant(nil)) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self._selectedImage = selectedImage
    }

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: CornerRadius.medium.value)
                    .stroke(Color.graySecondaryText.opacity(0.35), lineWidth: 1)

                // check if any image is selected or choose placeholder
                if let selectedImage {
                    selectedImage
                        .resizable()
                        .scaledToFill()
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium.value))
                } else {
                    AppIcon.imagePlaceholder.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .foregroundColor(Color.graySecondaryText.opacity(0.6))
                }
            }
            .frame(height: 220)

            HStack(spacing: 12) {
                icon.image
                    .font(.title1Bold)
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
        CardMenuSelectionDefault(
            icon: .bringTo3D,
            title: "Bring Pet to 3D",
            subtitle: "Preserve the moment with your pet"
        )
        CardMenuSelectionDefault(
            icon: .interact,
            title: "Interact",
            subtitle: "Feel the presence of your 3D companion"
        )
    }
    .padding()
}
