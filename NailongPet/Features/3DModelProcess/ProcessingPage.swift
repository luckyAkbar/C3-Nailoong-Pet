import SwiftUI

struct ProcessPage: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var manager: LidarCaptureManager
    @EnvironmentObject private var sharpViewModel: SHARPViewModel

    var generatorType: GeneratorType

    @State private var displayedProgress: Double = 10
    @State private var progressTask: Task<Void, Never>?
    @State private var didAutoAdvance = false

    private var progressPercentage: Float {
        switch generatorType {
        case .lidar:
            return manager.reconstructionProgress * 100
        case .mlSharp:
            if case .completed = sharpViewModel.state {
                return 100
            }
            return Float(displayedProgress)
        }
    }

    private var targetProgress: Double {
        switch generatorType {
        case .lidar:
            return Double(manager.reconstructionProgress * 100)
        case .mlSharp:
            switch sharpViewModel.state {
            case .idle:
                return 0
            case .processing(let progress, _):
                return min(Double(progress * 100), 99)
            case .completed:
                return 100
            case .failed:
                return displayedProgress
            }
        }
    }

    private var failureMessage: String? {
        switch generatorType {
        case .lidar:
            if case .failed(let error) = manager.state { return error.localizedDescription }
            return nil
        case .mlSharp:
            if case .failed(let message) = sharpViewModel.state { return message }
            return nil
        }
    }

    private var isCompleted: Bool {
        switch generatorType {
        case .lidar:
            if case .completed = manager.state { return true }
            return false
        case .mlSharp:
            if case .completed = sharpViewModel.state { return true }
            return false
        }
    }

    private var phaseText: String {
        switch generatorType {
        case .lidar:
            return "Processing 3D model of your pet ...."
        case .mlSharp:
            switch sharpViewModel.state {
            case .idle:
                return "Preparing Sharp model..."
            case .processing(_, let phase):
                return phase
            case .completed:
                return "Done. Preparing next step..."
            case .failed:
                return ""
            }
            return "Processing 3D model of your pet ...."
        }
    }

    var body: some View {
        ZStack {
            Color(hex: 0x3A3A3C).ignoresSafeArea()

            if let failureMessage {
                failureContent(message: failureMessage)
            } else if isCompleted {
                successContent
            } else {
                processingContent
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            startProgressAnimation()
            scheduleAutoAdvanceIfNeeded()
        }
        .onChange(of: targetProgress) { _ in
            startProgressAnimation()
        }
        .onChange(of: sharpViewModel.state) { _ in
            scheduleAutoAdvanceIfNeeded()
        }
    }

    private func startProgressAnimation() {
        progressTask?.cancel()

        progressTask = Task {
            let target = targetProgress

            if generatorType == .mlSharp && displayedProgress == 0 && target > 0 {
                await MainActor.run {
                    withAnimation(.easeOut(duration: 0.2)) {
                        displayedProgress = 1.5
                    }
                }
            }

            while !Task.isCancelled {
                let current = await MainActor.run { displayedProgress }
                let remaining = target - current

                if remaining <= 0.1 {
                    await MainActor.run {
                        withAnimation(.easeOut(duration: 0.18)) {
                            displayedProgress = target
                        }
                    }
                    break
                }

                let step = max(0.35, remaining * 0.08)
                let delay: UInt64
                switch target {
                case ..<25:
                    delay = 70_000_000
                case ..<75:
                    delay = 110_000_000
                default:
                    delay = 160_000_000
                }

                await MainActor.run {
                    withAnimation(.linear(duration: Double(delay) / 1_000_000_000)) {
                        displayedProgress = min(current + step, target)
                    }
                }

                try? await Task.sleep(nanoseconds: delay)
            }
        }
    }

    private func scheduleAutoAdvanceIfNeeded() {
        guard generatorType == .mlSharp,
              case .completed = sharpViewModel.state,
              !didAutoAdvance else { return }

        didAutoAdvance = true

        Task { @MainActor in
            withAnimation(.easeOut(duration: 0.2)) {
                displayedProgress = 100
            }
            try? await Task.sleep(nanoseconds: 650_000_000)
            router.navigate(to: .processPetDetail(.mlSharp))
        }
    }

    private var processingContent: some View {
        VStack(spacing: 32) {
            Spacer()

            ZStack {
                Image(systemName: AppIcon.pawLoading.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .foregroundStyle(.white.opacity(0.85))
                    .rotationEffect(.degrees(-20))
                    .offset(x: -35, y: -25)

                Image(systemName: AppIcon.pawLoading.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 56, height: 56)
                    .foregroundStyle(.white.opacity(0.85))
                    .rotationEffect(.degrees(10))
                    .offset(x: 25, y: 10)

                Image(systemName: AppIcon.pawLoading.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                    .foregroundStyle(.white.opacity(0.85))
                    .rotationEffect(.degrees(-5))
                    .offset(x: -8, y: 40)
            }
            .frame(width: 160, height: 160)

            Spacer()

            VStack(spacing: 8) {
                Text(phaseText)
                    .font(.title2Bold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Text("Please don't close the app while it's working")
                    .font(.subheadRegular)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)

            VStack(spacing: 8) {
                ProgressView(value: progressPercentage, total: 100)
                    .progressViewStyle(.linear)
                    .tint(Color.brandSecondary)
                    .padding(.horizontal, 40)

                Text("\(Int(progressPercentage))%")
                    .font(.footnoteRegular)
                    .foregroundStyle(Color.textSecondary)
            }

            Spacer()
        }
    }

    private var successContent: some View {
        VStack(spacing: 32) {
            Spacer()

            ZStack {
                AppIcon.moli.image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 160)

                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        .white.opacity(0.4),
                        style: StrokeStyle(lineWidth: 1.5, dash: [6, 5])
                    )
                    .frame(width: 210, height: 210)

                ScanFrame()
                    .stroke(.white.opacity(0.85), lineWidth: 3)
                    .frame(width: 210, height: 210)
            }

            Spacer()

            VStack(spacing: 8) {
                Text("3D Pet Successfully Created!")
                    .font(.title2Bold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Text("Your pet has been successfully created and ready to interact with")
                    .font(.subheadRegular)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            Button(action: { router.navigate(to: .processPetDetail(generatorType)) }) {
                Text("Next")
                    .font(.subheadRegular)
                    .foregroundStyle(.white)
                    .frame(maxWidth: 184, minHeight: 55)
                    .background(Color.scrim)
                    .clipShape(Capsule())
                    .padding(.horizontal, 40)
            }

            Spacer()
        }
    }

    private func failureContent(message: String) -> some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundStyle(.white.opacity(0.85))

            VStack(spacing: 8) {
                Text("Couldn't create the 3D model")
                    .font(.title2Bold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(.subheadRegular)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            Button(action: {
                manager.reset()
                sharpViewModel.reset()
                router.navigateToRoot()
            }) {
                Text("Back to Home")
                    .font(.subheadRegular)
                    .foregroundStyle(.white)
                    .frame(maxWidth: 184, minHeight: 55)
                    .background(Color.scrim)
                    .clipShape(Capsule())
                    .padding(.horizontal, 40)
            }

            Spacer()
        }
    }
}

struct ScanFrame: Shape {
    var cornerLength: CGFloat = 24
    var cornerRadius: CGFloat = 10

    func path(in rect: CGRect) -> Path {
        var p = Path()

        // Top-left
        p.move(to: CGPoint(x: rect.minX, y: rect.minY + cornerLength))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        p.addQuadCurve(
            to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY),
            control: CGPoint(x: rect.minX, y: rect.minY)
        )
        p.addLine(to: CGPoint(x: rect.minX + cornerLength, y: rect.minY))

        // Top-right
        p.move(to: CGPoint(x: rect.maxX - cornerLength, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        p.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius),
            control: CGPoint(x: rect.maxX, y: rect.minY)
        )
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + cornerLength))

        // Bottom-right
        p.move(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerLength))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
        p.addQuadCurve(
            to: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY),
            control: CGPoint(x: rect.maxX, y: rect.maxY)
        )
        p.addLine(to: CGPoint(x: rect.maxX - cornerLength, y: rect.maxY))

        // Bottom-left
        p.move(to: CGPoint(x: rect.minX + cornerLength, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
        p.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY - cornerRadius),
            control: CGPoint(x: rect.minX, y: rect.maxY)
        )
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - cornerLength))

        return p
    }
}

#Preview("Processing") {
    ProcessPage(generatorType: .lidar)
        .environmentObject(AppRouter())
        .environmentObject(LidarCaptureManager())
        .environmentObject(SHARPViewModel())
}
