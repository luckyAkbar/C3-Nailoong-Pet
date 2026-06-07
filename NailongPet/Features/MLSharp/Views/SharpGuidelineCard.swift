//
//  SharpGuidelineCard.swift
//  NailongPet
//
//  Created by carstenz meru phantara on 07/06/26.
//

import SwiftUI

struct SharpGuidelineCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            LidarStepRow(icon: .pawLoading, text: "Prepare a clean photo of your pet")
            LidarStepRow(icon: .bringTo3D, text: "Ensure the photo has a proper lighting")
            LidarStepRow(icon: .cameraGuideline, text: "Show a full body of your pet. For a better result, the photo preferably from a high/slightly high angle ", showLine: false)
        }
        .padding(24)
        .background(Color.brownSecondaryBrand) // Token Warna
        .cornerRadius(CornerRadius.medium.value) // Token Radius (22px)
    }
}

#Preview {
    SharpGuidelineCard()
}
