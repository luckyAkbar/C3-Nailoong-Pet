//
//  Home.swift
//  NailongPet
//
//  Created by Lucky Akbar on 05/06/26.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Nailong Pet")
                .font(Font.title1Bold)
                .foregroundColor(.blackPrimaryText)
                .multilineTextAlignment(.leading)
                .padding(.top, 25)

            Button(action: { router.navigate(to: .choose3DGeneratorTech) }) {
                CardMenuSelectionDefault(
                    icon: .bringTo3D,
                    title: "Bring Pet to 3D",
                    subtitle: "Preserve the moment with your pet"
                )
            }
            .buttonStyle(.plain)

            Button(action: { router.navigate(to: .pet3DGallery) }) {
                CardMenuSelectionDefault(
                    icon: .interact,
                    title: "Interact",
                    subtitle: "Feel the presence of your 3D companion"
                )
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.beigeTertiaryBrand.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    Home()
        .environmentObject(AppRouter())
}
