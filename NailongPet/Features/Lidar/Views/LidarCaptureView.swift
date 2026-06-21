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
            LidarScanningInstructionSheet()
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

                if let session = manager.session, session.state == .capturing {
                    VStack {
                        ScanConditionsHUD(feedback: manager.currentFeedback)
                            .padding(.top, 80)
                        Spacer()
                        InstructionBubble(message: instructionMessage(for: session))
                            .padding(.bottom, 16)
                    }
                } else if let session = manager.session {
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
            return "Point your camera at your pet,\nthen tap the record button to begin"
        case .detecting:
            return "Frame your pet, then tap record to start"
        case .capturing:
            if manager.isPaused { return "Paused — tap play to continue" }
            if let feedback = session.feedback.first { return message(for: feedback) }
            if manager.numberOfShots < minimumShots {
                return "Walk slowly in a full circle around your pet\n(don't stay still — keep moving!)"
            }
            return "Keep circling until you're happy,\nthen tap Finish"
        default:
            return ""
        }
    }

    private func message(for feedback: ObjectCaptureSession.Feedback) -> String {
        switch feedback {
        case .objectTooFar:        return "Move a little closer to your pet"
        case .objectTooClose:      return "Step back a bit"
        case .movingTooFast:       return "Slow down — move gradually"
        case .environmentTooDark:  return "Too dark — move to a brighter spot"
        case .outOfFieldOfView:    return "Keep your pet in the center of the frame"
        default:                   return "Keep walking slowly around your pet"
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
        VStack(spacing: 4) {
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
            if image != nil {
                Text("Last shot")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.whitePrimarySurface.opacity(0.6))
            }
        }
        .allowsHitTesting(false)
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

    private var hasReachedMinimum: Bool { captureCount >= minCount }

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text("Scan Progress")
                    .font(.footnoteRegular)
                    .foregroundColor(.whitePrimarySurface.opacity(0.7))
                Spacer()
                HStack(spacing: 4) {
                    Text("\(captureCount)")
                        .font(.title2Bold)
                        .foregroundColor(.whitePrimarySurface)
                        .monospacedDigit()
                    Text("shots")
                        .font(.footnoteRegular)
                        .foregroundColor(.whitePrimarySurface.opacity(0.7))
                }
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.whitePrimarySurface.opacity(0.3))
                        .frame(height: 6)
                    Capsule()
                        .fill(hasReachedMinimum ? Color.greenSucceedAction : Color.whitePrimarySurface)
                        .frame(width: geometry.size.width * progress, height: 6)
                        .animation(.easeOut(duration: 0.2), value: progress)

                    let minMarkerX = geometry.size.width * (Double(minCount) / Double(maxCount))
                    Rectangle()
                        .fill(Color.whitePrimarySurface)
                        .frame(width: 2, height: 10)
                        .offset(x: minMarkerX - 1, y: -2)
                }
            }
            .frame(height: 6)

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Minimum \(minCount) shots")
                        .foregroundColor(hasReachedMinimum ? Color.greenSucceedAction : .whitePrimarySurface.opacity(0.8))
                }
                Spacer()
                Text("Maximum \(maxCount) shots")
                    .foregroundColor(.whitePrimarySurface.opacity(0.5))
            }
            .font(.system(size: 11, weight: .regular))
        }
    }
}

private struct ScanConditionsHUD: View {
    var feedback: Set<ObjectCaptureSession.Feedback>

    private var distanceStatus: ConditionStatus {
        if feedback.contains(.objectTooClose) { return .bad("Too close") }
        if feedback.contains(.objectTooFar)   { return .bad("Too far") }
        return .good("Good distance")
    }

    private var lightStatus: ConditionStatus {
        if feedback.contains(.environmentTooDark) { return .bad("Too dark") }
        return .good("Good light")
    }

    var body: some View {
        HStack(spacing: 8) {
            ConditionChip(icon: "arrow.up.and.down", status: distanceStatus)
            ConditionChip(icon: "sun.max.fill", status: lightStatus)
        }
    }
}

private enum ConditionStatus {
    case good(String)
    case bad(String)

    var label: String {
        switch self { case .good(let l), .bad(let l): return l }
    }

    var isOK: Bool {
        if case .good = self { return true }
        return false
    }
}

private struct ConditionChip: View {
    var icon: String
    var status: ConditionStatus

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .semibold))
            Text(status.label)
                .font(.system(size: 12, weight: .medium))
        }
        .foregroundColor(status.isOK ? Color.greenSucceedAction : Color.orangePrimaryBrand)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Color.black.opacity(0.55)
                .clipShape(Capsule())
        )
        .overlay(
            Capsule()
                .stroke(
                    status.isOK ? Color.greenSucceedAction.opacity(0.6) : Color.orangePrimaryBrand.opacity(0.6),
                    lineWidth: 1
                )
        )
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
