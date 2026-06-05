//
//  Home.swift
//  NailongPet
//
//  Created by Lucky Akbar on 05/06/26.
//

import SwiftUI

struct Home: View {
    var body: some View {
        VStack (alignment: .leading) {
            Text("Nailong Pet")
                .font(Font.title1)
                .multilineTextAlignment(.leading)
                .padding(.top, 25)
            
            Spacer()
            
            MenuSelection()
            
            Spacer()
            
            MenuSelection()
            
            Spacer()
        }
    }
}

#Preview {
    Home()
}
