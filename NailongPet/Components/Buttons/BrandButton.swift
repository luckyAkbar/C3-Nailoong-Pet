//
//  BrandButton.swift
//  NailongPet
//
//  Created by carstenz meru phantara on 07/06/26.
//
import SwiftUI

struct BrandButton: View {
    var text : String = ""
    
    var body: some View {
        Text(text)
            .font(.subheadRegular) // Token Font
            .foregroundColor(.whitePrimarySurface) // Token Warna
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.orangePrimaryBrand) // Token Warna
            .cornerRadius(CornerRadius.full.value) // Token Radius (Pill)
            .padding(.horizontal, 40)
            .padding(.bottom, 34) // Memberikan jarak aman dari home indicator iPhone
    }
}
