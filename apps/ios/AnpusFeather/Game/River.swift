import CoreGraphics

/*
  The Nile — the port of river.pde. A grid of pulsing ellipses projected as a
  pseudo-3D floor receding toward a horizon.
*/
final class River {
    private var theta: CGFloat = 0
    private var fillAlpha: CGFloat = 170
    private let cols = 25
    private let rows = 45
    private let speed: CGFloat = 0.0223

    private let colors: [(CGFloat, CGFloat, CGFloat)] = [
        (0x83, 0xa0, 0xff), (0x51, 0x73, 0xdf), (0x19, 0x4d, 0xf4), (0x0a, 0x34, 0xbc),
    ]

    func update(_ canvas: Canvas, _ dt: CGFloat) {
        let gap = World.w / CGFloat(cols)
        let horizon = World.h * 0.42

        var theta2: CGFloat = .pi / 6
        for j in 0..<rows {
            let (r, g, b) = colors[j % colors.count]
            let col = Color4.rgba(r, g, b, fillAlpha / 255)
            theta2 += (.pi * 2) / 36
            let offSetY = mapf(sin(theta2), -1, 1, 0, .pi * 2)

            let t = (CGFloat(j) + 0.5) / CGFloat(rows)
            let persp = 0.22 + 0.78 * t * t
            let y = horizon + (World.h - horizon + 80) * t * t

            for i in 0..<cols {
                let offSetX = ((.pi * 2) / CGFloat(rows)) * CGFloat(i)
                let x = World.w / 2 + (CGFloat(i) + 0.5 - CGFloat(cols) / 2) * gap * (0.5 + persp)
                let sz = mapf(sin(theta + offSetX + offSetY), -1, 1, 5, gap * 1.5) * persp
                canvas.fillEllipse(x, y, sz / 2, (sz / 2) * 0.45, col, segments: 14)
            }
        }
        theta -= speed * dt * FPS
    }

    func fadeIn(_ dt: CGFloat) { fillAlpha = clampf(fillAlpha + dt * FPS, 0, 255) }
    func fadeOut(_ dt: CGFloat) { fillAlpha = clampf(fillAlpha - dt * FPS, 0, 255) }
}
