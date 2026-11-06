import SwiftUI
import ARKit

struct ScannerView: View {
    @Binding var mode: ScanMode
    @State private var currentStage: ScanStage = .capture
    @State private var progress: Double = 0.25
    @Namespace private var ns
    
    var body: some View {
        ZStack {
            // Simulated AR background
            Color.black.ignoresSafeArea()
            
            // Particle glow overlay (bioluminescent)
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
                // Stage pills
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
                                .phaseAnimator([0, 1], trigger: currentStage) { content, phase in
                                    content.scaleEffect(phase == 1 && currentStage == stage ? 1.05 : 1)
                                }
                        }
                    }
                }
                .padding(.top, 60)
                
                Spacer()
                
                VStack(spacing: 20) {
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
                            if progress > 0.9 { currentStage = .mesh }
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
        .navigationBarTitleDisplayMode(.inline)
    }
}
