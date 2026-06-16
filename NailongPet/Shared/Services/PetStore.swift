import Foundation
import Combine
import SwiftData

@MainActor
final class PetStore: ObservableObject {

    init() {}

    @discardableResult
    func add(name: String, petDescription: String, modelFileName: String, context: ModelContext) -> Pet3DProfile {
        let pet = Pet3DProfile(
            name: name,
            petDescription: petDescription,
            modelFileName: modelFileName
        )
        context.insert(pet)
        try? context.save()
        return pet
    }

    func delete(_ pet: Pet3DProfile, context: ModelContext) {
        if let fileName = pet.modelFileName {
            ScannedModelLibrary.delete(fileName: fileName)
        }
        context.delete(pet)
        try? context.save()
    }

    static func preview() -> PetStore {
        return PetStore()
    }
}
