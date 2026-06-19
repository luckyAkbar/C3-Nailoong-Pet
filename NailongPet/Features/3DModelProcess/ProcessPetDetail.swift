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

    private var placeholderModelURL: URL? {
        Bundle.main.url(forResource: "buncit", withExtension: "usdz")
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
            VStack(spacing: 24) {
                // MARK: Pet preview card
                Group {
                    if let url = modelURL {
                        USDZPreviewView(url: url)
                    } else if let url = placeholderModelURL {
                        USDZPreviewView(url: url)
                    } else {
                        PetProfilePhoto(pet: pet)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 32)

                VStack(spacing: 20) {
                    VStack(spacing: 0) {
                        TextField("Name", text: $petName)
                            .focused($focusedField, equals: .name)
                            .font(.title2Bold)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.textPrimary)
                    }
                    .padding(.horizontal, 24)

                    VStack(spacing: 0) {
                        TextField("Description", text: $petDescription, axis: .vertical)
                            .focused($focusedField, equals: .description)
                            .font(.subheadRegular)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.textPrimary)
                            .lineLimit(5, reservesSpace: true)
                            .tint(Color.brandPrimary)
                    }
                    .padding(.horizontal, 24)
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium.value, style: .continuous))
                .padding(.horizontal, 20)

                Button(action: savePet) {
                    Text("Next")
                        .font(.subheadBold)
                        .foregroundColor(isFormEmpty ? .textTertiary : .onBrand)
                        .frame(maxWidth: .infinity, minHeight: 55)
                        .background(isFormEmpty ? Color.surfacePetItem: Color.brandPrimary)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .strokeBorder(Color.textTertiary.opacity(isFormEmpty ? 0.25 : 0), lineWidth: 0.5)
                        )
                }
                .disabled(isFormEmpty)
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
            .frame(maxWidth: .infinity)
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
        ProcessPetDetail(generatorType: .mlSharp)
            .environmentObject(AppRouter())
            .environmentObject(LidarCaptureManager())
            .environmentObject(SHARPViewModel())
            .environmentObject(PetStore())
    }
}
