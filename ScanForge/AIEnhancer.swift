import Foundation
import CoreML
import Vision
import SwiftUI

/// On-device AI enhancement for scan quality.
/// Drop a compiled .mlpackage (e.g. DepthAnythingV3_small_504.mlpackage) into the target.
/// Recommended models (Apache-2.0 / small):
/// - Depth Anything 3 Small (~44 MB) — best current open option
/// - Depth Anything V2 Small (~50 MB) — Apple has official Core ML builds
///
/// Fusion strategy (implemented in ScanSession):
/// 1. LiDAR depth is primary (metric, high confidence).
/// 2. AI monocular depth fills holes + refines edges where LiDAR confidence is low.
/// 3. Optional lightweight denoise pass before mesh export.
final class AIEnhancer {
    static let shared = AIEnhancer()
    
    private var depthModel: MLModel?
    private var isLoaded = false
    
    func loadModel(named name: String = "DepthAnythingV3_small_504") {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mlmodelc") ??
                       Bundle.main.url(forResource: name, withExtension: "mlpackage") else {
            print("AI model not found — add .mlpackage to target")
            return
        }
        do {
            let config = MLModelConfiguration()
            config.computeUnits = .all
            depthModel = try MLModel(contentsOf: url, configuration: config)
            isLoaded = true
            print("AI depth model loaded")
        } catch {
            print("Failed to load AI model: \(error)")
        }
    }
    
    /// Run monocular depth on a keyframe image.
    /// Returns relative depth map (you scale/align to LiDAR).
    func enhanceDepth(from image: CGImage, completion: @escaping (CVPixelBuffer?) -> Void) {
        guard isLoaded, let model = depthModel else {
            completion(nil)
            return
        }
        // Vision request wrapper (adapt input name to your model)
        let request = VNCoreMLRequest(model: try! VNCoreMLModel(for: model)) { request, error in
            guard let results = request.results as? [VNPixelBufferObservation],
                  let buffer = results.first?.pixelBuffer else {
                completion(nil)
                return
            }
            completion(buffer)
        }
        request.imageCropAndScaleOption = .scaleFill
        
        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }
    
    var isReady: Bool { isLoaded }
}
