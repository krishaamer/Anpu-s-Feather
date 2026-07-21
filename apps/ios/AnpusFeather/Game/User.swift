import CoreGraphics

/*
  Draws the visitor's spirit — the port of user.pde.
  - light: a magnetic particle cloud drawn additively
  - heavy: concentric rings and drooping bezier arcs
  - hands: two small circles while answering the question
*/
enum UserMode { case light, heavy, questions }

final class User {
    private var fillAlpha: CGFloat = 0
    private var seeded = false

    private let count = 3000
    private var xpos: [CGFloat]
    private var ypos: [CGFloat]
    private var vx: [CGFloat]
    private var vy: [CGFloat]

    private let skeleton: Skeleton
    private var p: [Vec3] { skeleton.points }

    init(skeleton: Skeleton) {
        self.skeleton = skeleton
        xpos = Array(repeating: 0, count: count)
        ypos = Array(repeating: 0, count: count)
        vx = Array(repeating: 0, count: count)
        vy = Array(repeating: 0, count: count)
    }

    func fadeIn(_ dt: CGFloat) { fillAlpha = clampf(fillAlpha + dt * FPS, 0, 255) }
    func fadeOut(_ dt: CGFloat) { fillAlpha = clampf(fillAlpha - dt * FPS, 0, 255) }

    /// Advance the particle simulation (light mode).
    func simulate() {
        if !seeded {
            for i in 0..<count {
                xpos[i] = randomf(-500, 500)
                ypos[i] = randomf(-500, 500)
            }
            seeded = true
        }
        let magnetism: CGFloat = 30
        let principle: CGFloat = 0.95
        let a1 = p[4], a2 = p[7], a3 = p[14], a4 = p[11]

        for i in 0..<count {
            let x = xpos[i]
            let y = ypos[i]
            let d1 = max(hypot(a1.x - x, a1.y - y), 1)
            let d2 = max(hypot(a2.x - x, a2.y - y), 1)
            let d3 = max(hypot(a3.x - x, a3.y - y), 1)
            let d4 = max(hypot(a4.x - x, a4.y - y), 1)

            var t = a1
            if d1 < 50 || (d1 < d2 && d1 < d3 && d1 < d4) { t = a2 }
            if d2 < 50 || (d2 < d1 && d2 < d3 && d2 < d4) { t = a3 }
            if d3 < 50 || (d3 < d1 && d3 < d4 && d3 < d2) { t = a4 }
            if d4 < 50 || (d4 < d1 && d4 < d2 && d4 < d3) { t = a1 }

            let ax = (magnetism * (t.x - x)) / (d1 * d1)
            let ay = (magnetism * (t.y - y)) / (d1 * d1)
            vx[i] = (vx[i] + ax) * principle
            vy[i] = (vy[i] + ay) * principle
            xpos[i] += vx[i]
            ypos[i] += vy[i]
        }
    }

    func draw(_ canvas: Canvas, _ mode: UserMode) {
        switch mode {
        case .light: drawLight(canvas)
        case .heavy: drawHeavy(canvas)
        case .questions: drawHands(canvas)
        }
    }

    private func drawLight(_ canvas: Canvas) {
        let cx = World.w / 2
        let cy = World.h / 2
        let alphaScale = fillAlpha / 255
        for i in 0..<count {
            let sokudo = hypot(vx[i], vy[i])
            let r = clampf(mapf(sokudo, 0, 5, 0, 255), 0, 255)
            let g = clampf(mapf(sokudo, 0, 5, 64, 255), 0, 255)
            let b = clampf(mapf(sokudo, 0, 5, 128, 255), 0, 255)
            canvas.point(cx + xpos[i], cy + ypos[i], 3, Color4.rgba(r, g, b, 0.24 * alphaScale))
        }
        let dot = Color4(r: 1, g: 1, b: 1, a: Float(alphaScale))
        for i in 0..<JOINTS {
            canvas.fillEllipse(cx + p[i].x, cy + p[i].y, 4, 4, dot, segments: 10)
        }
    }

