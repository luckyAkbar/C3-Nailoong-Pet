import SwiftUI

struct InstructionGlassCard: View {
    var instruction: String
    
    var body: some View {
        VStack(spacing: 24) {
            Text(instruction)
                .font(.body)
        }
        .padding(.horizontal, 24)
        .frame(minWidth: 100, minHeight: 50)
        .glassEffect()
        .environment(\.colorScheme, .dark)
        .cornerRadius(24)
    }
}

#Preview {
    ZStack {
        Color.gray
        InstructionGlassCard(
            instruction: "Move iPhone to start"
        )
    }
}
