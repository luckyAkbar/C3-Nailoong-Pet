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
                    .font(Font.title1Bold)
                    .foregroundColor(Color.textPrimary)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(Color.textSecondary)
                    .lineSpacing(4)
            }
            .padding(.leading, 40)
            
            Spacer()
            
            ZStack(alignment: .bottom) {
                // SVG image — adjust scaleEffect to control size
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(1.65) // ← Adjust this value to scale the SVG
                    .offset(y: 80)     // Offset to bottom so that the button overlaps it
                    .opacity(0.7)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .allowsHitTesting(false)
                
                // Button and page dots overlaid on top of the image
                VStack(spacing: 24) {
                    if isLastPage {
                        Button(action: onNext) {
                            Text("Start")
                                .font(.body)
                                .foregroundColor(.black)
                                .bold()
                                .frame(width: 320, height: 55)
                                .glassEffect()
                                .clipShape(Capsule())
                        }
                    } else {
                        Button(action: onNext) {
                            Text("Next")
                                .font(.body)
                                .foregroundColor(.black)
                                .bold()
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
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity)
            .clipped()
        }
    }
}

#Preview {
    ZStack {
        Color.brandPrimary
        OnboardingPageView(
            title: "Create Their Presence",
            description: "Some memories never truly leave.",
            iconName: AppIcon.firstOnboardingImg.rawValue,
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
            iconName: AppIcon.secondOnboardingImg.rawValue,
            isLastPage: true,
            onSkip: {},
            onNext: {}
        )
    }
}
