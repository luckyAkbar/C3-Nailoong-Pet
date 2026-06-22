import SwiftUI

struct PetSilhouetteView: View {
    var imageName: String = "AssetEmptyState"
    var tintColor: Color = .onBrand

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .offset(x: -100)
            .scaleEffect(2.2)
            .foregroundStyle(Color.brandSecondary)
            .scaledToFit()
            .accessibilityHidden(true)
    }
}

#Preview("Silhouette") {
    PetSilhouetteView()
        .frame(maxWidth: 561, minHeight: 450)
        .background(Color.surfaceCanvas)
}

#Preview("Silhouette - Dark") {
    PetSilhouetteView()
        .frame(width: 561, height: 450)
        .padding()
        .background(Color.surfaceCanvas)
        .environment(\.colorScheme, .dark)
}
