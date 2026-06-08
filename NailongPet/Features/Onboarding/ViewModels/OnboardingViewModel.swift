import SwiftUI
import Combine

class OnboardingViewModel: ObservableObject {
    @Published var currentPage: Int = 0
    
    func skip() {
        // Handle skip logic, e.g., navigate to next flow or Home
        print("Onboarding Skipped")
    }
    
    func next() {
        if currentPage < 1 {
            withAnimation {
                currentPage += 1
            }
        } else {
            // Handle start logic, e.g., Permission request or Home
            print("Onboarding Finished, Start!")
        }
    }
}
