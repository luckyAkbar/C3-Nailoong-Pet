//
//  AppTitle.swift
//  NailongPet
//
//  Created by Lucky Akbar on 05/06/26.
//

import SwiftUI

struct AppTitle: View {
    var title: String = AppName
    var font: Font = .title1
    var topPadding: CGFloat = 25
    var leadingPadding: CGFloat = 24
    
    var body: some View {
        HStack {
            Text(title)
                .font(font)
                .padding(.top, topPadding)
                .padding(.leading, leadingPadding)
            Spacer()
        }
    }
}

#Preview {
    AppTitle(title: AppName)
}
