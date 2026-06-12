import SwiftUI

struct PlacingOverlay: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Pick a Surface")
                .font(.title3Bold)
                .foregroundColor(.white)
                .shadow(radius: 4)

            Rectangle()
                .stroke(style: StrokeStyle(lineWidth: 4, dash: [10]))
                .foregroundColor(.green)
                .frame(width: 200, height: 150)
                .padding(.vertical, 20)

            Text("Move iPhone to start")
                .font(.calloutRegular)
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
