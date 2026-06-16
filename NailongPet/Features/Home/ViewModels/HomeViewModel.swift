//
//  HomeViewModel.swift
//  NailongPet
//

import SwiftUI
import Combine
import SwiftData

@MainActor
final class HomeViewModel: ObservableObject {

    @Published var selectedPetID: UUID?

    func select(_ pet: Pet3DProfile) {
        selectedPetID = pet.id
    }

    func selectedPet(from pets: [Pet3DProfile]) -> Pet3DProfile? {
        pets.first { $0.id == selectedPetID } ?? pets.first
    }

    static let loadSamplePet: Bool = false

    static let samplePets: [Pet3DProfile] = [
        // MARK: - Uncomment this to enable the sample pet for Buncit
        Pet3DProfile(
             name: "Buncit",
             imageName: AppIcon.moli.rawValue,
             petDescription: "Buncit was a cheerful orange cat who loved to nap in the sun, until he had to leave too soon after an accident.",
             modelFileName: "buncit.usdz"
        )
    ]
    
    @MainActor
    static func loadSampleIfNeeded(context: SwiftData.ModelContext) {
        guard loadSamplePet else { return }
        
        let descriptor = SwiftData.FetchDescriptor<Pet3DProfile>()
        let existingPets = (try? context.fetch(descriptor)) ?? []
        
        for sample in samplePets {
            if !existingPets.contains(where: { $0.name == sample.name }) {
                context.insert(sample)
            }
        }
        
        try? context.save()
    }
}
