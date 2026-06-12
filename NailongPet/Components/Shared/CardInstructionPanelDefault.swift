//
//  GuidelineCard.swift
//  NailongPet
//
//  Created by Fakhri Djamaris on 07/06/26.
//

import SwiftUI

struct StepItem {
    var icon: AppIcon
    var text: String
}

//previously GuidelineCard
struct CardInstructionPanelDefault: View {
    var steps: [StepItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(steps.indices, id: \.self) { index in
                StepRow(
                    item: steps[index],
                    showLine: index < steps.count - 1
                )
            }
        }
        .padding(24)
        .background(Color.brownSecondaryBrand)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium.value))
    }
}

#Preview("LiDAR Steps") {
    CardInstructionPanelDefault(steps: [
        StepItem(icon: .pawLoading,      text: "Scan while your pet is sleeping soundly"),
        StepItem(icon: .infoTips,        text: "Ensure even, bright room lighting"),
        StepItem(icon: .walkAround,      text: "Walk 360° around your pet slowly"),
        StepItem(icon: .cameraGuideline, text: "Keep the collar, toy, or pet fully inside the box"),
    ])
    .padding()
}

#Preview("ML Sharp Steps") {
    CardInstructionPanelDefault(steps: [
        StepItem(icon: .pawLoading,      text: "Prepare a clean photo of your pet"),
        StepItem(icon: .infoTips,        text: "Ensure the photo has a proper lighting"),
        StepItem(icon: .cameraGuideline, text: "Show a full body of your pet. For a better result, the photo preferably from a high/slightly high angle"),
    ])
    .padding()
}
