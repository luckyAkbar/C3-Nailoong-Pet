//
//  ContentView.swift
//  NailongPet
//
//  Root view aplikasi.
//  - Jika onboarding belum selesai → tampilkan OnboardingScreen.
//  - Jika sudah → masuk ke NavigationStack dengan Home sebagai root.
//

import SwiftUI

struct ContentView: View {

    /// Disimpan di UserDefaults agar tetap tersimpan walau app ditutup.
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    /// Router dibuat di sini (root) lalu disebarkan ke seluruh view via environmentObject.
    @StateObject private var router = AppRouter()

    var body: some View {
        if hasCompletedOnboarding {
            NavigationStack(path: $router.path) {
                Home()
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .choose3DGeneratorTech:
                            Choose3DGeneratorTech()
                        case .mlSharp:
                            SharpImageSelectionView()
                        case .lidar:
                            LidarCaptureView()
                        case .processPage:
                            ProcessPage()
                        case .processPetDetail:
                            ProcessPetDetail()
                        case .pet3DGallery:
                            Pet3DGalleryScreen()
                        case .petDetail(let pet):
                            PetDetail(pet: pet)
                        case .arInteraction:
                            ARInteractionScreen()
                        }
                    }
            }
            .environmentObject(router)
        } else {
            OnboardingScreen(onFinish: {
                hasCompletedOnboarding = true
            })
        }
    }
}

#Preview {
    ContentView()
}
