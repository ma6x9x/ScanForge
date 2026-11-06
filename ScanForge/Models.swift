import Foundation
import SwiftUI

enum ScanStage: String, CaseIterable {
    case capture = "Capture"
    case mesh = "Mesh"
    case refine = "Refine"
    case export = "Export"
    
    var icon: String {
        switch self {
        case .capture: "camera.viewfinder"
        case .mesh: "cube"
        case .refine: "wand.and.stars"
        case .export: "square.and.arrow.up"
        }
    }
}

struct ScanItem: Identifiable {
    let id = UUID()
    var name: String
    var mode: ScanMode
    var date: Date = .now
    var thumbnail: String = "cube.transparent"
}
