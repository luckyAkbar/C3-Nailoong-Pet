//
//  CameraLivePreview.swift
//  NailongPet
//
//  Created by Fakhri Djamaris on 09/06/26.
//

import SwiftUI
import AVFoundation

// MARK: - Live Camera Preview (UIViewRepresentable)

/// Menampilkan live feed kamera belakang menggunakan AVCaptureVideoPreviewLayer.
/// Hanya preview — tidak ada LiDAR scanning atau pemrosesan frame.
struct CameraLivePreview: UIViewRepresentable {

    // MARK: - UIView wrapper

    final class _PreviewView: UIView {
        override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
        var previewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
    }

    // MARK: - Shared session (satu per instance view)

    private let session = AVCaptureSession()

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> _PreviewView {
        let view = _PreviewView()
        view.previewLayer.videoGravity = .resizeAspectFill
        view.previewLayer.session     = session

        Task.detached(priority: .userInitiated) {
            await Self.startSession(session)
        }

        return view
    }

    func updateUIView(_ uiView: _PreviewView, context: Context) {}

    static func dismantleUIView(_ uiView: _PreviewView, coordinator: ()) {
        uiView.previewLayer.session?.stopRunning()
    }

    // MARK: - Private helpers

    private static func startSession(_ session: AVCaptureSession) async {
        // Minta akses kamera jika belum ada
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .notDetermined {
            guard await AVCaptureDevice.requestAccess(for: .video) else { return }
        }
        guard AVCaptureDevice.authorizationStatus(for: .video) == .authorized else { return }

        // Konfigurasi session
        session.beginConfiguration()
        session.sessionPreset = .high

        if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                for: .video,
                                                position: .back),
           let input = try? AVCaptureDeviceInput(device: device),
           session.canAddInput(input) {
            session.addInput(input)
        }

        session.commitConfiguration()
        session.startRunning()
    }
}

// MARK: - LiDAR Scan Overlay

/// Overlay visual di atas live preview — mensimulasikan tampilan scanning LiDAR.
/// Murni dekoratif, tidak ada data depth nyata.
struct LidarScanOverlay: View {
    var captureCount: Int = 0
    var isScanning: Bool = false

    @State private var scanLineOffset: CGFloat = -1
    @State private var pulseScale: CGFloat = 1.0
    @State private var gridOpacity: Double = 0.0

    private var progress: CGFloat {
        CGFloat(min(captureCount, 100)) / 100.0
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Grid mesh — muncul saat scanning
                if isScanning {
                    ScanGridMesh()
                        .opacity(gridOpacity)
                }

                // Scan line — bergerak dari atas ke bawah
                if isScanning {
                    ScanLine(width: geo.size.width)
                        .offset(y: scanLineOffset * geo.size.height)
                }

                // Corner brackets — selalu tampil
                CornerBrackets()
                    .padding(32)

                // Progress arc — tampil saat scanning
                if isScanning {
                    ScanProgressArc(progress: progress)
                        .frame(width: 72, height: 72)
                        .scaleEffect(pulseScale)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
        }
        .onChange(of: isScanning) { _, scanning in
            if scanning {
                startAnimations()
            } else {
                stopAnimations()
            }
        }
        .onAppear {
            if isScanning { startAnimations() }
        }
    }

    // MARK: - Animation control

    private func startAnimations() {
        withAnimation(.easeIn(duration: 0.3)) { gridOpacity = 0.35 }

        withAnimation(
            .linear(duration: 2.4)
            .repeatForever(autoreverses: true)
        ) {
            scanLineOffset = 1
        }

        withAnimation(
            .easeInOut(duration: 1.2)
            .repeatForever(autoreverses: true)
        ) {
            pulseScale = 1.08
        }
    }

    private func stopAnimations() {
        withAnimation(.easeOut(duration: 0.2)) { gridOpacity = 0 }
        scanLineOffset = -1
        pulseScale    = 1.0
    }
}

// MARK: - Sub-views

private struct ScanGridMesh: View {
    private let columns = 8
    private let rows    = 14

    var body: some View {
        GeometryReader { geo in
            let cw = geo.size.width  / CGFloat(columns)
            let rh = geo.size.height / CGFloat(rows)

            ZStack {
                // Vertical lines
                ForEach(0...columns, id: \.self) { col in
                    Rectangle()
                        .fill(Color.cyan.opacity(0.5))
                        .frame(width: 0.5, height: geo.size.height)
                        .offset(x: CGFloat(col) * cw - geo.size.width / 2)
                }
                // Horizontal lines
                ForEach(0...rows, id: \.self) { row in
                    Rectangle()
                        .fill(Color.cyan.opacity(0.5))
                        .frame(width: geo.size.width, height: 0.5)
                        .offset(y: CGFloat(row) * rh - geo.size.height / 2)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

private struct ScanLine: View {
    var width: CGFloat

    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        Color.cyan.opacity(0),
                        Color.cyan.opacity(0.9),
                        Color.cyan.opacity(0)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: width, height: 2)
            .shadow(color: Color.cyan.opacity(0.8), radius: 6, x: 0, y: 0)
    }
}

private struct CornerBrackets: View {
    private let length: CGFloat = 28
    private let thickness: CGFloat = 3
    private let color = Color.white.opacity(0.85)

    var body: some View {
        ZStack {
            // Top-left
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    bracket(rotation: 0); Spacer()
                    bracket(rotation: 90)
                }
                Spacer()
                HStack(spacing: 0) {
                    bracket(rotation: 270); Spacer()
                    bracket(rotation: 180)
                }
            }
        }
    }

    private func bracket(rotation: Double) -> some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(color)
                .frame(width: length, height: thickness)
            Rectangle()
                .fill(color)
                .frame(width: thickness, height: length)
        }
        .rotationEffect(.degrees(rotation))
    }
}

private struct ScanProgressArc: View {
    var progress: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.15), lineWidth: 3)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.cyan, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}
