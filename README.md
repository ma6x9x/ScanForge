# ScanForge

**Ultimate 3D Scanning & Printing Companion** for iPhone Pro models.

Built with modern SwiftUI, Liquid Glass, PhaseAnimator/KeyframeAnimator, and full utilization of Pro features (LiDAR, high-res cameras, ProMotion).

## On-Device AI Enhancement
Small open-weight models via Core ML improve scan quality:
- **Depth Anything 3 Small** (~44 MB, Apache-2.0) or **Depth Anything V2 Small** — fill LiDAR holes, sharpen edges, correct low-confidence regions.
- Optional lightweight denoise / super-res pass.

Drop the compiled `.mlpackage` into the Xcode target. `AIEnhancer` loads it automatically. Fusion prefers LiDAR where confident and uses AI depth for gaps.

## Features
- Real-time LiDAR mesh scanning (ARKit scene reconstruction)
- RoomPlan structured room capture
- Object Capture / photogrammetry support
- AI refinement stage (Core ML)
- Export to OBJ, STL, USDZ, PLY for 3D printing & CAD
- AR preview of scans with particle effects & bioluminescent theme
- Sequential stage animations, haptics, micro-interactions
- Modern design: Liquid Glass controls, 4/8pt grid, semantic colors, accessibility

## Requirements
- iPhone 12 Pro or later (LiDAR)
- iOS 18+
- Xcode 16+

## Build IPA via GitHub Actions
Push to `main` triggers `.github/workflows/build-ipa.yml`. Download the unsigned IPA artifact and sideload.

See source for full implementation following swiftui-ui-master skill principles.
