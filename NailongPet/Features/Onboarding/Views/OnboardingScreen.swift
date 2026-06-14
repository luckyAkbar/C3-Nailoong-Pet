import SwiftUI

struct OnboardingScreen: View {
    @StateObject private var viewModel: OnboardingViewModel

    init(onFinish: @escaping () -> Void = {}) {
        _viewModel = StateObject(wrappedValue: OnboardingViewModel(onFinish: onFinish))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.beigeTertiaryBrand, Color.brownSecondaryBrand.opacity(0.8)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                TabView(selection: $viewModel.currentPage) {
                    OnboardingPageView(
                        title: "Create Their Presence",
                        description: "Some memories never truly leave. Bring them close again through familiar sounds and shared moments.",
                        iconName: AppIcon.pawPrint,
                        isLastPage: false,
                        onSkip: { viewModel.skip() },
                        onNext: { viewModel.next() }
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        title: "Begin Your First Moment",
                        description: "We use AR to recreate your pet in 3D. Camera and photo access help bring those memories to life. If your pet is nearby, a quick scan can create a more lifelike companion.",
                        iconName: "camera.fill",
                        isLastPage: true,
                        onSkip: { viewModel.skip() },
                        onNext: { viewModel.next() }
                    )
                    .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: viewModel.currentPage)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        // on skip action later here
                    }) {
                        Text("Skip")
                            .font(.body.weight(.semibold))
                            .foregroundColor(Color.textPrimary)
                    }
                }
            }
        }
    }
}

#Preview {
    OnboardingScreen()
}
