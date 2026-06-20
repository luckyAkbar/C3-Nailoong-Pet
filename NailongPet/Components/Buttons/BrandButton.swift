//
//  BrandButton.swift
//  NailongPet
//
//  Created by carstenz meru phantara on 07/06/26.
//
import SwiftUI

struct BrandButton: View {
    var text : String = ""
    var isEnabled: Bool = true
    
    var body: some View {
        Text(text)
            .font(.subheadRegular) // Token Font
            .foregroundColor(isEnabled ? .whitePrimarySurface : .blackPrimaryText) // Token Warna
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(isEnabled ? Color.orangePrimaryBrand : Color.grayDisabledAction.opacity(0.5)) // Token Warna
            .cornerRadius(CornerRadius.full.value) // Token Radius (Pill)
            .padding(.horizontal, 40)
            .padding(.bottom, 34) // Memberikan jarak aman dari home indicator iPhone
    }
}
