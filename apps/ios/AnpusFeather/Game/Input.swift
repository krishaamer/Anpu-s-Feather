import CoreGraphics
import QuartzCore

/*
  Touch input — the native stand-in for the Kinect (the web app used the
  pointer). Positions are in world coordinates; the view converts screen
  touches before feeding them here.
*/
final class Pointer {
    var x: CGFloat = World.w / 2
    var y: CGFloat = World.h / 2
    var speed: CGFloat = 0
    private var lastMoveAt: CFTimeInterval = -1e9
    private var clicks: [(x: CGFloat, y: CGFloat)] = []

    func moved(_ wx: CGFloat, _ wy: CGFloat) {
        let dx = wx - x
        let dy = wy - y
        let dist = hypot(dx, dy)
        speed = speed * 0.85 + dist * 0.15
        x = clampf(wx, 0, World.w)
        y = clampf(wy, 0, World.h)
        if dist > 1 { lastMoveAt = CACurrentMediaTime() }
    }

    func down(_ wx: CGFloat, _ wy: CGFloat) {
        clicks.append((wx, wy))
        lastMoveAt = CACurrentMediaTime()
        moved(wx, wy)
    }

    /// Seconds since the touch last moved.
    func idleSeconds() -> CGFloat { CGFloat(CACurrentMediaTime() - lastMoveAt) }

    func takeClicks() -> [(x: CGFloat, y: CGFloat)] {
        let c = clicks
        clicks.removeAll(keepingCapacity: true)
        return c
    }

    func decay() { speed *= 0.92 }
}
