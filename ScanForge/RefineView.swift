import SwiftUI

struct RefineView: View {
    @State private var aiApplied = false
    @State private var isSelectingArea = false
    @State private var status = "Post-scan ready"
    @State private var showRevertConfirm = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("Refine")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                Text(status)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                
                // Preview area (would show mesh / depth)
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .frame(height: 280)
                    .overlay {
                        VStack {
                            Image(systemName: "cube.transparent")
                                .font(.system(size: 60))
                                .foregroundStyle(.cyan)
                            Text(aiApplied ? "AI Enhanced" : "Original LiDAR")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .overlay(alignment: .topTrailing) {
                        if isSelectingArea {
                            Text("Draw to select areas")
                                .font(.caption2)
                                .padding(8)
                                .background(.black.opacity(0.6), in: Capsule())
                                .padding()
                        }
                    }
                
                // AI Correct button
                Button {
                    withAnimation(.spring) {
                        aiApplied = true
                        status = "AI Correct applied to full scan"
                        // Real: AIEnhancer.shared.enhanceDepth(...)
                    }
                } label: {
                    Label("AI Correct", systemImage: "wand.and.stars")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .glassEffect(.regular.tint(.purple.opacity(0.45)).interactive(), in: .capsule)
                .disabled(aiApplied)
                
                HStack(spacing: 16) {
                    // Selective area
                    Button {
                        isSelectingArea.toggle()
                        status = isSelectingArea ? "Draw on preview to select regions" : "Selection cancelled"
                    } label: {
                        Label(isSelectingArea ? "Done Selecting" : "Select Areas", systemImage: "lasso")
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                    .glassEffect(.regular.tint(isSelectingArea ? .cyan.opacity(0.4) : .clear).interactive(), in: .capsule)
                    
                    // Revert
                    Button {
                        showRevertConfirm = true
                    } label: {
                        Label("Revert", systemImage: "arrow.uturn.backward")
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                    .glassEffect(.regular.tint(.orange.opacity(0.4)).interactive(), in: .capsule)
                    .disabled(!aiApplied)
                }
                
                if isSelectingArea {
                    Button("Apply AI to Selected Areas") {
                        withAnimation {
                            aiApplied = true
                            isSelectingArea = false
                            status = "AI applied only to selected regions"
                            // Real: AIEnhancer.shared.applySelective(mask: ...)
                        }
                    }
                    .font(.headline)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .glassEffect(.regular.tint(.cyan.opacity(0.5)).interactive(), in: .capsule)
                }
                
                Spacer()
            }
            .padding()
        }
        .alert("Revert AI Enhancement?", isPresented: $showRevertConfirm) {
            Button("Revert", role: .destructive) {
                aiApplied = false
                status = "Reverted to original LiDAR"
                AIEnhancer.shared.revert()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This restores the original scan before any AI correction.")
        }
        .navigationTitle("Refine")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    RefineView()
}
