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
            HStack {
                Spacer()
                ButtonPillDefault(title: "Skip", action: onSkip)
            }
            .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(.title1Bold)
                    .foregroundColor(.black)

                Text(description)
                    .font(.subheadRegular)
                    .foregroundColor(.black.opacity(0.8))
                    .lineSpacing(4)
            }
            .padding(.top, 40)
            
            Spacer()
            
            HStack {
                Spacer()
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 140)
                    .foregroundColor(.black)
                Spacer()
            }
            
            Spacer()
            
            // Action Button & Dots
            HStack {
                // Page Indicator
                HStack(spacing: 8) {
                    Circle()
                        .fill(isLastPage ? Color.black.opacity(0.3) : Color.black)
                        .frame(width: 6, height: 6)
                    Circle()
                        .fill(isLastPage ? Color.black : Color.black.opacity(0.3))
                        .frame(width: 6, height: 6)
                }
                
                Spacer()
                
                if isLastPage {
                    Button(action: onNext) {
                        Text("Start")
                            .font(.subheadBold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 48)
                            .padding(.vertical, 14)
                            .background(Color.orangePrimaryBrand)
                            .clipShape(Capsule())
                    }
                } else {
                    Button(action: onNext) {
                        Text("Next")
                            .font(.subheadBold)
                            .foregroundColor(.black)
                            .padding(.horizontal, 48)
                            .padding(.vertical, 14)
                            .background(Color.brownSecondaryBrand.opacity(0.3))
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.bottom, 40)
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    ZStack {
        Color.beigeTertiaryBrand
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
