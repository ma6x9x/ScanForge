import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem { Label("Home", systemImage: "view.3d") }
                .tag(0)
            LibraryView()
                .tabItem { Label("Library", systemImage: "square.stack.3d.up") }
                .tag(1)
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear") }
                .tag(2)
        }
        .tint(.cyan)
    }
}

struct HomeView: View {
    @State private var selectedMode: ScanMode = .lidar
    @State private var showScanner = false
    @Namespace private var ns
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.black, .indigo.opacity(0.7), .cyan.opacity(0.2)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    VStack(spacing: 8) {
                        Image(systemName: "view.3d")
                            .font(.system(size: 56, weight: .ultraLight))
                            .foregroundStyle(.cyan)
                            .symbolEffect(.pulse, options: .repeating)
                        Text("ScanForge")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.white)
                        Text("Pro 3D Scanning & Printing")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    .padding(.top, 40)
                    
                    GlassEffectContainer(spacing: 16) {
                        VStack(spacing: 12) {
                            ForEach(ScanMode.allCases) { mode in
                                Button {
                                    selectedMode = mode
                                    showScanner = true
                                } label: {
                                    HStack {
                                        Image(systemName: mode.icon)
                                            .font(.title2)
                                            .frame(width: 36)
                                        VStack(alignment: .leading) {
                                            Text(mode.rawValue).font(.headline)
                                            Text("Start capture").font(.caption).foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                    }
                                    .padding()
                                }
                                .glassEffect(.regular.tint(selectedMode == mode ? .cyan.opacity(0.3) : .clear).interactive(), in: .rect(cornerRadius: 16))
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $showScanner) {
                ScannerView(mode: $selectedMode)
            }
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            Form {
                Section("Export") {
                    Label("OBJ / STL / USDZ", systemImage: "square.and.arrow.up")
                    Label("Auto-optimize for print", systemImage: "printer")
                }
                Section("Pro Features") {
                    Label("LiDAR scene reconstruction", systemImage: "sensor.tag.radiowaves.forward")
                    Label("RoomPlan structured capture", systemImage: "square.3.layers.3d")
                    Label("Object Capture photogrammetry", systemImage: "cube.transparent")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    ContentView()
}
