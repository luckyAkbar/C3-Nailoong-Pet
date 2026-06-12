//
//  ProcessPage.swift
//  NailongPet
//
//  Created by carstenz meru phantara on 07/06/26.
//

import SwiftUI

struct ProcessPage: View {
    @EnvironmentObject private var router: AppRouter

    /// @State karena nilainya berubah di dalam view sendiri.
    /// Sebelumnya ini var biasa (parameter) sehingga tidak pernah berubah → stuck.
    @State private var progressPercentage: Float = 0

    var body: some View {
        ZStack {
            Color.blackSecondarySurface.opacity(0.8)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(AppIcon.moli.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 160)

                if progressPercentage < 100 {
                    // MARK: - Loading State
                    Text("Preserving 3D model of your pet....")
                        .foregroundStyle(Color.whitePrimarySurface)
                        .font(.title2Bold)
                        .multilineTextAlignment(.center)
                    Text("Please don’t close the app while it’s working")
                        .foregroundStyle(Color.graySecondaryText)
                        .font(.subheadRegular)

                    ProcessProgressBar(progress: Double(progressPercentage) / 100)
                        .padding(.horizontal, 40)
                        .padding(.top, 8)
                } else {
                    // MARK: - Complete State
                    Text("Pet Successfully Preserved!")
                        .foregroundStyle(Color.whitePrimarySurface)
                        .font(.title2Bold)
                    Text("Your pet has been successfully preserved and ready to interact with")
                        .foregroundStyle(Color.graySecondaryText)
                        .multilineTextAlignment(.center)
                    
                    
                    ButtonPrimaryDefault(
                        text: "Next",
                        action: { router.navigate(to: .processPetDetail) }
                    )
                }
            }
            .padding()
        }
        .toolbar(.hidden, for: .navigationBar)
        // .task otomatis dibatalkan saat view hilang dari layar (lifecycle-safe)
        .task {
            // Simulasi progress — nanti diganti dengan progress ML model yang sebenarnya
            while progressPercentage < 100 {
                try? await Task.sleep(for: .milliseconds(50))
                withAnimation(.linear(duration: 0.05)) {
                    progressPercentage = min(progressPercentage + 2, 100)
                }
            }
        }
    }
}

// MARK: - Feedback/ProgressBar (Track + Fill) sesuai design spec
private struct ProcessProgressBar: View {
    var progress: Double

    var body: some View {
        VStack(spacing: 4) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.whitePrimarySurface.opacity(0.3))
                        .frame(height: 6)
                    Capsule()
                        .fill(Color.orangePrimaryBrand)
                        .frame(width: geometry.size.width * max(0, min(progress, 1)), height: 6)
                }
            }
            .frame(height: 6)

            Text("\(Int(progress * 100))%")
                .font(.footnoteRegular)
                .foregroundStyle(Color.whitePrimarySurface)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

#Preview("Loading") {
    ProcessPage()
        .environmentObject(AppRouter())
}

#Preview("Complete") {
    // Paksa state complete untuk preview statis
    ProcessPage()
        .environmentObject(AppRouter())
        .onAppear { }
}
