import SwiftUI

struct ARInteractionScreen: View {
    @StateObject private var viewModel = ARInteractionViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
                ARViewContainer()
                    .edgesIgnoringSafeArea(.all)
                
                Spacer()
                
                VStack {
                    switch viewModel.currentState {
                    case .tutorialHand:
                        InstructionGlassCard(
                            instruction: "Move iPhone to start"
                        ).padding(.top, 50)
                    case .tutorialTap:
                        InstructionGlassCard(
                            instruction: "Move iPhone to start"
                        )
                    case .tutorialVoice:
                        InstructionGlassCard(        instruction: "Move iPhone to start"
                        )
                    case .placing:
                        PlacingOverlay()
                    case .interacting:
                        InteractingOverlay {
                        }
                    }
                    
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.body.weight(.semibold))
                            .foregroundColor(Color.textPrimary)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ARInteractionScreen()
}
