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
        // GeometryReader + ScrollView: background selalu full-screen,
        // konten scroll ke atas saat keyboard muncul → tidak ada celah hitam.
        GeometryReader { geo in
            ZStack {
                Color.beigeTertiaryBrand.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        NavigationTopBarPetPage(onBack: { router.navigateBack() })

                        Spacer(minLength: 32)

                        PetProfilePhoto(pet: pet)
                            .frame(width: 120, height: 120)

                        // Pet name field
                        ZStack(alignment: .leading) {
                            HStack {
                                TextField("Pet name", text: $petName)
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(Color.brownSecondaryBrand)
                                    .tint(Color.brownSecondaryBrand)
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
                        .environment(\.colorScheme, .light)

                        Spacer(minLength: 32)

                        // Description card — teks hitam di atas background oranye
                        VStack(alignment: .leading) {
                            Text("Description")
                                .font(.subheadRegular)
                                .bold()
                                .foregroundColor(.blackPrimaryText)

                            Divider()
                                .overlay(Color.blackPrimaryText.opacity(0.3))

                            TextField("Pet description", text: $petDescription, axis: .vertical)
                                .font(.subheadRegular)
                                .foregroundStyle(Color.blackPrimaryText)
                                .tint(Color.blackPrimaryText)
                                .lineLimit(4, reservesSpace: true)
                        }
                        .padding(15)
                        .frame(maxWidth: .infinity, minHeight: 199, alignment: .leading)
                        .background(Color.orangePrimaryBrand)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium.value))
                        .padding(.horizontal, 16)

                        Spacer(minLength: 48)

                        // Setelah simpan → kembali ke Home (root)
                        Button(action: { router.navigateToRoot() }) {
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
                        .padding(.bottom, 40)
                    }
                    // minHeight = full screen → layout tetap centered saat keyboard tidak muncul
                    .frame(minWidth: geo.size.width, minHeight: geo.size.height)
                }
                .scrollDismissesKeyboard(.interactively)
            }
        }
        .ignoresSafeArea(.keyboard)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    ProcessPetDetail()
        .environmentObject(AppRouter())
}
