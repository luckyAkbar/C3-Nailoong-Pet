//
//  Choose3DGeneratorSheet.swift
//  NailongPet
//
//  Bottom sheet dengan native liquid glass style untuk memilih metode pembuatan 3D pet.
//  Menggunakan custom transition untuk memastikan background glass tetap transparan (bug NavigationStack dihindari).
//

import SwiftUI

enum SheetRoute: Hashable {
    case mlSharpInstruction
    case lidarInstruction
}

struct Choose3DGeneratorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appRouter: AppRouter
    
    @State private var currentRoute: SheetRoute? = nil

    var body: some View {
        ZStack {
            if currentRoute == nil {
                menuView
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
            } else if currentRoute == .mlSharpInstruction {
                SharpPhotoInstructionSheet(
                    onBack: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            currentRoute = nil
                        }
                    },
                    onStart: {
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            appRouter.navigate(to: .mlSharp)
                        }
                    }
                )
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
            } else if currentRoute == .lidarInstruction {
                LidarScanningInstructionSheet(
                    onBack: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            currentRoute = nil
                        }
                    },
                    onStart: {
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            appRouter.navigate(to: .lidar)
                        }
                    }
                )
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial, ignoresSafeAreaEdges: .all)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: currentRoute)
        .presentationBackground(.clear)
        .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.9)))
        .presentationDetents([.fraction(0.9)])
        .interactiveDismissDisabled(currentRoute != nil)
    }
    
    // MARK: - Menu View
    private var menuView: some View {
        VStack(spacing: 0) {
            // MARK: - Header Bar
            HStack {
                Color.clear.frame(width: 44, height: 44)

                Spacer()

                Text("Turn Your Pet into 3D")
                    .font(.title2Bold)
                    .foregroundColor(.textPrimary)

                Spacer()

                Button(action: { dismiss() }) {
                    AppIcon.close.image
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.textPrimary)
                }
                .buttonStyle(.glass)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            // MARK: - Menu Cards
            VStack(spacing: 16) {
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        currentRoute = .mlSharpInstruction
                    }
                }) {
                    TechMenuCard(
                        icon: .favoriteMoment,
                        title: "Pick a Favorite Moment",
                        subtitle: "If your pet isn't nearby, start with a photo."
                    )
                }
                .buttonStyle(.plain)

                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        currentRoute = .lidarInstruction
                    }
                }) {
                    TechMenuCard(
                        icon: .scanCompanion,
                        title: "Scan Your Companion",
                        subtitle: "A quick scan with a LiDAR-enabled device can help bring them even closer."
                    )
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.top, 28)

            Spacer()
        }
    }
}

// MARK: - Private Sub-views

private struct TechMenuCard: View {
    var icon: AppIcon
    var title: String
    var subtitle: String

    var body: some View {
        HStack(spacing: 16) {
            // Icon Container
            icon.image
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(.textPrimary)
                .frame(width: 52, height: 52)
                .glassEffect(in: RoundedRectangle(cornerRadius: CornerRadius.small.value))

            // Text Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadBold)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.leading)
                Text(subtitle)
                    .font(.footnoteRegular)
                    .foregroundColor(Color.textPrimary.opacity(0.7))
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
            }

            Spacer()

            // Trailing Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color.textPrimary.opacity(0.6))
        }
        .padding(16)
        .glassEffect(in: RoundedRectangle(cornerRadius: CornerRadius.medium.value))
    }
}

// MARK: - Preview

#Preview {
    @Previewable @StateObject var router = AppRouter()

    Text("Home Screen Background\nWith some content here to see blur effect.")
        .padding(.top, 120)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.orangePrimaryBrand)
        .sheet(isPresented: .constant(true)) {
            Choose3DGeneratorSheet()
                .presentationDragIndicator(.visible)
        }
        .environmentObject(router)
}
