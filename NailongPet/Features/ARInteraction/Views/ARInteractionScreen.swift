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
                    VStack(spacing: 4) {
                        HStack(spacing: 8) {
                            Image(systemName: "mic.fill")
                                .foregroundColor(.white)
                            Text("Listening for \"\(viewModel.pet.name)\"...")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        
                        if !viewModel.speechRecognizer.transcript.isEmpty {
                            Text(viewModel.speechRecognizer.transcript)
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(20)
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
