import SwiftUI

struct ProcessPage: View {
    @EnvironmentObject private var router: AppRouter
    @State private var progressPercentage: Float = 0

    var body: some View {
        ZStack {
            Color(hex: 0x3A3A3C).ignoresSafeArea()

            if progressPercentage < 100 {
                processingContent
            } else {
                successContent
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .task {
            while progressPercentage < 100 {
                try? await Task.sleep(for: .milliseconds(50))
                withAnimation(.linear(duration: 0.05)) {
                    progressPercentage = min(progressPercentage + 2, 100)
                }
            }
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
                Text("Processing 3D model of your pet ....")
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

            Button(action: { router.navigate(to: .processPetDetail) }) {
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
    ProcessPage()
        .environmentObject(AppRouter())
}

#Preview("Success") {
    ProcessPage()
        .environmentObject(AppRouter())
}
