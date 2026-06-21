import SwiftUI
import Combine

class ARInteractionViewModel: ObservableObject {
    @Published var showInstructionCard: Bool = true
    @Published var instructionCardTextContent: String = "Move your camera from right to left and find a surface to make your pet appears."
    @Published var isTooFar: Bool = false
    
    private var defaultInstructionCardTextContent: String = "Move your camera from right to left and find a surface to make your pet appears."
    private var defaultShowInstructionCard: Bool = true
    
    @AppStorage("lastPettingActionTime") private var lastPettingActionTime: Double = 0
    @AppStorage("lastVoiceActionTime") private var lastVoiceActionTime: Double = 0
    private let cooldownInterval: TimeInterval = 3 * 24 * 60 * 60
    
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
        
        DispatchQueue.main.async {
            self.evaluateOnboardingState()
        }
    }
    
    func didPerformPettingAction() {
        lastPettingActionTime = Date().timeIntervalSince1970
        DispatchQueue.main.async {
            self.evaluateOnboardingState()
        }
    }
    
    func didPerformVoiceAction() {
        lastVoiceActionTime = Date().timeIntervalSince1970
        DispatchQueue.main.async {
            self.evaluateOnboardingState()
        }
    }
    
    private func evaluateOnboardingState() {
        let now = Date().timeIntervalSince1970
        
        // Logika antrian
        if (now - lastPettingActionTime) >= cooldownInterval {
            setInstruction(show: true, text: "Try to pet your 3D pet directly")
        } else if (now - lastVoiceActionTime) >= cooldownInterval {
            setInstruction(show: true, text: "Try to call your 3D pet and see it reaction")
        } else {
            setInstruction(show: false, text: "")
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
            // Restore state safely on main thread
            DispatchQueue.main.async {
                self.showInstructionCard = self.defaultShowInstructionCard
                self.instructionCardTextContent = self.defaultInstructionCardTextContent
            }
        }
    }
}
