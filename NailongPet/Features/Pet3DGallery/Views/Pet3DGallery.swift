//
//  Pet3DGallery.swift
//  NailongPet
//
//  Created by Lucky Akbar on 06/06/26.
//

import SwiftUI

struct Pet3DGallery: View {
    let pets: [Pet3DProfile]
    @Binding var showOnboarding: Bool

    var onBack: () -> Void = {}
    var onAdd: () -> Void = {}
    var onAddNow: () -> Void = {}
    var onOnboardingStart: () -> Void = {}

    private var isEmpty: Bool { pets.isEmpty }

    private let gridColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if isEmpty {
                    EmptyPetToolbars(onBack: onBack)
                } else {
                    FilledStateToolbar(onBack: onBack, onAdd: onAdd)
                }

                if isEmpty {
                    Spacer()
                    Pet3DGalleryEmptyState(onAddNow: onAddNow)
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: gridColumns, spacing: 16) {
                            ForEach(pets) { pet in
                                PetProfile(pet: pet)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.beigeTertiaryBrand.ignoresSafeArea())

            if showOnboarding {
                Pet3DGalleryOnboardingShield {
                    showOnboarding = false
                    onOnboardingStart()
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showOnboarding)
    }
}

#Preview("Empty State") {
    Pet3DGallery(
        pets: [],
        showOnboarding: .constant(false)
    )
}

#Preview("Onboarding Shield") {
    Pet3DGallery(
        pets: [],
        showOnboarding: .constant(true)
    )
}

#Preview("Filled State") {
    Pet3DGallery(
        pets: [
            Pet3DProfile(name: "Moli", imageName: AppIcon.moli.rawValue),
            Pet3DProfile(name: "Moli", imageName: AppIcon.moli.rawValue),
            Pet3DProfile(name: "Moli", imageName: AppIcon.moli.rawValue)
        ],
        showOnboarding: .constant(false)
    )
}
