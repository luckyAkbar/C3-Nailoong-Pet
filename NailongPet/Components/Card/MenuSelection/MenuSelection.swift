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
                .frame(maxWidth: 313, maxHeight:277)
                .background(RoundedRectangle(cornerRadius: CornerRadius.medium.value).fill(Color.whitePrimarySurface))
            
                HStack {
                    AppIcon.bringTo3D.image
                        .font(.title1Bold)
                        .padding(10)
                    VStack(alignment: .leading){
                        Text("Bring Pet to 3D").font(.subheadRegular)
                        Text("Preserve the moment with your pet")
                    }
                }
                .frame(maxWidth: .infinity)
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: CornerRadius.medium.value).fill(Color.orangePrimaryBrand))
        .frame(maxWidth: 300, maxHeight: 200)
        
    }
}

#Preview {
    MenuSelection()
}
