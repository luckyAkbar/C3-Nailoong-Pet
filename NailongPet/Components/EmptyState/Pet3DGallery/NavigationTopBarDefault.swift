//
//  EmptyPetToolbars.swift
//  NailongPet
//
//  Created by Lucky Akbar on 06/06/26.
//

import SwiftUI

//previously EmptyPetToolbars
struct NavigationTopBarDefault: View {
    var title: String = "Memento Mori"
    
    var onBack: () -> Void = {}

    var body: some View {
        ZStack {
            HStack {
                Button(action: onBack) {
                    AppIcon.back.image
                        .font(.system(size: 16, weight: .bold))
                }
                .buttonStyle(.glass)

                Spacer()
            }

            Text(title)
                .font(.title2Bold)
                .foregroundColor(.blackPrimaryText)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
}

#Preview {
    NavigationTopBarDefault(title: "Memento Mori")
        .background(Color.beigeTertiaryBrand)
}
