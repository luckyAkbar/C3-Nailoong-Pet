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
