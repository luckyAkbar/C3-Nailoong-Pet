//
//  HomeViewModel.swift
//  NailongPet
//

import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {

    // TODO: Ganti dengan SwiftData @Query saat persistence sudah siap.
    @Published var pets: [Pet3DProfile]
    @Published var selectedPetID: UUID?

    init(pets: [Pet3DProfile] = HomeViewModel.samplePets) {
        self.pets = pets
        self.selectedPetID = pets.first?.id
    }

    var isEmpty: Bool { pets.isEmpty }

    var selectedPet: Pet3DProfile? {
        pets.first { $0.id == selectedPetID } ?? pets.first
    }

    func select(_ pet: Pet3DProfile) {
        selectedPetID = pet.id
    }

    func delete(_ pet: Pet3DProfile) {
        pets.removeAll { $0.id == pet.id }
        if selectedPetID == pet.id {
            selectedPetID = pets.first?.id
        }
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
