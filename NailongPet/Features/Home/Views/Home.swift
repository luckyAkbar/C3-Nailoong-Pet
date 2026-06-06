//
//  Home.swift
//  NailongPet
//
//  Created by Lucky Akbar on 05/06/26.
//

import SwiftUI

struct Home: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Nailong Pet")
                .font(Font.title1Bold)
                .multilineTextAlignment(.leading)
                .padding(.top, 25)

            MenuSelection(
                icon: .bringTo3D,
                title: "Bring Pet to 3D",
                subtitle: "Preserve the moment with your pet"
            )

            MenuSelection(
                icon: .interact,
                title: "Interact",
                subtitle: "Feel the presence of your 3D companion"
            )

            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.beigeTertiaryBrand.ignoresSafeArea())
    }
}

#Preview {
    Home()
}
