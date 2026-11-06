# ScanForge

**Ultimate 3D Scanning & Printing Companion** for iPhone Pro models.

Built with modern SwiftUI, Liquid Glass, PhaseAnimator/KeyframeAnimator, and full utilization of Pro features (LiDAR, high-res cameras, ProMotion).

## Features
- Real-time LiDAR mesh scanning (ARKit scene reconstruction)
- RoomPlan structured room capture
- Object Capture / photogrammetry support
- Export to OBJ, STL, USDZ, PLY for 3D printing & CAD
- AR preview of scans with particle effects & bioluminescent theme
- Sequential stage animations, haptics, micro-interactions
- Modern design: Liquid Glass controls, 4/8pt grid, semantic colors, accessibility

## Requirements
- iPhone 12 Pro or later (LiDAR)
- iOS 18+
- Xcode 16+

## Build IPA via GitHub Actions
Push to `main` triggers `.github/workflows/build-ipa.yml`. Download the unsigned IPA artifact and sideload (AltStore, SideStore, TrollStore, or developer signing).

## Creative Touches
- Bioluminescent particle system during scanning
- Spring-animated stage progress (Capture → Mesh → Export)
- Symbol effects + sensory feedback
- Glass pills for modes

See source for full implementation following swiftui-ui-master skill principles.
