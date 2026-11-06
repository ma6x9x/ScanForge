import SwiftUI
import ARKit

struct ScannerView: View {
    @Binding var mode: ScanMode
    @State private var currentStage: ScanStage = .capture
    @State private var progress: Double = 0.25
    @State private var aiEnhanceEnabled = true
    @State private var aiStatus = "AI ready"
    @State private var showRefine = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    let t = timeline.date.timeIntervalSinceReferenceDate
                    for i in 0..<30 {
                        let x = size.width * 0.5 + sin(t + Double(i)) * 80
                        let y = size.height * 0.5 + cos(t * 0.7 + Double(i)) * 60
                        context.fill(
                            Path(ellipseIn: CGRect(x: x, y: y, width: 4, height: 4)),
                            with: .color(.cyan.opacity(0.4))
                        )
                    }
                }
            }
            .allowsHitTesting(false)
            
            VStack {
                GlassEffectContainer(spacing: 8) {
                    HStack(spacing: 8) {
                        ForEach(ScanStage.allCases, id: \.self) { stage in
                            Label(stage.rawValue, systemImage: stage.icon)
                                .font(.caption.weight(.semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .glassEffect(
                                    .regular.tint(currentStage == stage ? .cyan.opacity(0.5) : .clear),
                                    in: .capsule
                                )
                        }
                    }
                }
                .padding(.top, 60)
                
                Spacer()
                
                VStack(spacing: 16) {
                    Toggle(isOn: $aiEnhanceEnabled) {
                        Label(aiEnhanceEnabled ? "AI Enhance On" : "AI Enhance Off", systemImage: "wand.and.stars")
                            .font(.subheadline.weight(.semibold))
                    }
                    .toggleStyle(.button)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .glassEffect(.regular.tint(aiEnhanceEnabled ? .purple.opacity(0.4) : .clear).interactive(), in: .capsule)
                    
                    Text(aiStatus)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                    
                    Text("LiDAR Mesh Active")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    
                    ProgressView(value: progress)
                        .tint(.cyan)
                        .scaleEffect(y: 3)
                        .frame(height: 8)
                        .padding(.horizontal, 40)
                    
                    Button("Capture Frame") {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            progress = min(progress + 0.15, 1.0)
                            if progress > 0.9 { 
                                currentStage = .refine
                                showRefine = true
                            }
                        }
                    }
                    .font(.headline)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .glassEffect(.regular.tint(.cyan.opacity(0.4)).interactive(), in: .capsule)
                    .sensoryFeedback(.impact(weight: .medium), trigger: progress)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            AIEnhancer.shared.loadModel()
            aiStatus = AIEnhancer.shared.isReady ? "AI model loaded" : "Drop DepthAnything model to enable"
        }
        .navigationDestination(isPresented: $showRefine) {
            RefineView()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
