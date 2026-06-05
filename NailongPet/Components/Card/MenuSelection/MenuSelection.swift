//
//  MenuSelection.swift
//  NailongPet
//
//  Created by Lucky Akbar on 05/06/26.
//

import SwiftUI

struct MenuSelection: View {
    var body: some View {
        VStack{
            Image(systemName: "placeholderMenuSelection")
                .frame(maxWidth: 299, maxHeight: 193)
                .background(RoundedRectangle(cornerRadius: 22).fill(Color.white))
            
            HStack {
                    Image(systemName: AppIcon.MenuFeatureDefault)
                        .font(Font.title1)
                        .padding(.trailing, 0)
                    VStack(alignment: .leading){
                        Text("Bring Pet to 3D").font(Font.title1)
                        Text("Preserve the moment with your pet").font(Font.body)
                    }
                }
                .frame(maxWidth: .infinity)
        }
        .padding(12)
        .background(
            ZStack{
                RoundedRectangle(cornerRadius: 22)
                LinearGradient(colors: [Color.BrandColorPrimary, Color.BrandColorTertiary], startPoint: .bottom, endPoint: .top)
            }
        )
        .frame(maxWidth: 313, maxHeight: 277)
        .cornerRadius(22)
        
        
    }
}

#Preview {
    MenuSelection()
}
