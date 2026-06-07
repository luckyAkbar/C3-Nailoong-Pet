//
//  StepRow.swift
//  NailongPet
//
//  Created by Fakhri Djamaris on 07/06/26.
//

import SwiftUI

struct StepRow: View {
    var item: StepItem
    var showLine: Bool = true

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(spacing: 8) {
                item.icon.image
                    .font(.subheadRegular)
                    .foregroundColor(.beigeTertiaryBrand)

                if showLine {
                    Capsule()
                        .fill(Color.beigeTertiaryBrand.opacity(0.5))
                        .frame(width: 2, height: 24)
                }
            }
            .frame(width: 24)

            Text(item.text)
                .font(.subheadRegular)
                .foregroundColor(.whitePrimarySurface)
                .padding(.top, 2)

            Spacer()
        }
    }
}

#Preview {
    VStack {
        StepRow(item: StepItem(icon: .pawLoading, text: "Scan while your pet is sleeping soundly"))
        StepRow(item: StepItem(icon: .infoTips, text: "Ensure even, bright room lighting"), showLine: false)
    }
    .padding()
    .background(Color.brownSecondaryBrand)
}
