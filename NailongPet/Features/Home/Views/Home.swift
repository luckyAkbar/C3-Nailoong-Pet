//
//  Home.swift
//  NailongPet
//
//  Hub utama aplikasi. Menggantikan Pet3DGallery sebagai layar pet.
//  - Empty State: belum ada pet → ajakan membuat pet pertama.
//  - Filled State: ada pet → hero pet aktif + carousel + Interact.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject private var router: AppRouter
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        VStack(spacing: 0) {
            HomeTopBar(
                showMenu: !viewModel.isEmpty,
                onEdit: {
                    if let pet = viewModel.selectedPet {
                        router.navigate(to: .petDetail(pet))
                    }
                },
                onDelete: {
                    if let pet = viewModel.selectedPet {
                        viewModel.delete(pet)
                    }
                },
                onAdd: {
                    // TODO: wiring tombol "+" menyusul.
                }
            )

            if viewModel.isEmpty {
                HomeEmptyState(
                    onCreate: { router.navigate(to: .choose3DGeneratorTech) }
                )
            } else {
                HomeFilledState(
                    pets: viewModel.pets,
                    selected: viewModel.selectedPet,
                    onSelect: { viewModel.select($0) },
                    onInteract: { router.navigate(to: .arInteraction) }
                )
                .padding(.top, 16)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.surfaceCanvas.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .animation(.easeInOut(duration: 0.25), value: viewModel.isEmpty)
    }
}

#Preview("Filled") {
    Home()
        .environmentObject(AppRouter())
}

#Preview("Empty") {
    Home(viewModel: HomeViewModel(pets: []))
        .environmentObject(AppRouter())
}

#Preview("Filled - Dark") {
    Home()
        .environmentObject(AppRouter())
        .environment(\.colorScheme, .dark)
}

private extension Home {
    /// Init pembantu khusus preview agar bisa menyuntik view model.
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}
