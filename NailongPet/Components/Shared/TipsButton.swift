//
//  TipsButton.swift
//  NailongPet
//
//  Created by Fakhri Djamaris on 07/06/26.
//

import SwiftUI

struct TipsButton: View {
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                AppIcon.infoTips.image
                Text("Tips")
                    .font(.footnoteRegular)
            }
            .foregroundColor(.blackPrimaryText)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color.whitePrimarySurface.opacity(0.8))
            .cornerRadius(CornerRadius.full.value)
        }
    }
}

#Preview {
    ZStack {
        Color.graySecondaryText.ignoresSafeArea()
        TipsButton()
    }
}
