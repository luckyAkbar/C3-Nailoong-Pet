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

    @State private var showDeleteAlert = false

    private var selected: Pet3DProfile? { viewModel.selectedPet(from: pets) }

    var body: some View {
        VStack(alignment: .center) {
            if pets.isEmpty {
                HomeEmptyState(
                    onCreate: {
                        router.showChoose3DSheet = true }
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // MARK: - Leading: triple-dots menu (only when pets exist)
            ToolbarItem(placement: .topBarLeading) {
                if !pets.isEmpty {
                    Menu {
                        Button {
                            if let selected {
                                router.navigate(to: .petDetail(selected))
                            }
                        } label: {
                            Label("Edit", systemImage: AppIcon.edit.rawValue)
                        }

                        Button {
                            showDeleteAlert = true
                        } label: {
                            Label("Delete", systemImage: AppIcon.delete.rawValue)
                        }
                    } label: {
                        toolbarCircleIcon(.more)
                    }
                }
            }

            // MARK: - Trailing: add button
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    router.showChoose3DSheet = true
                } label: {
                    toolbarCircleIcon(.add)
                }
            }
        }
        .alert(
            "Are you sure you want to delete \(selected?.name ?? "this pet")",
            isPresented: $showDeleteAlert
        ) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                if let selected {
                    petStore.delete(selected, context: modelContext)
                }
            }
        } message: {
            Text("This action is irreversible and you will lose \(selected?.name ?? "this pet")'s data forever")
        }
        .animation(.easeInOut(duration: 0.25), value: pets.isEmpty)
        .onAppear {
            HomeViewModel.loadSampleIfNeeded(context: modelContext)
        }
    }

    // MARK: - Toolbar icon helper (matches CircleIconLabel from HomeTopBar)
    @ViewBuilder
    private func toolbarCircleIcon(_ icon: AppIcon) -> some View {
        icon.image
            .font(.subheadBold)
            .foregroundColor(.textPrimary)
            .frame(width: 44, height: 44)
            .background(Color.surfacePrimary)
            .glassEffect()
            .clipShape(Circle())
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
