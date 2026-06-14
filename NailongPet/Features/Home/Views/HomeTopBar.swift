//
//  HomeTopBar.swift
//  NailongPet
//

import SwiftUI

struct HomeTopBar: View {
    /// Saat true, tombol "..." menampilkan menu Edit/Delete (ada pet aktif).
    var showMenu: Bool = false
    var onEdit: () -> Void = {}
    var onDelete: () -> Void = {}
    var onAdd: () -> Void = {}

    var body: some View {
        HStack {
            if showMenu {
                Menu {
                    Button(action: onEdit) {
                        Label("Edit", systemImage: AppIcon.edit.rawValue)
                    }
                    Button(role: .destructive, action: onDelete) {
                        Label("Delete", systemImage: AppIcon.delete.rawValue)
                    }
                } label: {
                    CircleIconLabel(icon: .more)
                }
            } else {
                CircleIconLabel(icon: .more)
                    .opacity(0.5)
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
