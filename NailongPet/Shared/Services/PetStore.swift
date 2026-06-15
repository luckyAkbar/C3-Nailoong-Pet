import Foundation
import Combine

@MainActor
final class PetStore: ObservableObject {

    @Published private(set) var pets: [Pet3DProfile] = []

    private let defaults: UserDefaults
    private let storageKey = "savedPets"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        load()
    }

    @discardableResult
    func add(name: String, petDescription: String, modelFileName: String) -> Pet3DProfile {
        let pet = Pet3DProfile(
            name: name,
            petDescription: petDescription,
            modelFileName: modelFileName
        )
        pets.insert(pet, at: 0)
        save()
        return pet
    }

    func delete(_ pet: Pet3DProfile) {
        pets.removeAll { $0.id == pet.id }
        if let fileName = pet.modelFileName {
            ScannedModelLibrary.delete(fileName: fileName)
        }
        save()
    }

    private func load() {
        if let data = defaults.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([Pet3DProfile].self, from: data) {
            pets = decoded.sorted { $0.createdAt > $1.createdAt }
        } else {
            pets = HomeViewModel.samplePets
            save()
        }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(pets) else { return }
        defaults.set(data, forKey: storageKey)
    }

    static func preview(_ pets: [Pet3DProfile]) -> PetStore {
        let store = PetStore(defaults: UserDefaults(suiteName: "preview.PetStore")!)
        store.pets = pets
        return store
    }
}
