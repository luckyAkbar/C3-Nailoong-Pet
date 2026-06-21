//
//  Home.swift
//  NailongPet
//
//  Hub utama aplikasi. Menggantikan Pet3DGallery sebagai layar pet.
//  - Empty State: belum ada pet → ajakan membuat pet pertama.
//  - Filled State: ada pet → hero pet aktif + carousel + Interact.
//

import SwiftUI
import SwiftData

struct Home: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var petStore: PetStore
    @StateObject private var viewModel = HomeViewModel()

    @Query(sort: \Pet3DProfile.createdAt, order: .reverse) private var pets: [Pet3DProfile]

    private var selected: Pet3DProfile? { viewModel.selectedPet(from: pets) }

    var body: some View {
        VStack(spacing: 0) {
            HomeTopBar(
                showMenu: !pets.isEmpty,
                showTripleDotsMenu: !pets.isEmpty,
                onEdit: {
                    if let selected {
                        router.navigate(to: .petDetail(selected))
                    }
                },
                selectedPet: selected,
                onDelete: {
                    if let selected {
                        petStore.delete(selected, context: modelContext)
                    }
                },
                onAdd: {
                    router.showChoose3DSheet = true
                }
            )

            if pets.isEmpty {
                HomeEmptyState(
                    onCreate: { router.showChoose3DSheet = true }
                )
            } else {
                HomeFilledState(
                    pets: pets,
                    selected: selected,
                    onSelect: { viewModel.select($0) },
                    onInteract: { 
                        if let pet = selected {
                            router.navigate(to: .arInteraction(pet))
                        }
                    }
                )
                .padding(.top, 16)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.surfaceCanvas.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .animation(.easeInOut(duration: 0.25), value: pets.isEmpty)
        .onAppear {
            HomeViewModel.loadSampleIfNeeded(context: modelContext)
        }
    }
}

#Preview("Filled") {
    Home()
        .environmentObject(AppRouter())
        .environmentObject(PetStore.preview())
}

#Preview("Empty") {
    Home()
        .environmentObject(AppRouter())
        .environmentObject(PetStore.preview())
}

#Preview("Filled - Dark") {
    Home()
        .environmentObject(AppRouter())
        .environmentObject(PetStore.preview())
        .environment(\.colorScheme, .dark)
}
