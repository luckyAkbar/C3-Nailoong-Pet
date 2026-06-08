import SwiftUI

struct ARInteractionScreen: View {
    @StateObject private var viewModel = ARInteractionViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            ARViewContainer()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack(alignment: .top) {
                    CircleBackButton {
                        dismiss()
                    }
                    
                    Spacer()
                    
                    if viewModel.currentState == .interacting || viewModel.currentState == .placing {
                        GuideButton {
                            withAnimation {
                                viewModel.togglePopup()
                            }
                        }
                        .overlay(alignment: .topTrailing) {
                            if viewModel.showInteractionPopup {
                                InteractionPopup()
                                    .offset(x: -8, y: 60)
                            }
                        }
                    } else {
                        PillButton(title: "Next") {
                            withAnimation {
                                viewModel.nextState()
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                Spacer()
                
                switch viewModel.currentState {
                case .tutorialHand:
                    InstructionGlassCard(
                        iconName: AppIcon.handRaised,
                        title: "Try to pet your 3D\npet with your hand",
                        instruction: "Move iPhone to start"
                    )
                case .tutorialTap:
                    InstructionGlassCard(
                        iconName: AppIcon.handTap,
                        title: "Try to pet your pet\ntrough your phone",
                        instruction: "Move iPhone to start"
                    )
                case .tutorialVoice:
                    InstructionGlassCard(
                        iconName: AppIcon.personWave,
                        title: "Try to call your\npet's name to see\nits reaction",
                        instruction: "Move iPhone to start"
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
    }
}

#Preview {
    ARInteractionScreen()
}
