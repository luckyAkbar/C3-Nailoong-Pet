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
                .frame(maxWidth: .infinity, maxHeight: 300)
                .background(RoundedRectangle(cornerRadius: 22).fill(Color.white))
            HStack{
                Image(systemName: AppIcon.MenuFeatureDefault)
                VStack{
                    Text("Titlke").font(Font.title1)
                    Text("Subtitles")
                }.frame(maxWidth: .infinity)
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
