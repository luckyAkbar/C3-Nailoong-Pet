//
//  Home.swift
//  NailongPet
//
//  Created by Lucky Akbar on 05/06/26.
//

import SwiftUI

struct Home: View {
    var body: some View {
        VStack {
            AppTitle()
            
            Spacer()
            
            MenuSelection(
                menuFeatureTitle: "Bring Pet to 3D",
                menuFeatureSubtitle: "Preserve the moment with your pet",
                menuFeatureIconImgName: AppIcon.MenuFeatureMLSharp
            )
            
            Spacer()
            
            MenuSelection(
                menuFeatureTitle: "Interact",
                menuFeatureSubtitle: "Feel the presence of your 3D companion",
                menuFeatureIconImgName: AppIcon.MenuFeatureObjectCapture
            )
            
            Spacer()
        }
        .background(Color.BrandColorTertiary)
        
    }
}

#Preview {
    Home()
}
