import SwiftUI

// previously GuideButton
struct ButtonIconOverlayInteractionGuide: View {
    var action: () -> Void
    
    var body: some View {
        VStack{
            Button(action: action) {
                VStack(spacing: 2) {
                    ZStack {
                        Image(systemName: AppIcon.pawPrint)
                            .font(.title3Bold)
                        Text("?")
                            .font(.captionRegular)
                            .offset(x: 11, y: -11)
                    }
                }
                .foregroundColor(.black)
                .padding(8)
                .background(Color.whitePrimarySurface.opacity(0.9))
                .cornerRadius(8)
            }
            Text("Interaction Guide")
                .font(.captionRegular)
                .foregroundColor(.whitePrimarySurface)
        }
        
    }
}

#Preview {
    ZStack {
        Color.gray
        ButtonIconOverlayInteractionGuide(action: {})
    }
}
