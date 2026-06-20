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
                    stops: [
                        .init(color: Color.brandPrimary, location: 0),
                        .init(color: Color.brandPrimary, location: 0.1),
                        .init(color: Color.brandTertiary, location: 0.6),
                    ],
                    startPoint: .bottom,
                    endPoint: .top
                )
                .edgesIgnoringSafeArea(.all)
                
                TabView(selection: $viewModel.currentPage) {
                    OnboardingPageView(
                        title: "Create Their Presence",
                        description: "Some memories never truly leave. Bring them close again through familiar sounds and shared moments.",
                        iconName: AppIcon.firstOnboardingImg.rawValue,
                        isLastPage: false,
                        onSkip: { viewModel.skip() },
                        onNext: { viewModel.next() }
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        title: "Begin Your First Moment",
                        description: "A photo or quick scan can help bring cherished memories back into your space. 3D generated and AR will be used to bring the presence of your pet.",
                        iconName: AppIcon.secondOnboardingImg.rawValue,
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
