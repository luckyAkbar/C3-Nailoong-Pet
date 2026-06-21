//
//  HomeTopBar.swift
//  NailongPet
//

import SwiftUI

struct HomeTopBar: View {
    /// Saat true, tombol "..." menampilkan menu Edit/Delete (ada pet aktif).
    var showMenu: Bool = false
    /// toogle to either show triple dots menu or not
    var showTripleDotsMenu: Bool = true
    var onEdit: () -> Void = {}
    var selectedPet: Pet3DProfile?
    var onDelete: () -> Void = {}
    var onAdd: () -> Void = {}
    
    @State private var showDeleteAlert = false

    var body: some View {
        HStack {
            if showTripleDotsMenu {
                if showMenu {
                    Menu {
                        Button(action: onEdit) {
                            Label("Edit", systemImage: AppIcon.edit.rawValue)
                        }
                        Button(action: {
                            showDeleteAlert.toggle()
                        }) {
                            Label("Delete", systemImage: AppIcon.delete.rawValue)
                        }
                    } label: {
                        CircleIconLabel(icon: .more)
                    }
                    .alert(isPresented: $showDeleteAlert) {
                        let petName = selectedPet?.name ?? "this pet"
                        return Alert(
                            title: Text("Are you sure you want to delete \(petName)"),
                            message: Text("This action is irreversible and you will lose \(petName)'s data forever"),
                            primaryButton: .default(
                                Text("Cancel"),
                                action: {
                                    showDeleteAlert = false
                                }
                            ),
                            secondaryButton: .destructive(
                                Text("Delete"),
                                action: onDelete
                            )
                        )
                    }
                } else {
                    CircleIconLabel(icon: .more)
                        .opacity(0.5)
                }
            }

            Spacer()

            Button(action: onAdd) {
                CircleIconLabel(icon: .add)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
}

/// Lingkaran ikon ala iOS (mengikuti pola CircularIconButton, pakai token baru).
private struct CircleIconLabel: View {
    var icon: AppIcon

    var body: some View {
        icon.image
            .font(.subheadBold)
            .foregroundColor(.textPrimary)
            .frame(width: 44, height: 44)
            .background(Color.surfacePrimary)
            .glassEffect()
            .clipShape(Circle())
    }
}

#Preview {
    VStack(spacing: 24) {
        HomeTopBar(showMenu: true)
        HomeTopBar(showMenu: false)
    }
    .background(Color.surfaceCanvas)
}
