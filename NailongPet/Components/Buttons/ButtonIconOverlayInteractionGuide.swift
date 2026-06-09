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
                            .font(.system(size: 18))
                        Text("?")
                            .font(.system(size: 10, weight: .bold))
                            .offset(x: 11, y: -11)
                    }
                    
                }
                .foregroundColor(.black)
                .padding(8)
                .background(Color.whitePrimarySurface.opacity(0.9))
                .cornerRadius(8)
            }
            Text("Interaction Guide")
                .font(.system(size: 8, weight: .semibold))
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
