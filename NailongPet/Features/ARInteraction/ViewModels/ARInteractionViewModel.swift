import SwiftUI
import Combine

class ARInteractionViewModel: ObservableObject {
    @Published var showInstructionCard: Bool = true
    @Published var instructionCardTextContent: String = "Pan the iPhone camera from left to right to start"
    @Published var isTooFar: Bool = false
    
    private var defaultInstructionCardTextContent: String = "Pan the iPhone camera from left to right to start"
    private var defaultShowInstructionCard: Bool = true
    
    let pet: Pet3DProfile
    private var hasShownPostRenderInstructions = false
    private let instructionDelay: TimeInterval = 5.0
    
    init(pet: Pet3DProfile) {
        self.pet = pet
    }
    
    func onModelRendered() {
        guard !hasShownPostRenderInstructions else { return }
        hasShownPostRenderInstructions = true
        
        // Hide the initial 'pan camera' instruction when model is rendered
        DispatchQueue.main.async {
            self.setInstruction(show: false, text: self.instructionCardTextContent)
        }
        
        // Delay before showing the petting instruction
        DispatchQueue.main.asyncAfter(deadline: .now() + instructionDelay) {
            self.setInstruction(show: true, text: "Gently pet your 3D friend to see their reaction!")
            
            // Hide and delay before showing the calling instruction
            DispatchQueue.main.asyncAfter(deadline: .now() + self.instructionDelay) {
                self.setInstruction(show: false, text: "Gently pet your 3D friend to see their reaction!")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + self.instructionDelay) {
                    self.setInstruction(show: true, text: "Call out your pet's name to catch their attention!")
                    
                    // Hide the calling instruction after the delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.instructionDelay) {
                        self.setInstruction(show: false, text: "Call out your pet's name to catch their attention!")
                    }
                }
            }
        }
    }
    
    private func setInstruction(show: Bool, text: String) {
        defaultShowInstructionCard = show
        defaultInstructionCardTextContent = text
        
        if !isTooFar {
            self.showInstructionCard = show
            self.instructionCardTextContent = text
        }
    }
    
    func updateDistanceStatus(isTooFar: Bool) {
        self.isTooFar = isTooFar
        if isTooFar {
            self.showInstructionCard = true
            self.instructionCardTextContent = "⚠️ You are too far from the pet! Please come closer."
        } else {
            self.showInstructionCard = defaultShowInstructionCard
            self.instructionCardTextContent = defaultInstructionCardTextContent
        }
    }
}
