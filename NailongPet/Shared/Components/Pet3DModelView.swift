import SwiftUI
import SceneKit

struct Pet3DModelView: View {
    let url: URL
    var allowsCameraControl: Bool = true

    var body: some View {
        if let scene = try? SCNScene(url: url, options: nil) {
            SceneKitContainer(scene: scene, allowsCameraControl: allowsCameraControl)
        } else {
            Image(systemName: "cube.transparent")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.secondary)
                .padding()
        }
    }
}

private struct SceneKitContainer: UIViewRepresentable {
    let scene: SCNScene
    let allowsCameraControl: Bool

    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        view.scene = scene
        view.backgroundColor = .clear
        view.isOpaque = false
        view.allowsCameraControl = allowsCameraControl
        view.autoenablesDefaultLighting = true
        view.antialiasingMode = .multisampling4X
        scene.background.contents = nil
        return view
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        if uiView.scene !== scene {
            uiView.scene = scene
            uiView.scene?.background.contents = nil
        }
        uiView.allowsCameraControl = allowsCameraControl
    }
}
