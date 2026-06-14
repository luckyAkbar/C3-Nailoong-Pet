import SwiftUI

struct PetAvatarCarousel: View {
    let pets: [Pet3DProfile]
    var selectedID: UUID? = nil
    var onSelect: (Pet3DProfile) -> Void = { _ in }

    @State private var centeredID: UUID?

    private let itemLayoutSize: CGFloat = 100
    private let ringSize: CGFloat = 110

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(pets) { pet in
                            Button {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    centeredID = pet.id
                                }
                            } label: {
                                PetAvatarItem(pet: pet, isSelected: pet.id == centeredID)
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel(pet.name)
                            .id(pet.id)
                        }
                    }
                    .scrollTargetLayout()
                    .padding(.horizontal, (geo.size.width - itemLayoutSize) / 2)
                    .padding(.vertical, 12)
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $centeredID)
                .onChange(of: centeredID) { _, newID in
                    if let id = newID, let pet = pets.first(where: { $0.id == id }) {
                        onSelect(pet)
                    }
                }
                .onChange(of: selectedID) { _, newID in
                    if centeredID != newID {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            centeredID = newID
                        }
                    }
                }

                Circle()
                    .stroke(Color.brandPrimary, lineWidth: 3)
                    .frame(width: ringSize, height: ringSize)
                    .allowsHitTesting(false)
            }
        }
        .onAppear {
            centeredID = selectedID
        }
    }
}

private struct PetAvatarItem: View {
    let pet: Pet3DProfile
    var isSelected: Bool

    private let avatarBg = Color(red: 220/255, green: 220/255, blue: 220/255)

    var body: some View {
        let size: CGFloat = isSelected ? 100 : 74

        Image(pet.imageName)
            .resizable()
            .scaledToFit()
            .padding(isSelected ? 15 : 10)
            .frame(width: size, height: size)
            .background(avatarBg)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.avatarPetItem.opacity(0.6), lineWidth: 6)
                    .blur(radius: 3)
                    .offset(x: 0, y: 1)
                    .mask(Circle())
            )
            .shadow(color: Color.black.opacity(0.25), radius: 5, x: 0, y: 2)
            .frame(width: 100, height: 100)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    PetAvatarCarousel(
        pets: HomeViewModel.samplePets,
        selectedID: HomeViewModel.samplePets.first?.id
    )
    .frame(height: 140)
    .background(Color(hex: 0xE8E8E8))
}
