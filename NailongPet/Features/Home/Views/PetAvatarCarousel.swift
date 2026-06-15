import SwiftUI

private struct ItemCenterKey: PreferenceKey {
    static var defaultValue: [UUID: CGFloat] = [:]
    static func reduce(value: inout [UUID: CGFloat], nextValue: () -> [UUID: CGFloat]) {
        value.merge(nextValue()) { _, new in new }
    }
}

struct PetAvatarCarousel: View {
    let pets: [Pet3DProfile]
    var selectedID: UUID? = nil
    var onSelect: (Pet3DProfile) -> Void = { _ in }

    @State private var centeredID: UUID?

    private let itemLayoutSize: CGFloat = 100
    private let ringSize: CGFloat = 110

    var body: some View {
        GeometryReader { geo in
            let viewCenterX = geo.size.width / 2

            ZStack {
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(pets) { pet in
                                Button {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        proxy.scrollTo(pet.id, anchor: .center)
                                    }
                                } label: {
                                    PetAvatarItem(pet: pet, isSelected: pet.id == centeredID)
                                        .overlay(
                                            GeometryReader { itemGeo in
                                                Color.clear.preference(
                                                    key: ItemCenterKey.self,
                                                    value: [pet.id: itemGeo.frame(in: .named("carousel")).midX]
                                                )
                                            }
                                        )
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel(pet.name)
                                .id(pet.id)
                            }
                        }
                        .padding(.horizontal, (geo.size.width - itemLayoutSize) / 2)
                        .padding(.vertical, 12)
                    }
                    .onAppear {
                        let initial = selectedID ?? pets.first?.id
                        if let id = initial {
                            proxy.scrollTo(id, anchor: .center)
                        }
                    }
                }

                Circle()
                    .stroke(Color.brandPrimary, lineWidth: 3)
                    .frame(width: ringSize, height: ringSize)
                    .allowsHitTesting(false)
            }
            .coordinateSpace(name: "carousel")
            .onPreferenceChange(ItemCenterKey.self) { centers in
                let closest = centers.min { abs($0.value - viewCenterX) < abs($1.value - viewCenterX) }
                guard let id = closest?.key, id != centeredID else { return }
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    centeredID = id
                }
                if let pet = pets.first(where: { $0.id == id }) {
                    onSelect(pet)
                }
            }
        }
        .onAppear {
            centeredID = selectedID ?? pets.first?.id
        }
    }
}

private struct PetAvatarItem: View {
    let pet: Pet3DProfile
    var isSelected: Bool

    private let avatarBg = Color(red: 220/255, green: 220/255, blue: 220/255)

    var body: some View {
        avatarContent
            .frame(width: 100, height: 100)
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
            .scaleEffect(isSelected ? 1.0 : 0.74)
    }

    @ViewBuilder
    private var avatarContent: some View {
        if let url = pet.modelURL {
            Pet3DModelView(url: url, allowsCameraControl: false)
                .padding(8)
        } else {
            Image(pet.imageName)
                .resizable()
                .scaledToFit()
                .padding(15)
        }
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
