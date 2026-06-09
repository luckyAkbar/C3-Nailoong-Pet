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
            NavigationTopBarPetPage(onBack: { router.navigateBack() })

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
                    .font(.subheadRegular)
                    .bold()

                Divider()
                    .background(Color.whitePrimarySurface.opacity(0.5))

                TextField("Pet description", text: $petDescription, axis: .vertical)
                    .foregroundStyle(Color.whitePrimarySurface)
                    .font(.subheadRegular)
                    .lineLimit(4, reservesSpace: true)
            }
            .padding(15)
            .frame(maxWidth: .infinity, minHeight: 199, alignment: .leading)
            .background(Color.orangePrimaryBrand)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium.value))

            Spacer()
            Spacer()
            Spacer()

            // Setelah simpan → ke Pet3DGallery — Button/FormAction/Active|Disabled
            Button(action: { router.navigate(to: .pet3DGallery) }) {
                Text("Save")
                    .font(.subheadRegular)
                    .foregroundStyle(isFormEmpty ? Color.blackPrimaryText : Color.whitePrimarySurface)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(isFormEmpty ? Color.grayDisabledAction.opacity(0.4) : Color.orangePrimaryBrand)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.full.value))
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
