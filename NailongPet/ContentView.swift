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
    @StateObject private var captureManager = LidarCaptureManager()
    @StateObject private var petStore = PetStore()
    @StateObject private var sharpViewModel = SHARPViewModel()

    var body: some View {
        if hasCompletedOnboarding {
                    NavigationStack(path: $router.path) {
                        Home()
                            .navigationDestination(for: AppRoute.self) { route in
                                switch route {
                                case .choose3DGeneratorTech:
                                    EmptyView()
                                case .mlSharp:
                                    SharpImageSelectionView()
                                case .lidar:
                                    LidarCaptureView()
                                case .processPage(let generator):
                                    ProcessPage(generatorType: generator)
                                case .processPetDetail(let generator):
                                    ProcessPetDetail(generatorType: generator)
                                case .pet3DGallery:
                                    Pet3DGalleryScreen()
                                case .petDetail(let pet):
                                    PetDetail(pet: pet)
                                case .arInteraction(let pet):
                                    ARInteractionScreen(pet: pet)
                                }
                            }
                    .sheet(isPresented: $router.showChoose3DSheet) {
                        Choose3DGeneratorSheet()
                    }
            }
            .environmentObject(router)
            .environmentObject(captureManager)
            .environmentObject(petStore)
            .environmentObject(sharpViewModel)
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
