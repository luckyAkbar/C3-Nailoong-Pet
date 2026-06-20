import SwiftUI
import Combine

class ARInteractionViewModel: ObservableObject {
    @Published var showInstructionCard: Bool = true
    @Published var instructionCardTextContent: String = "Move your camera from right to left and find a surface to make your pet appears."
    @Published var isTooFar: Bool = false
    
    private var defaultInstructionCardTextContent: String = "Move your camera from right to left and find a surface to make your pet appears."
    private var defaultShowInstructionCard: Bool = true
    
    let pet: Pet3DProfile
    let speechRecognizer = SpeechRecognizer()
    let voiceTriggerEvent = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var hasShownPostRenderInstructions = false
    private let instructionDelay: TimeInterval = 5.0
    
    init(pet: Pet3DProfile) {
        self.pet = pet
        setupSpeechObservation()
    }
    
    private var lastProcessedTranscriptLength = 0
    
    private func setupSpeechObservation() {
        speechRecognizer.$transcript
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                
                if text.isEmpty {
                    self.lastProcessedTranscriptLength = 0
                    return
                }
                
                // If the transcript resets or gets shorter, reset our tracker
                if text.count < self.lastProcessedTranscriptLength {
                    self.lastProcessedTranscriptLength = 0
                }
                
                let newTextStartIndex = text.index(text.startIndex, offsetBy: self.lastProcessedTranscriptLength)
                let newText = String(text[newTextStartIndex...])
                
                // Cek apakah teks kata-kata TERBARU mengandung nama pet
                if newText.lowercased().contains(self.pet.name.lowercased()) {
                    print("ARInteractionViewModel: Pet name '\(self.pet.name)' detected!")
                    self.voiceTriggerEvent.send()
                    self.lastProcessedTranscriptLength = text.count
                }
            }
            .store(in: &cancellables)
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
