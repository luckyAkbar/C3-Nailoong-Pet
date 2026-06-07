import SwiftUI
import Combine

enum ARInteractionState: CaseIterable {
    case tutorialHand
    case tutorialTap
    case tutorialVoice
    case placing
    case interacting
}

class ARInteractionViewModel: ObservableObject {
    @Published var currentState: ARInteractionState = .tutorialHand
    @Published var showInteractionPopup: Bool = false
    
    func nextState() {
        withAnimation {
            switch currentState {
            case .tutorialHand:
                currentState = .tutorialTap
            case .tutorialTap:
                currentState = .tutorialVoice
            case .tutorialVoice:
                currentState = .placing
            case .placing:
                currentState = .interacting
            case .interacting:
                break
            }
        }
    }
    
    func togglePopup() {
        showInteractionPopup.toggle()
    }
}
