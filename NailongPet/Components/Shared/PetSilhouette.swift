import SwiftUI

struct PetSilhouetteView: View {
    var imageName: String = "CatSilhouette"
    var tintColor: Color = .onBrand

    var body: some View {
        Image(imageName)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(tintColor)
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
