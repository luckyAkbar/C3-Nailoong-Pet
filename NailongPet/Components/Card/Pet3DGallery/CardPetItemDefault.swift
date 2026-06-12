//
//  PetProfile.swift
//  NailongPet
//
//  Created by Lucky Akbar on 06/06/26.
//

import SwiftUI

struct Pet3DProfile: Identifiable, Equatable, Hashable {
    let id: UUID
    let name: String
    let imageName: String

    init(id: UUID = UUID(), name: String, imageName: String) {
        self.id = id
        self.name = name
        self.imageName = imageName
    }
}

struct PetProfilePhoto: View {
    var pet: Pet3DProfile
    private let imageWhitePadding: CGFloat = 12
    
    var body: some View {
        ZStack {
            Color.orangePrimaryBrand

            Image(pet.imageName)
                .resizable()
                .scaledToFit()
                .padding(8)
        }
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small.value))
        .innerShadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 1)
        .aspectRatio(1, contentMode: .fit)
        .padding(imageWhitePadding)
        .frame(maxWidth: .infinity)
    }
}

//previously PetProfile
struct CardPetItemDefault: View {
    let pet: Pet3DProfile
    var onTap: () -> Void = {}

    private let cardPadding: CGFloat = 2

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                PetProfilePhoto(pet: pet)

                Text(pet.name)
                    .font(.title2Bold)
                    .foregroundColor(.blackPrimaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 8)
            }
            .padding(cardPadding)
            .background(Color.beigeTertiaryBrand)
            .compositingGroup()
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(pet.name)
    }
}

#Preview {
    CardPetItemDefault(
        pet: Pet3DProfile(name: "Moli", imageName: AppIcon.moli.rawValue)
    )
    .padding(24)
    .background(Color.beigeTertiaryBrand)
}

// MARK: - Inner Shadow

private struct InnerShadowModifier: ViewModifier {
    var color: Color
    var radius: CGFloat
    var x: CGFloat
    var y: CGFloat

    func body(content: Content) -> some View {
        content.overlay {
            GeometryReader { geometry in
                color
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .blur(radius: radius)
                    .offset(x: x, y: y)
            }
            .mask(content)
        }
    }
}

private extension View {
    func innerShadow(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) -> some View {
        modifier(InnerShadowModifier(color: color, radius: radius, x: x, y: y))
    }
}
