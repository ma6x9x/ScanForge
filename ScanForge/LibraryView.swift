import SwiftUI

struct LibraryView: View {
    @State private var scans: [ScanItem] = [
        ScanItem(name: "Living Room", mode: .room),
        ScanItem(name: "Desk Object", mode: .object),
        ScanItem(name: "Full Mesh", mode: .lidar)
    ]
    
    var body: some View {
        NavigationStack {
            List(scans) { scan in
                HStack(spacing: 16) {
                    Image(systemName: scan.thumbnail)
                        .font(.title2)
                        .frame(width: 44, height: 44)
                        .background(.ultraThinMaterial, in: Circle())
                    VStack(alignment: .leading) {
                        Text(scan.name).font(.headline)
                        Text(scan.mode.rawValue).font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(scan.date, style: .relative).font(.caption2).foregroundStyle(.tertiary)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Scans")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("New", systemImage: "plus") { }
                        .glassEffect(.regular.interactive(), in: .capsule)
                }
            }
        }
    }
}
