import SwiftUI

struct PlacingOverlay: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Pick a Surface")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .shadow(radius: 4)
            
            Rectangle()
                .stroke(style: StrokeStyle(lineWidth: 4, dash: [10]))
                .foregroundColor(.green)
                .frame(width: 200, height: 150)
                .padding(.vertical, 20)
            
            Text("Move iPhone to start")
                .font(.system(size: 16))
                .foregroundColor(.white)
                .shadow(radius: 4)
        }
    }
}

#Preview {
    ZStack {
        Color.gray
        PlacingOverlay()
    }
}
