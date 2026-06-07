//
//  LidarGuidelineCard.swift
//  NailongPet
//
//  Created by Fakhri Djamaris on 05/06/26.
//

import SwiftUI

struct LidarGuidelineCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            LidarStepRow(icon: .pawLoading, text: "Scan while your pet is sleeping soundly")
            LidarStepRow(icon: .infoTips, text: "Ensure even, bright room lighting")
            LidarStepRow(icon: .bringTo3D, text: "Walk 360° around your pet slowly")
            LidarStepRow(icon: .cameraGuideline, text: "Keep the collar, toy, or pet fully inside the box", showLine: false)
        }
        .padding(24)
        .background(Color.brownSecondaryBrand) // Token Warna
        .cornerRadius(CornerRadius.medium.value) // Token Radius (22px)
    }
}

#Preview {
    LidarGuidelineCard()
}
