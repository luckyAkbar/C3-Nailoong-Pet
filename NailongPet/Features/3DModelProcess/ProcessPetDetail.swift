//
//  ProcessPetDetail.swift
//  NailongPet
//
//  Created by carstenz meru phantara on 08/06/26.
//

import SwiftUI

struct ProcessPetDetail: View {
    @EnvironmentObject private var router: AppRouter

    @State private var petName: String = ""
    @State private var petDescription: String = ""

    private var isFormEmpty: Bool {
        petName.trimmingCharacters(in: .whitespaces).isEmpty ||
        petDescription.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private var pet: Pet3DProfile = Pet3DProfile(
        name: "Moli",
        imageName: AppIcon.moli.rawValue
    )

    var body: some View {
        VStack {
            PetDetailToolbar(onBack: { router.navigateBack() })

            Spacer()

            PetProfilePhoto(pet: pet)
                .frame(width: 120, height: 120)

            ZStack(alignment: .leading) {
                HStack {
                    TextField("Pet name", text: $petName)
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

                TextField("Pet description", text: $petDescription, axis: .vertical)
                    .foregroundStyle(Color.white)
                    .lineLimit(4, reservesSpace: true)
            }
            .padding(15)
            .frame(width: 362, height: 199, alignment: .leading)
            .background(Color.orangePrimaryBrand)
            .clipShape(RoundedRectangle(cornerRadius: 26))

            Spacer()
            Spacer()
            Spacer()

            // Setelah simpan → ke Pet3DGallery
            Button(action: { router.navigate(to: .pet3DGallery) }) {
                Text("Done")
                    .font(.subheadRegular)
                    .foregroundColor(isFormEmpty ? .blackPrimaryText : .whitePrimarySurface)
                    .frame(width: 179, height: 55)
                    .frame(height: 50)
                    .background(isFormEmpty ? Color.whitePrimarySurface : Color.orangePrimaryBrand)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.full.value))
                    .shadow(
                        color: isFormEmpty ? Color.graySecondaryText : Color.orangePrimaryBrand.opacity(0.35),
                        radius: 8, x: 0, y: 4
                    )
            }
            .disabled(isFormEmpty)
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
    ProcessPetDetail()
        .environmentObject(AppRouter())
}