    // Heavy figure lives in a local space scaled by S about (W/2, H/2+100).
    private func drawHeavy(_ canvas: Canvas) {
        let s: CGFloat = 0.38
        let ox = World.w / 2
        let oy = World.h / 2 + 100
        func wx(_ v: CGFloat) -> CGFloat { ox + v * s }
        func wy(_ v: CGFloat) -> CGFloat { oy + v * s }
        let lw = 10 * s
        let fa = fillAlpha / 255

        func ring(_ cx: CGFloat, _ cy: CGFloat, _ a: CGFloat) {
            canvas.strokeEllipse(
                wx(cx), wy(cy), 60 * s, 60 * s, lw, Color4(r: 1, g: 1, b: 1, a: Float(a / 255 * fa)),
                segments: 40)
        }
        func droop(_ from: Vec3, _ cx: CGFloat, _ cy: CGFloat, _ to: Vec3, _ a: CGFloat) {
            canvas.bezier(
                wx(from.x), wy(from.y), wx(cx), wy(cy), wx(to.x), wy(to.y), wx(to.x), wy(to.y),
                lw, Color4(r: 1, g: 1, b: 1, a: Float(a / 255 * fa)))
        }

        let x1 = (p[4].x + p[3].x) / 2
        let x2 = (p[3].x + p[2].x) / 2
        let x3 = (p[2].x + p[0].x) / 2
        let x4 = (p[6].x + p[7].x) / 2
        let x5 = (p[5].x + p[6].x) / 2
        let x6 = (p[0].x + p[5].x) / 2
        let y7 = p[0].y - 30
        let y8 = y7 + 20
        let y9 = (y7 + y8) / 2
        let y10 = (p[4].y + y8) / 2
        let y11 = (p[7].y + y8) / 2
        let y12 = (p[4].y + y10) / 2
        let y13 = (y7 + y10) / 2
        let y14 = p[15].y + (p[15].y - (p[16].y + 20))

        ring(p[4].x, p[4].y, 255)
        ring(p[7].x, p[7].y, 255)
        ring(x1, y12, 210)
        ring(x4, y12, 210)
        ring(p[3].x, y10, 180)
        ring(p[6].x, y11, 180)
        ring(x2, y13, 150)
        ring(x5, y13, 150)
        ring(p[2].x, y7, 120)
        ring(p[5].x, y7, 120)
        ring(p[0].x, p[0].y, 90)

        droop(p[8], p[10].x - 400, p[10].y - 350, p[11], 210)
        droop(p[8], p[13].x + 400, p[13].y - 350, p[14], 210)
        droop(p[8], p[10].x - 300, p[10].y - 280, p[11], 170)
        droop(p[8], p[13].x + 300, p[13].y - 280, p[14], 170)
        droop(p[8], p[10].x - 200, p[10].y - 200, p[11], 190)
        droop(p[8], p[13].x + 200, p[13].y - 200, p[14], 190)

        ring(x3, y9, 70)
        ring(x6, y9, 70)
        ring(p[16].x + 40, p[16].y + 20, 70)
        ring(p[16].x - 40, p[16].y + 20, 70)
        ring(p[16].x + 40, p[15].y, 70)
        ring(p[16].x - 40, p[15].y, 70)
        ring(p[15].x + 40, y14, 70)
        ring(p[15].x - 40, y14, 70)
    }

    private func drawHands(_ canvas: Canvas) {
        let cx = World.w / 2
        let cy = World.h / 2
        let c = Color4(r: 1, g: 1, b: 1, a: Float(fillAlpha / 255))
        for hand in [p[4], p[7]] {
            canvas.strokeEllipse(cx + hand.x, cy + hand.y, 10, 10, 10, c, segments: 24)
        }
    }
}
