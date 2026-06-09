import SwiftUI

struct InstructionGlassCard: View {
    var iconName: String
    var title: String
    var instruction: String
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.black)
                .padding(.top, 40)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.calloutBold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text(instruction)
                    .font(.subheadRegular)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 40)
        }
        .padding(.horizontal, 24)
        .frame(width: 280)
        .background(.ultraThinMaterial)
        .environment(\.colorScheme, .dark)
        .cornerRadius(24)
    }
}

#Preview {
    ZStack {
        Color.gray
        InstructionGlassCard(
            iconName: AppIcon.handRaised,
            title: "Try to pet your 3D\npet with your hand",
            instruction: "Move iPhone to start"
        )
    }
}
