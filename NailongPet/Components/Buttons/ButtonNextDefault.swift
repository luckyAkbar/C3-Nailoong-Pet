import SwiftUI

//previously PillButton
struct ButtonPillDefault: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadBold)
                .foregroundColor(.black)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.8))
                .clipShape(Capsule())
        }
    }
}


#Preview {
    ZStack {
        Color.gray
        ButtonPillDefault(title: "Next", action: {})
    }
}
