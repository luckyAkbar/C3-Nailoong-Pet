import SwiftUI

struct InteractingOverlay: View {
    var action: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Move iPhone to start")
                .font(.system(size: 16))
                .foregroundColor(.white)
                .shadow(radius: 4)
            
            Button(action: action) {
                Text("Try to get close...")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.4))
                    .clipShape(Capsule())
            }
        }
    }
}

#Preview {
    ZStack {
        Color.gray
        InteractingOverlay(action: {})
    }
}
