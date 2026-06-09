//
//  CircularIconButton.swift
//  NailongPet
//
//  Created by Fakhri Djamaris on 07/06/26.
//

import SwiftUI

struct CircularIconButton: View {
    var icon: AppIcon
    var background: Color = Color.whitePrimarySurface.opacity(0.8)
    var foreground: Color = .blackPrimaryText
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            icon.image
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(foreground)
                .padding(10)
                .background(background)
                .clipShape(Circle())
                .frame(width: 44, height: 44) // minimum tap area sesuai Apple HIG
        }
    }
}

#Preview("On Camera") {
    ZStack {
        Color.graySecondaryText.ignoresSafeArea()
        CircularIconButton(icon: .close)
    }
}

#Preview("On Sheet") {
    CircularIconButton(
        icon: .close,
        background: Color.graySecondaryText.opacity(0.15)
    )
    .padding()
}
