import SwiftUI
import RealityKit
import ARKit
import Combine
import Vision

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var viewModel: ARInteractionViewModel
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        arView.session.run(configuration)
        
        arView.session.delegate = context.coordinator
        context.coordinator.arView = arView
        
        guard let modelPath = viewModel.pet.modelFileName else {
            print("AR Error: 3D model file name is nil.")
            return arView
        }        
        // 2. Guard to check if the file is accessible in the app bundle
        // We handle cases where the extension is included in the string or not.
        let fileExtension = (modelPath as NSString).pathExtension
        let fileName = (modelPath as NSString).deletingPathExtension
        
        guard Bundle.main.url(forResource: fileName, withExtension: fileExtension.isEmpty ? "usdz" : fileExtension) != nil else {
            print("AR Error: 3D model file '\(modelPath)' not found in app bundle.")
            return arView
        }
        
        // 3. Create an anchor for a horizontal plane
        let anchor = AnchorEntity(plane: .horizontal)
        arView.scene.anchors.append(anchor)
        
        // 4. Load the model asynchronously
        ModelEntity.loadModelAsync(named: modelPath)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("AR Error loading model \(modelPath): \(error.localizedDescription)")
                }
            }, receiveValue: { modelEntity in
                modelEntity.generateCollisionShapes(recursive: true)
                anchor.addChild(modelEntity)
                context.coordinator.petEntity = modelEntity
                
                // Subscribe to anchored state so we know when it actually appears in the real world
                context.coordinator.setupAnchoredSubscription(arView: arView, anchor: anchor)
            })
            .store(in: &context.coordinator.cancellables)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        var viewModel: ARInteractionViewModel
        var cancellables = Set<AnyCancellable>()
        var petEntity: ModelEntity?
        weak var arView: ARView?
        
        private var handPoseRequest = VNDetectHumanHandPoseRequest()
        private var isPetting = false
        private var lastPetTime = Date()
        private let reactionScaleFactor: Float = 1.2
        private var originalScale: simd_float3?
        
        // Compute position based on the actual entity's position in the world
        var petEntityPosition: simd_float3? {
            return petEntity?.position(relativeTo: nil)
        }
        
        init(viewModel: ARInteractionViewModel) {
            self.viewModel = viewModel
        }
        
        func setupAnchoredSubscription(arView: ARView, anchor: AnchorEntity) {
            // If it somehow anchored immediately
            if anchor.isAnchored {
                DispatchQueue.main.async {
                    self.viewModel.onModelRendered()
                }
                return
            }
            
            // Wait for it to become anchored to a detected plane
            arView.scene.subscribe(to: SceneEvents.AnchoredStateChanged.self, on: anchor) { [weak self] event in
                if event.isAnchored {
                    DispatchQueue.main.async {
                        self?.viewModel.onModelRendered()
                    }
                }
            }.store(in: &cancellables)
        }
        
        // This function is called every time the AR camera frame updates (60 times a second)
        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            guard let arView = arView else { return }

            if let petEntity = self.petEntity {
                checkDistance(arView: arView, entity: petEntity)
            }

            guard Date().timeIntervalSince(lastPetTime) > 0.3 else { return }

            let pixelBuffer = frame.capturedImage
            DispatchQueue.global(qos: .userInteractive).async {
                let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: [:])
                do {
                    try handler.perform([self.handPoseRequest])
                    guard let observation = self.handPoseRequest.results?.first else { return }
                    let indexTip = try observation.recognizedPoint(.indexTip)

                    if indexTip.confidence > 0.6 {
                        DispatchQueue.main.async {
                            let screenX = (1.0 - indexTip.location.y) * arView.bounds.width
                            let screenY = (1.0 - indexTip.location.x) * arView.bounds.height
                            let screenPoint = CGPoint(x: screenX, y: screenY)
                            let hits = arView.hitTest(screenPoint, query: .nearest)

                            if let hitEntity = hits.first?.entity {
                                var current: Entity? = hitEntity
                                var didHit = false
                                while let node = current {
                                    if node == self.petEntity {
                                        didHit = true
                                        break
                                    }
                                    current = node.parent
                                }
                                if didHit {
                                    self.triggerPetReaction()
                                }
                            }
                        }
                    }
                } catch {
                    // Ignore dropped frames.
                }
            }
        }
        
        func triggerPetReaction() {
            guard !isPetting else { return }
            isPetting = true
            lastPetTime = Date()

            guard let entity = petEntity else { return }

            if originalScale == nil {
                originalScale = entity.scale
            }
            
            guard let baseScale = originalScale else { return }

            // Scale up
            entity.scale = baseScale * reactionScaleFactor

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // Scale back down
                entity.scale = baseScale
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isPetting = false
                }
            }
        }
        
        private func checkDistance(arView: ARView, entity: ModelEntity) {
            let cameraPos = arView.cameraTransform.translation
            let entityPos = entity.position(relativeTo: nil)
            let dist = distance(cameraPos, entityPos)
            let maxDistanceMeters: Float = 4.0
            
            let tooFar = dist > maxDistanceMeters
            
            if tooFar != viewModel.isTooFar {
                DispatchQueue.main.async {
                    self.viewModel.updateDistanceStatus(isTooFar: tooFar)
                }
            }
        }
    }
}
