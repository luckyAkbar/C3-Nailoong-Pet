//
//  LidarCaptureView.swift
//  NailongPet
//
//  Created by Fakhri Djamaris on 05/06/26.
//

import SwiftUI
import RealityKit

// MARK: - Screen Container
struct LidarCaptureView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var manager: LidarCaptureManager
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingInstructionSheet: Bool = false

    private let minimumShots = 20

    var body: some View {
        ZStack {
            if ObjectCaptureSession.isSupported {
                captureContent
            } else {
                UnsupportedDeviceView(onClose: closeView)
            }
        }
        .sheet(isPresented: $isShowingInstructionSheet) {
            LidarPreservedInstructionSheet()
                .presentationDetents([.fraction(0.85)])
                .presentationDragIndicator(.visible)
        }
        .toolbar(.hidden, for: .navigationBar)
        .preferredColorScheme(.dark)
        .onAppear {
            if manager.session == nil, case .notStarted = manager.state {
                manager.startSession()
            }
        }
    }

    @ViewBuilder
    private var captureContent: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                Group {
                    if let session = manager.session {
                        ObjectCaptureView(session: session)
                    } else {
                        Color.black
                    }
                }
                .ignoresSafeArea(edges: .top)

                CaptureTopBar(onClose: closeView, onTips: { isShowingInstructionSheet = true })

                if let session = manager.session {
                    VStack {
                        Spacer()
                        InstructionBubble(message: instructionMessage(for: session))
                            .padding(.bottom, 16)
                    }
                }
            }

            if let session = manager.session {
                ControlPanel(
                    isRecording: session.state == .capturing,
                    isPaused: manager.isPaused,
                    captureCount: manager.numberOfShots,
                    canFinish: manager.numberOfShots >= minimumShots,
                    thumbnail: manager.latestThumbnail,
                    onFinish: finish,
                    onShutter: { startCapturing(session) },
                    onTogglePause: togglePause
                )
            }
        }
        .background(Color.black.ignoresSafeArea())
    }

    // MARK: - Actions

    private func startCapturing(_ session: ObjectCaptureSession) {
        session.startCapturing()
    }

    private func togglePause() {
        if manager.isPaused {
            manager.resumeScanning()
        } else {
            manager.pauseScanning()
        }
    }

    private func finish() {
        manager.finishCaptureAndReconstruct()
        router.navigate(to: .processPage(GeneratorType.lidar))
    }

    private func closeView() {
        manager.reset()
        dismiss()
    }

    // MARK: - Instruction Text

    private func instructionMessage(for session: ObjectCaptureSession) -> String {
        switch session.state {
        case .initializing:
            return "Preparing camera sensors…"
        case .ready:
            return "Point your camera at your pet,\nthen tap record to begin"
        case .detecting:
            return "Aim at your pet, then tap record"
        case .capturing:
            if manager.isPaused { return "Paused. Tap play to continue" }
            if let feedback = session.feedback.first { return message(for: feedback) }
            if manager.numberOfShots < minimumShots { return "Move slowly around your pet" }
            return "Great! Tap Finish when you're ready"
        default:
            return ""
        }
    }

    private func message(for feedback: ObjectCaptureSession.Feedback) -> String {
        switch feedback {
        case .objectTooFar:        return "Move closer to your pet"
        case .objectTooClose:      return "Move back a little"
        case .movingTooFast:       return "Slow down your movement"
        case .environmentTooDark:  return "Too dark — add more light"
        case .outOfFieldOfView:    return "Keep your pet centered"
        default:                   return "Move slowly around your pet"
        }
    }
}

// MARK: - Private Sub-views

private struct CaptureTopBar: View {
    var onClose: () -> Void = {}
    var onTips: () -> Void = {}

    var body: some View {
        HStack {
            CircularIconButton(icon: .close, action: onClose)
            Spacer()
            TipsButton(action: onTips)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
}

private struct InstructionBubble: View {
    var message: String

    var body: some View {
        Text(message)
            .font(.subheadRegular)
            .foregroundColor(.blackPrimaryText)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.whitePrimarySurface.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small.value))
            .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
    }
}

