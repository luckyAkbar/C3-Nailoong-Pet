import SwiftUI

struct InteractionRowItem: View {
    var iconName: String
    var description: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.BrandColorSecondary.opacity(0.2))
                    .frame(width: 48, height: 48)
                
                Image(systemName: iconName)
                    .font(.system(size: 24))
                    .foregroundColor(Color.BrandColorSecondary)
            }
            
            Text(description)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}

#Preview {
    InteractionRowItem(
        iconName: AppIcon.handRaised,
        description: "Try to pet your 3D pet with your hand"
    )
    .padding()
}
