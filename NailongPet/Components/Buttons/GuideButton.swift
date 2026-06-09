import SwiftUI

struct GuideButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                HStack(alignment: .top, spacing: 0) {
                    Image(systemName: AppIcon.pawPrint)
                        .font(.title3Bold)
                    Text("?")
                        .font(.captionRegular)
                        .offset(x: 2, y: -4)
                }
                Text("Interaction Guide")
                    .font(.captionRegular)
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
