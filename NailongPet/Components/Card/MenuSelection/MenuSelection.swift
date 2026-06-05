//
//  MenuSelection.swift
//  NailongPet
//
//  Created by Lucky Akbar on 05/06/26.
//

import SwiftUI

struct MenuSelection: View {
    var ratio: CGFloat = 0.25 // Configurable ratio for the first part (e.g. 0.25 for 1/4 width)

    var body: some View {
        VStack{
            Image(systemName: "placeholderMenuSelection")
                .frame(maxWidth: 313, maxHeight:277)
                .background(RoundedRectangle(cornerRadius: 22).fill(Color.white))
            
                HStack {
                    Image(systemName: AppIcon.MenuFeatureDefault)
                        .font(Font.title1)
                        .padding(10)
                    VStack(alignment: .leading){
                        Text("Bring Pet to 3D").font(Font.subhead)
                        Text("Preserve the moment with your pet")
                    }
                    .frame(maxWidth: .infinity)
                }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 22).fill(Color.BrandColorPrimary))
        .frame(maxWidth: 300, maxHeight: 200)
        
    }
}

#Preview {
    MenuSelection()
}
