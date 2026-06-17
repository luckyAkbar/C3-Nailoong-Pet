import SwiftUI

struct HomeFilledState: View {
    let pets: [Pet3DProfile]
    let selected: Pet3DProfile?
    var onSelect: (Pet3DProfile) -> Void = { _ in }
    var onInteract: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {
            if let pet = selected {
                VStack(alignment: .leading, spacing: 6) {
                    Text(pet.name)
                        .font(.title1Bold)
                        .foregroundColor(.textSecondary)

                    if !pet.petDescription.isEmpty {
                        Text(pet.petDescription)
                            .font(.subheadRegular)
                            .foregroundColor(.textTertiary)
                            .lineLimit(3)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 16)
            }

            ZStack(alignment: .bottom) {
                if let url = selected?.modelURL {
                    Pet3DModelView(url: url)
                        .frame(maxWidth: 572, maxHeight: .infinity, alignment: .bottom)
                } else {
                    PetSilhouetteView(imageName: "FilledSilhouette")
                        .frame(maxWidth: 572, alignment: .trailing)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }

                Button(action: onInteract) {
                    Text("Interact")
                        .font(.subheadRegular)
                        .padding(.horizontal, 32)
                        .foregroundStyle(Color.onBrand)
                        .frame(height: 44)
                        .glassEffect(.regular.tint(Color.brandPrimary).interactive(), in: Capsule())
                        .clipShape(Capsule())
                }
                .padding(.bottom, 26)
             
            }
            .frame(maxHeight: .infinity)

            PetAvatarCarousel(
                pets: pets,
                selectedID: selected?.id,
                onSelect: onSelect
            )
            .frame(height: 140)
            .background(Color.surfacePrimary.ignoresSafeArea(edges: .bottom))
            .shadow(color: Color.black.opacity(0.25), radius: 5, x: 0, y: -2)

        }
    }
}

#Preview {
    HomeFilledState(
        pets: HomeViewModel.samplePets,
        selected: HomeViewModel.samplePets.first
    )
    .background(Color.surfaceCanvas)
}
