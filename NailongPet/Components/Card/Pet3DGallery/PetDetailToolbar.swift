//
//  PetDetailToolbar.swift
//  NailongPet
//
//  Created by Lucky Akbar on 07/06/26.
//

import SwiftUI

struct PetDetailToolbar: View {
    var onBack: () -> Void = {}
    var onEdit: () -> Void = {}

    var body: some View {
        ZStack {
            HStack {
                Button(action: onBack) {
                    AppIcon.back.image
                        .font(.system(size: 16, weight: .bold))
                }
                .buttonStyle(.glass)

                Spacer()
                
                Button(action: onEdit) {
                    Text("Edit")
                }
                .buttonStyle(.glass)
            }

            Text("Pet")
                .font(.title2Bold)
                .foregroundColor(.blackPrimaryText)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
}

#Preview {
    PetDetailToolbar()
        .background(Color.beigeTertiaryBrand)
}
