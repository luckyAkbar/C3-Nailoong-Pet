import SwiftUI

struct ARInteractionScreen: View {
    @StateObject private var viewModel: ARInteractionViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var isTooFarAway: Bool = true
    
    init(pet: Pet3DProfile) {
        _viewModel = StateObject(wrappedValue: ARInteractionViewModel(pet: pet))
    }
    
    var body: some View {
        ZStack {
                ARViewContainer(viewModel: viewModel)
                    .edgesIgnoringSafeArea(.all)
                
                Spacer()
            
            if viewModel.showInstructionCard {
                VStack {
                    InstructionGlassCard(
                        instruction: viewModel.instructionCardTextContent
                    ).padding(.top, 50)
                    Spacer()   
                }
            }
            
            VStack {
                Spacer()
                if viewModel.speechRecognizer.isListening {
                    HStack(spacing: 8) {
                        Image(systemName: "mic.fill")
                            .foregroundColor(.white)
//                        Text("Listening for \\",\\(viewModel.pet.name)\\"...")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.6))
                    .clipShape(Capsule())
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            viewModel.speechRecognizer.startTranscribing()
        }
        .onDisappear {
            viewModel.speechRecognizer.stopTranscribing()
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
    ARInteractionScreen(pet: Pet3DProfile(name: "Sample", imageName: "moli", modelFileName: "buncit.usdz"))
}
