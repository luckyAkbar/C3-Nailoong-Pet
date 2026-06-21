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
        
        guard let modelURL = viewModel.pet.modelURL else {
            print("AR Error: 3D model URL is nil or file not found.")
            return arView
        }        
        
        print("AR Debug: Loading model from URL: \(modelURL)")
        
        // 3. Create an anchor for a horizontal plane
        let anchor = AnchorEntity(plane: .horizontal)
        arView.scene.anchors.append(anchor)
        
        // 4. Load the model asynchronously
        ModelEntity.loadModelAsync(contentsOf: modelURL)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("AR Error loading model \(modelURL.lastPathComponent): \(error.localizedDescription)")
                }
            }, receiveValue: { modelEntity in
                modelEntity.generateCollisionShapes(recursive: true)
                let pivot = Entity()
                anchor.addChild(pivot)
                pivot.addChild(modelEntity)
                
                context.coordinator.petEntity = modelEntity
                context.coordinator.pivotEntity = pivot
                
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
        var pivotEntity: Entity?
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
            super.init()
            
            self.viewModel.voiceTriggerEvent
                .receive(on: RunLoop.main)
                .sink { [weak self] in
                    self?.triggerVoiceReaction()
                }
                .store(in: &cancellables)
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
        
        func triggerVoiceReaction() {
            guard !isPetting else { return }
            isPetting = true
            lastPetTime = Date()
            
            // Beritahu ViewModel bahwa user berhasil memanggil nama
            DispatchQueue.main.async {
                self.viewModel.didPerformVoiceAction()
            }

            guard let pivot = pivotEntity, let arView = self.arView, let parent = pivot.parent else {
                isPetting = false
                return
            }

            let pivotPos = pivot.position(relativeTo: nil)
            var cameraPos = arView.cameraTransform.translation
            cameraPos.y = pivotPos.y

            let currentTransform = pivot.transform

            let dummy = Entity()
            parent.addChild(dummy)
            dummy.position = pivot.position
            dummy.look(at: cameraPos, from: pivotPos, relativeTo: nil, forward: .positiveZ)

            var targetTransform = currentTransform
            targetTransform.rotation = dummy.transform.rotation

            // Animate turning to face the camera
            pivot.move(to: targetTransform, relativeTo: parent, duration: 0.6, timingFunction: .easeInOut)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                // Return to original rotation
                pivot.move(to: currentTransform, relativeTo: parent, duration: 0.6, timingFunction: .easeInOut)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.isPetting = false
                    dummy.removeFromParent()
                }
            }
        }
        
        func triggerPetReaction() {
            guard !isPetting else { return }
            isPetting = true
            lastPetTime = Date()
            
            // Beritahu ViewModel bahwa user berhasil mengelus
            DispatchQueue.main.async {
                self.viewModel.didPerformPettingAction()
            }

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
