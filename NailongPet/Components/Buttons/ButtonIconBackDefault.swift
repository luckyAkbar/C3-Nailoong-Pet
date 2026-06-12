import SwiftUI

//previously CircleBackButton
struct ButtonIconBackDefault: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: AppIcon.chevronLeft)
                .font(.calloutBold)
                .foregroundColor(.black)
                .frame(width: 44, height: 44)
                .background(Color.white.opacity(0.8))
                .clipShape(Circle())
        }
    }
}

#Preview {
    ZStack {
        Color.gray
        ButtonIconBackDefault(action: {})
    }
}
