import SwiftUI

struct OnboardingPageView: View {
    var title: String
    var description: String
    var iconName: String
    var isLastPage: Bool
    var onSkip: () -> Void
    var onNext: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.black.opacity(0.8))
                    .lineSpacing(4)
            }
            .padding(.leading, 40)
            
            Spacer()
            
            VStack(spacing: 52) {
                VStack {
                    Image(iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180)
                        .foregroundColor(.black)
                }
                .padding(.bottom, 30)
                
                if isLastPage {
                    Button(action: onNext) {
                        Text("Start")
                            .font(.body)
                            .foregroundColor(.textPrimary)
                            .frame(width: 320, height: 55)
                            .glassEffect()
                            .clipShape(Capsule())
                    }
                } else {
                    Button(action: onNext) {
                        Text("Next")
                            .font(.body)
                            .foregroundColor(.textPrimary)
                            .frame(width: 320, height: 55)
                            .glassEffect()
                            .clipShape(Capsule())
                    }
                }
                
                HStack {
                    Circle()
                        .fill(isLastPage ? Color.black.opacity(0.3) : Color.black)
                        .frame(width: 6, height: 6)
                    Circle()
                        .fill(isLastPage ? Color.black : Color.black.opacity(0.3))
                        .frame(width: 6, height: 6)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ZStack {
        Color.brandPrimary
        OnboardingPageView(
            title: "Create Their Presence",
            description: "Some memories never truly leave.",
            iconName: AppIcon.pawPrint,
            isLastPage: false,
            onSkip: {},
            onNext: {}
        )
    }
}

#Preview {
    ZStack {
        Color.brandPrimary
        OnboardingPageView(
            title: "Create Their Presence",
            description: "Some memories never truly leave.",
            iconName: AppIcon.pawPrint,
            isLastPage: true,
            onSkip: {},
            onNext: {}
        )
    }
}
