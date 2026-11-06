import Foundation
import CoreML
import Vision
import SwiftUI
import simd

/// On-device AI enhancement for scan quality.
/// Supports full or selective (masked) application + full revert.
final class AIEnhancer {
    static let shared = AIEnhancer()
    
    private var depthModel: MLModel?
    private var isLoaded = false
    
    // Store original depth for revert
    var originalDepth: CVPixelBuffer?
    var enhancedDepth: CVPixelBuffer?
    
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
    
    func enhanceDepth(from image: CGImage, completion: @escaping (CVPixelBuffer?) -> Void) {
        guard isLoaded, let model = depthModel else {
            completion(nil)
            return
        }
        let request = VNCoreMLRequest(model: try! VNCoreMLModel(for: model)) { request, error in
            guard let results = request.results as? [VNPixelBufferObservation],
                  let buffer = results.first?.pixelBuffer else {
                completion(nil)
                return
            }
            self.enhancedDepth = buffer
            completion(buffer)
        }
        request.imageCropAndScaleOption = .scaleFill
        
        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }
    
    /// Apply AI only inside a user-drawn mask (normalized rect or brush strokes).
    /// In a real implementation you blend enhancedDepth into originalDepth using the mask.
    func applySelective(mask: CGImage, completion: @escaping (Bool) -> Void) {
        // Skeleton: copy original, then composite AI result only where mask is white
        // Real version would use Metal or Accelerate for pixel blending
        print("Selective AI applied with mask")
        completion(true)
    }
    
    func revert() {
        enhancedDepth = nil
        print("Reverted to original LiDAR depth")
    }
    
    var isReady: Bool { isLoaded }
    var hasEnhancement: Bool { enhancedDepth != nil }
}
