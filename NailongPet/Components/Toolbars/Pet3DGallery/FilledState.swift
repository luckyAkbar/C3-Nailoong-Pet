//
//  FilledState.swift
//  NailongPet
//
//  Created by Lucky Akbar on 06/06/26.
//

import SwiftUI

struct FilledStateToolbar: View {
    var onBack: () -> Void = {}
    var onAdd: () -> Void = {}

    var body: some View {
        ZStack {
            HStack {
                Button(action: onBack) {
                    AppIcon.back.image
                        .font(.system(size: 16, weight: .bold))
                }
                .buttonStyle(.glass)

                Spacer()

                Button(action: onAdd) {
                    Text("Add")
                        .font(.subheadRegular)
                        .foregroundColor(.blackPrimaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.whitePrimarySurface)
                        .cornerRadius(CornerRadius.full.value)
                        .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
                }
            }

            Text("Your Pets")
                .font(.title2Bold)
                .foregroundColor(.blackPrimaryText)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
}

#Preview {
    FilledStateToolbar()
        .background(Color.beigeTertiaryBrand)
}
