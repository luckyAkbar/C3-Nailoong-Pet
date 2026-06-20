//
//  HomeEmptyState.swift
//  NailongPet
//

import SwiftUI

struct HomeEmptyState: View {
    var onCreate: () -> Void = {}

    var body: some View {
        ZStack(alignment: .bottom) {
            // Siluet dekoratif besar di bawah, di belakang konten.
            PetSilhouetteView()
                .frame(maxWidth: 561)
                .frame(height: 450)
                .padding(.horizontal, 3)

            VStack(spacing: 20) {
                VStack(spacing: 10) {
                    Text("Your beloved pet,\nforever live in here.")
                        .font(.title1Bold)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)

                    Text("Every shared moment becomes a memory. Create a companion and interact with them whenever you want to feel close again.")
                        .font(.subheadRegular)
                        .foregroundColor(.textTertiary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)

                Button(action: onCreate) {
                    Text("Bring Pet to 3D")
                        .font(.subheadRegular)
                        .foregroundColor(Color.white)
                        .padding(.horizontal)
                        .frame(maxWidth:155, minHeight: 59)
                        .clipShape(Capsule())
                        .glassEffect(.regular.tint(Color.brandSecondary).interactive(), in: Capsule())
                }

                Spacer()
            }
            .padding(.top, 48)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    HomeEmptyState()
}
