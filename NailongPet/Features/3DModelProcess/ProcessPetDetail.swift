//
//  ProcessPetDetail.swift
//  NailongPet
//

import SwiftUI

struct ProcessPetDetail: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var manager: LidarCaptureManager
    @EnvironmentObject private var sharpViewModel: SHARPViewModel
    @EnvironmentObject private var petStore: PetStore

    private enum Field {
        case name
        case description
    }

    var generatorType: GeneratorType

    init(generatorType: GeneratorType) {
        self.generatorType = generatorType
    }

    @State private var petName: String = ""
    @State private var petDescription: String = ""
    @FocusState private var focusedField: Field?

    private var isFormEmpty: Bool {
        petName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private var pet: Pet3DProfile = Pet3DProfile(
        name: "Moli",
        imageName: AppIcon.moli.rawValue
    )

    private var modelURL: URL? {
        switch generatorType {
        case .lidar:
            return manager.modelURL
        case .mlSharp:
            if case .completed(let url) = sharpViewModel.state {
                return url
            }
            return nil
        }
    }

    private func savePet() {
        guard let url = modelURL else { return }
        petStore.add(
            name: petName.trimmingCharacters(in: .whitespaces),
            petDescription: petDescription.trimmingCharacters(in: .whitespaces),
            modelFileName: url.lastPathComponent,
            context: modelContext
        )
        manager.reset()
        sharpViewModel.reset()
        router.navigateToRoot()
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // MARK: Pet preview card
                Group {
                    if let url = modelURL {
                        USDZPreviewView(url: url)
                    } else {
                        PetProfilePhoto(pet: pet)
                    }
                }
                .frame(width: 260, height: 260)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium.value, style: .continuous))
                .padding(.top, 32)

                // MARK: Name field
                VStack(spacing: 0) {
                    TextField("Name", text: $petName)
                        .focused($focusedField, equals: .name)
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

                // MARK: Description field
                VStack(alignment: .leading, spacing: 0) {
                    TextField("Add a description about your pet...", text: $petDescription, axis: .vertical)
                        .focused($focusedField, equals: .description)
                        .font(.subheadRegular)
                        .foregroundStyle(Color.textPrimary)
                        .lineLimit(5, reservesSpace: true)
                        .tint(Color.brandPrimary)
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
                
                
                // MARK: Save button
                Button(action: savePet) {
                    Text("Save")
                        .font(.subheadBold)
                        .foregroundColor(isFormEmpty ? .textTertiary : .onBrand)
                        .frame(width: 160, height: 50)
                        .background(isFormEmpty ? Color.surfacePrimary : Color.brandPrimary)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .strokeBorder(Color.textTertiary.opacity(isFormEmpty ? 0.25 : 0), lineWidth: 0.5)
                        )
                }
                .disabled(isFormEmpty)
                .padding(.top, 28)
                .padding(.bottom, 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = nil
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color.surfaceCanvas.ignoresSafeArea())
        .navigationTitle("3D Pet")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ProcessPetDetail(generatorType: .lidar)
            .environmentObject(AppRouter())
            .environmentObject(LidarCaptureManager())
            .environmentObject(SHARPViewModel())
            .environmentObject(PetStore())
    }
}
