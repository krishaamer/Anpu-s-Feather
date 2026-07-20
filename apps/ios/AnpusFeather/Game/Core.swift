import CoreGraphics
import simd

/*
  Shared constants and helpers — the Swift counterpart of the web app's
  core.ts. The world is responsive: a fixed design height (900) with a width
  that tracks the view's aspect ratio, so the scene fills the screen edge to
  edge instead of being letterboxed.
*/

enum World {
    static let designH: CGFloat = 900
    static let minAspect: CGFloat = 1.2
    static let maxAspect: CGFloat = 2.6

    // Live world size, updated by `setViewport` every frame from the drawable.
    private(set) static var w: CGFloat = 1600
    private(set) static var h: CGFloat = designH

    static func setViewport(pixelW: CGFloat, pixelH: CGFloat) {
        let aspect = clampf(pixelW / max(pixelH, 1), minAspect, maxAspect)
        h = designH
        w = (designH * aspect).rounded()
    }

    /// True when the device is more portrait than the composition allows.
    static func isPortrait(pixelW: CGFloat, pixelH: CGFloat) -> Bool {
        pixelW / max(pixelH, 1) < minAspect
    }
}

// The original sketch ran at 27fps and tuned per-frame fades/easing. Scaling
// per-frame deltas by dt * FPS keeps the original feel at any refresh rate.
let FPS: CGFloat = 27

struct Vec3 {
    var x: CGFloat
    var y: CGFloat
    var z: CGFloat
}

@inline(__always) func lerpf(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
    a + (b - a) * t
}

@inline(__always) func clampf(_ v: CGFloat, _ lo: CGFloat, _ hi: CGFloat) -> CGFloat {
    min(hi, max(lo, v))
}

// Processing's map(): intentionally unclamped — the feather physics rely on it.
@inline(__always) func mapf(
    _ v: CGFloat, _ inLo: CGFloat, _ inHi: CGFloat, _ outLo: CGFloat, _ outHi: CGFloat
) -> CGFloat {
    outLo + ((v - inLo) / (inHi - inLo)) * (outHi - outLo)
}

@inline(__always) func randomf(_ lo: CGFloat, _ hi: CGFloat) -> CGFloat {
    lo + CGFloat.random(in: 0...1) * (hi - lo)
}

// 17 skeleton joints (from the original Kinect capture). Indices:
// 0 head, 1 neck, 2 lShoulder, 3 lElbow, 4 lHand, 5 rShoulder, 6 rElbow,
// 7 rHand, 8 torso, 9 lHip, 10 lKnee, 11 lFoot, 12 rHip, 13 rKnee,
// 14 rFoot, 15 spineMid, 16 spineShoulder.
let JOINTS = 17

// An RGBA color in 0...1, the currency of the renderer.
struct Color4 {
    var r: Float
    var g: Float
    var b: Float
    var a: Float

    static let white = Color4(r: 1, g: 1, b: 1, a: 1)
    static let black = Color4(r: 0, g: 0, b: 0, a: 1)

    static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> Color4 {
        Color4(r: Float(r / 255), g: Float(g / 255), b: Float(b / 255), a: Float(a))
    }
}
