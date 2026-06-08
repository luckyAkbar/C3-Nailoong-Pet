import SwiftUI
import Combine

class OnboardingViewModel: ObservableObject {
    @Published var currentPage: Int = 0

    /// Closure yang dipanggil saat user selesai atau melewati onboarding.
    var onFinish: () -> Void

    init(onFinish: @escaping () -> Void = {}) {
        self.onFinish = onFinish
    }

    func skip() {
        onFinish()
    }

    func next() {
        if currentPage < 1 {
            withAnimation {
                currentPage += 1
            }
        } else {
            onFinish()
        }
    }
}
