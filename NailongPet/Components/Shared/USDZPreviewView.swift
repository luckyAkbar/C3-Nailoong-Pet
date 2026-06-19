//
//  USDZPreviewView.swift
//  NailongPet
//
//  Created by carstenz meru phantara on 19/06/26.
//


//
//  USDZPreviewView.swift
//  NailongPet
//
//  Created by Antigravity on 16/06/26.
//

import SwiftUI
import SceneKit
import UIKit

struct USDZPreviewView: View {
    let url: URL
    private let imageWhitePadding: CGFloat = 12

    var body: some View {
        ZStack {
            Color.surfacePrimary

            TransparentUSDZSceneView(url: url)
                .padding(8)
        }
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small.value))
        .innerShadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 1)
        .aspectRatio(1, contentMode: .fit)
        .padding(imageWhitePadding)
        .frame(maxWidth: .infinity)
    }
}

private struct TransparentUSDZSceneView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        view.backgroundColor = .clear
        view.isOpaque = false
        view.allowsCameraControl = true
        view.autoenablesDefaultLighting = true
        view.antialiasingMode = .multisampling4X
        view.contentMode = .scaleAspectFit

        if let scene = try? SCNScene(url: url, options: nil) {
            scene.background.contents = UIColor.clear
            view.scene = scene
        }

        return view
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        guard uiView.scene == nil, let scene = try? SCNScene(url: url, options: nil) else { return }
        scene.background.contents = UIColor.clear
        uiView.scene = scene
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
