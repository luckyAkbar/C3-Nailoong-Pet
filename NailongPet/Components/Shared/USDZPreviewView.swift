//
//  USDZPreviewView.swift
//  NailongPet
//
//  Created by Antigravity on 16/06/26.
//

import SwiftUI
import SceneKit

struct USDZPreviewView: View {
    let url: URL
    private let imageWhitePadding: CGFloat = 12

    var body: some View {
        ZStack {
            Color.orangePrimaryBrand

            if let scene = try? SCNScene(url: url, options: nil) {
                SceneView(
                    scene: scene,
                    options: [.allowsCameraControl, .autoenablesDefaultLighting]
                )
                .padding(8)
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.white)
                        .font(.title)
                    Text("Error loading preview")
                        .font(.footnoteRegular)
                        .foregroundColor(.white)
                }
                .padding(8)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small.value))
        .innerShadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 1)
        .aspectRatio(1, contentMode: .fit)
        .padding(imageWhitePadding)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Inner Shadow
private struct InnerShadowModifier: ViewModifier {
    var color: Color
    var radius: CGFloat
    var x: CGFloat
    var y: CGFloat

    func body(content: Content) -> some View {
        content.overlay {
            GeometryReader { geometry in
                color
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .blur(radius: radius)
                    .offset(x: x, y: y)
            }
            .mask(content)
        }
    }
}

private extension View {
    func innerShadow(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) -> some View {
        modifier(InnerShadowModifier(color: color, radius: radius, x: x, y: y))
    }
}
