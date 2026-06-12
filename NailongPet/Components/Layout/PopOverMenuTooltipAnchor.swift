import SwiftUI

//previously InteractionPopup
struct PopOverMenuTooltipAnchor: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Interaction List")
                .font(.calloutBold)
                .foregroundColor(.black)
                .padding(.bottom, 8)
            
            VStack(spacing: 16) {
                ListItemRowInteractionStyle(
                    iconName: AppIcon.handRaised,
                    description: "Try to pet your 3D pet with\nyour hand"
                )
                ListItemRowInteractionStyle(
                    iconName: AppIcon.handTap,
                    description: "Try to pet your pet trough\nyour phone"
                )
                ListItemRowInteractionStyle(
                    iconName: AppIcon.personWave,
                    description: "Try to call your pet to see it\nreaction"
                )
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        .frame(width: 300)
    }
}

#Preview {
    ZStack {
        Color.gray
        PopOverMenuTooltipAnchor()
    }
}
