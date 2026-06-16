//
//  AppRouter.swift
//  NailongPet
//
//  Mengontrol NavigationPath secara terpusat — Single Source of Truth untuk navigasi.
//  Dibagikan ke seluruh view melalui .environmentObject(router).
//

import SwiftUI
import Combine

@MainActor
final class AppRouter: ObservableObject {

    /// Stack navigasi aktif. NavigationStack membaca ini secara real-time.
    @Published var path = NavigationPath()
    
    /// Status untuk menampilkan modal Choose3DGeneratorSheet
    @Published var showChoose3DSheet = false

    /// Navigasi maju ke layar tertentu (push).
    func navigate(to route: AppRoute) {
        path.append(route)
    }

    /// Kembali satu langkah ke layar sebelumnya (pop).
    func navigateBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    /// Kembali ke layar paling awal (pop to root / Home).
    func navigateToRoot() {
        path = NavigationPath()
    }
}
