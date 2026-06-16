//
//  PetDetail.swift
//  NailongPet
//
//  Created by Lucky Akbar on 07/06/26.
//

import SwiftUI

struct PetDetail: View {
    @EnvironmentObject private var router: AppRouter

    var pet: Pet3DProfile

    var body: some View {
        VStack {
            PetDetailToolbar(onBack: { router.navigateBack() })

            Spacer()

            if let modelURL = pet.modelURL {
                USDZPreviewView(url: modelURL)
                    .frame(width: 120, height: 120)
            } else {
                PetProfilePhoto(pet: pet)
                    .frame(width: 120, height: 120)
            }

            ZStack(alignment: .leading) {
                HStack {
                    Text(pet.name)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.brownSecondaryBrand)
                    Spacer()
                }
                .padding(.bottom, 8)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(Color.brownSecondaryBrand)
                }
            }
            .padding(20)
            .frame(width: 178, height: 44)

            Spacer()

            VStack(alignment: .leading) {
                Text("Description")
                    .bold(true)

                Divider()

                Text("This is my second pet cat, her name is Moli. The only clear picture I have of her is this, right before she went missing three months ago.")
                    .foregroundStyle(Color.white)
                Spacer()
            }
            .padding(15)
            .frame(width: 362, height: 199, alignment: .leading)
            .background(Color.orangePrimaryBrand)
            .clipShape(RoundedRectangle(cornerRadius: 26))

            Spacer()
            Spacer()
            Spacer()

            Button(action: {
                router.navigate(to: .arInteraction(pet))
            }) {
                Text("Interact")
                    .font(.subheadRegular)
                    .foregroundColor(.whitePrimarySurface)
                    .frame(width: 179, height: 55)
                    .frame(height: 50)
                    .background(Color.orangePrimaryBrand)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.full.value))
                    .shadow(color: Color.orangePrimaryBrand.opacity(0.35), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 40)
            .padding(.top, 8)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.beigeTertiaryBrand.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    PetDetail(pet: Pet3DProfile(name: "Moli", imageName: AppIcon.moli.rawValue))
        .environmentObject(AppRouter())
}
