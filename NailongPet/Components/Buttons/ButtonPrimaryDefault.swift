//
//  BrandButton.swift
//  NailongPet
//
//  Created by carstenz meru phantara on 07/06/26.
//
import SwiftUI

//previously BrandButton
struct ButtonPrimaryDefault: View {
    var text: String = ""
    var action: () -> Void = {}

    var body: some View {
        Button(action: action){
            Text(text)
                .font(.subheadRegular)
                .foregroundColor(.whitePrimarySurface)
                .frame(maxWidth: .infinity)
                .frame(height: 35)
        }
        .buttonStyle(.glassProminent)
        .tint(Color.orangePrimaryBrand)
        .padding(.horizontal, 40)
        .padding(.bottom, 34)
    }
}

#Preview {
    ButtonPrimaryDefault(text: "Login")
}
