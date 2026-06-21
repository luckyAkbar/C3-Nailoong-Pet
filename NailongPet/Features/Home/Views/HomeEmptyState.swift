//
//  HomeEmptyState.swift
//  NailongPet
//

import SwiftUI

struct HomeEmptyState: View {
    var onCreate: () -> Void = {}

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            Text("Let’s Remember\nYour Pet Forever")
                .font(.title1Bold)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)

            Text("Let’s create your first pet")
                .font(.subheadRegular)
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.bottom, 25)

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
            
            PetSilhouetteView()
                .padding(.horizontal, 3)
                .allowsHitTesting(false)
            
            Spacer()
        }
    }
}

#Preview {
    HomeEmptyState()
}
