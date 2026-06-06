//
//  MenuSelection.swift
//  NailongPet
//
//  Created by Lucky Akbar on 05/06/26.
//

import SwiftUI

struct MenuSelection: View {
    let menuFeatureTitle: String
    let menuFeatureSubtitle: String
    let menuFeatureIconImgName: String

    var body: some View {
        VStack{
            Image(systemName: "placeholderMenuSelection")
                .frame(maxWidth: 299, maxHeight: 193)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
            
            HStack(spacing: 12) {
                Image(systemName: menuFeatureIconImgName)
                    .font(Font.title1)
                VStack(alignment: .leading) {
                    Text(menuFeatureTitle)
                        .font(Font.title2)
                    Text(menuFeatureSubtitle)
                        .font(Font.body)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
             }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(
            ZStack{
                RoundedRectangle(cornerRadius: 22)
                LinearGradient(colors: [Color.BrandColorPrimary, Color.white], startPoint: .bottom, endPoint: .top)
            }
        )
        .frame(width: 313, height: 277)
        .cornerRadius(22)
    }
}

#Preview {
    MenuSelection(
        menuFeatureTitle: "Bring Pet to 3D",
        menuFeatureSubtitle: "Feel the presence of your 3D companion",
        menuFeatureIconImgName: AppIcon.MenuFeatureMLSharp
    )
}
