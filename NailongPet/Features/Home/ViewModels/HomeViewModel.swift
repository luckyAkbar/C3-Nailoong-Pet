//
//  HomeViewModel.swift
//  NailongPet
//

import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {

    @Published var selectedPetID: UUID?

    func select(_ pet: Pet3DProfile) {
        selectedPetID = pet.id
    }

    func selectedPet(from pets: [Pet3DProfile]) -> Pet3DProfile? {
        pets.first { $0.id == selectedPetID } ?? pets.first
    }

    static let samplePets: [Pet3DProfile] = [
        Pet3DProfile(
            name: "Buncit",
            imageName: AppIcon.moli.rawValue,
            petDescription: "Buncit was a cheerful orange cat who loved to nap in the sun, until he had to leave too soon after an accident."
        ),
        Pet3DProfile(name: "Moli", imageName: AppIcon.moli.rawValue),
        Pet3DProfile(name: "Oyen", imageName: AppIcon.moli.rawValue),
        Pet3DProfile(name: "Mochi", imageName: AppIcon.moli.rawValue)
    ]
}
