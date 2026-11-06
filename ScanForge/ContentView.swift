import SwiftUI

enum ScanMode: String, CaseIterable, Identifiable {
    case lidar = "LiDAR Mesh"
    case room = "RoomPlan"
    case object = "Object Capture"
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .lidar: "sensor.tag.radiowaves.forward"
        case .room: "square.3.layers.3d"
        case .object: "cube.transparent"
        }
    }
}

struct ContentView: View {
    @State private var selectedMode: ScanMode = .lidar
    @State private var isScanning = false
    @State private var scanProgress: Double = 0
    @Namespace private var ns

    var body: some View {
        NavigationStack {
            ZStack {
                // Bioluminescent gradient background
                LinearGradient(
                    colors: [.black, .indigo.opacity(0.6), .cyan.opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 24) {
                    Text("ScanForge")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)

                    // Mode selector with glass
                    GlassEffectContainer(spacing: 12) {
                        HStack(spacing: 12) {
                            ForEach(ScanMode.allCases) { mode in
                                Button {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                        selectedMode = mode
                                    }
                                } label: {
                                    Label(mode.rawValue, systemImage: mode.icon)
                                        .font(.subheadline.weight(.semibold))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                }
                                .glassEffect(
                                    .regular.tint(selectedMode == mode ? .cyan.opacity(0.4) : .clear).interactive(),
                                    in: .capsule
                                )
                                .matchedGeometryEffect(id: mode.id, in: ns)
                            }
                        }
                    }
                    .padding(.horizontal)

                    Spacer()

                    // Scan stage indicator
                    VStack(spacing: 16) {
                        Text(isScanning ? "Scanning..." : "Ready to Capture")
                            .font(.headline)
                            .foregroundStyle(.white.opacity(0.8))

                        ProgressView(value: scanProgress)
                            .progressViewStyle(.linear)
                            .tint(.cyan)
                            .scaleEffect(y: 2)
                            .animation(.spring, value: scanProgress)

                        Button(isScanning ? "Stop" : "Start Scan") {
                            withAnimation(.spring) {
                                isScanning.toggle()
                                if isScanning {
                                    // Simulate progress for demo; real ARSession would drive this
                                    scanProgress = 0
                                    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { t in
                                        scanProgress = min(scanProgress + 0.02, 1.0)
                                        if scanProgress >= 1.0 { t.invalidate() }
                                    }
                                } else {
                                    scanProgress = 0
                                }
                            }
                        }
                        .font(.title3.weight(.semibold))
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .glassEffect(.regular.tint(.cyan.opacity(0.3)).interactive(), in: .capsule)
                        .sensoryFeedback(.impact, trigger: isScanning)
                    }
                    .padding()

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
