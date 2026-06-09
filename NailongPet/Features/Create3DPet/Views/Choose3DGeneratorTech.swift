//
//  Choose3DGeneratorTech.swift
//  NailongPet
//
//  Created by Lucky Akbar on 06/06/26.
//

import SwiftUI

struct Choose3DGeneratorTech: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Navigation Header Bar
            ZStack {
                HStack {
                    Button(action: { router.navigateBack() }) {
                        AppIcon.back.image
                            .font(.calloutBold)
                    }
                    .buttonStyle(.glass)
                    Spacer()
                }

                Text("Add A Pet")
                    .font(.title2Bold)
                    .foregroundColor(.blackPrimaryText)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)

            // MARK: - Menu Options
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    Button(action: { router.navigate(to: .mlSharp) }) {
                        MenuSelection(
                            icon: .favoriteMoment,
                            title: "Pick a Favorite Moment",
                            subtitle: "If your pet isn't nearby, start with a photo."
                        )
                    }
                    .buttonStyle(.plain)

                    Button(action: { router.navigate(to: .lidar) }) {
                        MenuSelection(
                            icon: .scanCompanion,
                            title: "Scan Your Companion",
                            subtitle: "A quick scan with a LiDAR-enabled device can help bring them even closer."
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
        }
        .background(Color.beigeTertiaryBrand.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    Choose3DGeneratorTech()
        .environmentObject(AppRouter())
}
