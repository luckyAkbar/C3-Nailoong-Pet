//
//  LidarCaptureView.swift
//  NailongPet
//
//  Created by Fakhri Djamaris on 05/06/26.
//

import SwiftUI

// MARK: - Screen Container

struct LidarCaptureView: View {
    @EnvironmentObject private var router: AppRouter
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingInstructionSheet: Bool = true
    @State private var captureState: LidarCaptureState = .idle
    @State private var captureCount: Int = 0

    // Tombol Finish aktif setelah minimal 20 foto
    private var canFinish: Bool { captureCount >= 20 }

    // Pesan instruksi berubah mengikuti kondisi
    private var instructionMessage: String {
        switch captureState {
        case .idle:
            return "Point your camera at your pet,\nthen tap record to begin"
        case .recording:
            if captureCount < 20 { return "Move slowly around your pet" }
            else { return "Great! Tap Finish when you're ready" }
        }
    }

    var body: some View {
        LidarCaptureContent(
            state: captureState,
            instructionMessage: instructionMessage,
            captureCount: captureCount,
            canFinish: canFinish,
            onClose: { dismiss() },
            onTips: { isShowingInstructionSheet = true },
            onFinish: { router.navigate(to: .processPage) },
            onShutter: {
                // Tap shutter → mulai recording
                withAnimation { captureState = .recording }
            },
            onRecordPause: {
                // Tap pause → kembali idle, reset count
                withAnimation { captureState = .idle }
                captureCount = 0
            }
        )
        .sheet(isPresented: $isShowingInstructionSheet) {
            LidarPreservedInstructionSheet()
                .presentationDetents([.fraction(0.85)])
                .presentationDragIndicator(.visible)
        }
        .toolbar(.hidden, for: .navigationBar)
        // Simulasi auto-capture saat recording — dibatalkan otomatis saat state berubah
        .task(id: captureState) {
            guard captureState == .recording else { return }
            while captureState == .recording && captureCount < 100 {
                try? await Task.sleep(for: .milliseconds(150))
                withAnimation {
                    captureCount = min(captureCount + 1, 100)
                }
            }
        }
    }
}

// MARK: - Screen Content (presentational)

struct LidarCaptureContent: View {
    var state: LidarCaptureState = .idle
    var instructionMessage: String = ""
    var captureCount: Int = 0
    var canFinish: Bool = false
    var thumbnailImageName: String? = "Moli"
    var onClose: () -> Void = {}
    var onTips: () -> Void = {}
    var onFinish: () -> Void = {}
    var onShutter: () -> Void = {}
    var onRecordPause: () -> Void = {}

    var body: some View {
        ZStack {
            // Live kamera feed sebagai background
            CameraLivePreview()
                .ignoresSafeArea()

            // Overlay scanning effect (grid + scan line + brackets)
            LidarScanOverlay(
                captureCount: captureCount,
                isScanning: state == .recording
            )
            .ignoresSafeArea()

            // UI controls di atas kamera
            VStack {
                CaptureTopBar(onClose: onClose, onTips: onTips)

                Spacer()

                InstructionBubble(message: instructionMessage)
                    .padding(.bottom, 24)

                ControlPanel(
                    state: state,
                    captureCount: captureCount,
                    canFinish: canFinish,
                    thumbnailImageName: thumbnailImageName,
                    onFinish: onFinish,
                    onShutter: onShutter,
                    onRecordPause: onRecordPause
                )
            }
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
    var state: LidarCaptureState = .idle
    var captureCount: Int = 0
    var canFinish: Bool = false
    var thumbnailImageName: String? = nil
    var onFinish: () -> Void = {}
    var onShutter: () -> Void = {}
    var onRecordPause: () -> Void = {}

    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: 0) {
                FinishButton(isEnabled: canFinish, action: onFinish)

                Spacer()

                switch state {
                case .idle:      ShutterButton(action: onShutter)
                case .recording: RecordPauseButton(action: onRecordPause)
                }

                Spacer()

                CaptureThumbnail(imageName: state == .recording ? thumbnailImageName : nil)
                    .frame(width: 85, alignment: .trailing)
            }
            .padding(.horizontal, 24)

            if state == .recording {
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
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            AppIcon.recordingPause.image
                .font(.system(size: 72, weight: .thin))
                .foregroundColor(.whitePrimarySurface)
        }
        .contentShape(Circle())
    }
}

private struct CaptureThumbnail: View {
    var imageName: String?

    var body: some View {
        Group {
            if let name = imageName {
                Image(name)
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

// MARK: - Previews

#Preview("Screen + Sheet") {
    LidarCaptureView()
}

#Preview("Idle") {
    LidarCaptureContent(
        state: .idle,
        instructionMessage: "Point your camera at your pet,\nthen tap record to begin"
    )
}

#Preview("Need more light") {
    LidarCaptureContent(
        state: .recording,
        instructionMessage: "Need more light",
        captureCount: 12
    )
}

#Preview("Recording") {
    LidarCaptureContent(
        state: .recording,
        instructionMessage: "Move slowly around your pet",
        captureCount: 45
    )
}

#Preview("Recording • Finish Enabled") {
    LidarCaptureContent(
        state: .recording,
        instructionMessage: "A bit slower …",
        captureCount: 85,
        canFinish: true
    )
}