private struct ControlPanel: View {
    var isRecording: Bool = false
    var isPaused: Bool = false
    var captureCount: Int = 0
    var canFinish: Bool = false
    var thumbnail: UIImage? = nil
    var onFinish: () -> Void = {}
    var onShutter: () -> Void = {}
    var onTogglePause: () -> Void = {}

    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: 0) {
                FinishButton(isEnabled: canFinish, action: onFinish)

                Spacer()

                if isRecording {
                    RecordPauseButton(isPaused: isPaused, action: onTogglePause)
                } else {
                    ShutterButton(action: onShutter)
                }

                Spacer()

                CaptureThumbnail(image: isRecording ? thumbnail : nil)
                    .frame(width: 85, alignment: .trailing)
            }
            .padding(.horizontal, 24)

            if isRecording {
                ScanProgressSlider(captureCount: captureCount)
                    .padding(.horizontal, 24)
            }
        }
        .padding(.vertical, 28)
        .background(Color.blackSecondarySurface.opacity(0.4))
    }
}

private struct FinishButton: View {
    var isEnabled: Bool = false
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Text("Finish")
                .font(.subheadRegular)
                .foregroundColor(isEnabled ? .whitePrimarySurface : .blackPrimaryText)
                .frame(width: 85, height: 44)
                .background(
                    isEnabled
                    ? Color.greenSucceedAction
                    : Color.grayDisabledAction.opacity(0.5)
                )
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.full.value))
        }
        .disabled(!isEnabled)
    }
}

private struct ShutterButton: View {
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .stroke(Color.whitePrimarySurface, lineWidth: 4)
                    .frame(width: 72, height: 72)
                Circle()
                    .fill(Color.whitePrimarySurface)
                    .frame(width: 58, height: 58)
            }
        }
        .contentShape(Circle())
    }
}

private struct RecordPauseButton: View {
    var isPaused: Bool = false
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.whitePrimarySurface)
                    .frame(width: 72, height: 72)
                Image(systemName: isPaused ? "play.fill" : "pause.fill")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.blackPrimaryText)
            }
        }
        .contentShape(Circle())
    }
}

private struct CaptureThumbnail: View {
    var image: UIImage?

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48, height: 48)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small.value))
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.small.value)
                            .stroke(Color.whitePrimarySurface.opacity(0.4), lineWidth: 1)
                    )
            } else {
                Color.clear.frame(width: 48, height: 48)
            }
        }
    }
}

private struct ScanProgressSlider: View {
    var captureCount: Int = 0

    private let minCount = 20
    private let maxCount = 100

    private var progress: Double {
        guard maxCount > 0 else { return 0 }
        return Double(min(captureCount, maxCount)) / Double(maxCount)
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.whitePrimarySurface.opacity(0.3))
                            .frame(height: 6)
                        Capsule()
                            .fill(Color.whitePrimarySurface)
                            .frame(width: geometry.size.width * progress, height: 6)
                    }
                }
                .frame(height: 6)

                Text("\(captureCount)")
                    .font(.title2Bold)
                    .foregroundColor(.whitePrimarySurface)
                    .frame(minWidth: 36, alignment: .trailing)
                    .monospacedDigit()
            }

            HStack {
                Text("\(minCount) (min)")
                Spacer()
                Text("\(maxCount) (max)")
            }
            .font(.footnoteRegular)
            .foregroundColor(.whitePrimarySurface.opacity(0.8))
        }
    }
}

private struct UnsupportedDeviceView: View {
    var onClose: () -> Void = {}

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "camera.metering.unknown")
                    .font(.system(size: 48))
                    .foregroundColor(.whitePrimarySurface.opacity(0.85))

                Text("LiDAR scan isn't available on this device")
                    .font(.title2Bold)
                    .foregroundColor(.whitePrimarySurface)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Text("3D object capture needs a LiDAR Scanner, found on iPhone Pro and iPad Pro models. Try creating your pet from photos instead.")
                    .font(.subheadRegular)
                    .foregroundColor(.whitePrimarySurface.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Button(action: onClose) {
                    Text("Choose another method")
                        .font(.subheadRegular)
                        .foregroundColor(.whitePrimarySurface)
                        .frame(maxWidth: 260)
                        .frame(height: 50)
                        .background(Color.orangePrimaryBrand)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.full.value))
                }
                .padding(.top, 8)
            }
        }
    }
}
