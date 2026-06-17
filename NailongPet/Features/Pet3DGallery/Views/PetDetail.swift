//
//  PetDetail.swift
//  NailongPet
//
//  Created by Lucky Akbar on 07/06/26.
//

import SwiftUI
import SwiftData

struct PetDetail: View {
    @EnvironmentObject private var router: AppRouter
        @Environment(\.modelContext) private var modelContext
        @State private var isShowingEditSheet: Bool = false
        @State private var editName: String = ""
        @State private var editDescription: String = ""

    var pet: Pet3DProfile

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Group {
                    if let modelURL = pet.modelURL {
                        USDZPreviewView(url: modelURL)
                    } else {
                        PetProfilePhoto(pet: pet)
                    }
                }
                .frame(width: 260, height: 260)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium.value, style: .continuous))
                .padding(.top, 32)

                VStack(spacing: 0) {
                    Text(pet.name)
                        .font(.title2Bold)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.textPrimary)
                        .padding(.bottom, 8)

                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(Color.textTertiary.opacity(0.4))
                }
                .padding(.horizontal, 60)
                .padding(.top, 24)

                VStack(alignment: .leading, spacing: 0) {
                    Text("Description")
                        .font(.subheadBold)
                        .foregroundStyle(Color.textPrimary)
                        .padding(.bottom, 10)

                    Text(pet.petDescription.isEmpty ? "No description provided." : pet.petDescription)
                        .font(.subheadRegular)
                        .foregroundStyle(Color.textPrimary)
                        .lineLimit(5, reservesSpace: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.surfacePrimary)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium.value, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.medium.value, style: .continuous)
                        .strokeBorder(Color.textTertiary.opacity(0.2), lineWidth: 0.5)
                )
                .padding(.horizontal, 20)
                .padding(.top, 20)

                Button(action: {
                    router.navigate(to: .arInteraction(pet))
                }) {
                    Text("Interact")
                        .font(.subheadBold)
                        .foregroundColor(.onBrand)
                        .frame(width: 160, height: 50)
                        .background(Color.brandPrimary)
                        .clipShape(Capsule())
                }
                .padding(.top, 28)
                .padding(.bottom, 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.surfaceCanvas.ignoresSafeArea())
        .navigationTitle("3D Pet")
        .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        // prepare edit fields and show sheet
                        editName = pet.name
                        editDescription = pet.petDescription
                        isShowingEditSheet = true
                    }) {
                        Text("Edit")
                            .font(.footnoteRegular)
                    }
                }
            }
            .sheet(isPresented: $isShowingEditSheet) {
                NavigationStack {
                    Form {
                        Section(header: Text("Name")) {
                            TextField("Name", text: $editName)
                        }
                        Section(header: Text("Description")) {
                            TextEditor(text: $editDescription)
                                .frame(height: 140)
                        }
                    }
                    .navigationTitle("Edit Pet")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { isShowingEditSheet = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                // apply changes to model and persist
                                pet.name = editName
                                pet.petDescription = editDescription
                                try? modelContext.save()
                                isShowingEditSheet = false
                            }
                        }
                    }
                }
            }
    }
}

#Preview {
    PetDetail(pet: Pet3DProfile(name: "Moli", imageName: AppIcon.moli.rawValue))
        .environmentObject(AppRouter())
}
