import SwiftUI

struct GuideButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                HStack(alignment: .top, spacing: 0) {
                    Image(systemName: AppIcon.pawPrint)
                        .font(.system(size: 18))
                    Text("?")
                        .font(.system(size: 10, weight: .bold))
                        .offset(x: 2, y: -4)
                }
                Text("Interaction Guide")
                    .font(.system(size: 8, weight: .semibold))
            }
            .foregroundColor(.black)
            .padding(8)
            .background(Color.white.opacity(0.9))
            .cornerRadius(8)
        }
    }
}

#Preview {
    ZStack {
        Color.gray
        GuideButton(action: {})
    }
}
