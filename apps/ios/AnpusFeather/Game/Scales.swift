import CoreGraphics

/*
  The weighing of the heart — the port of scales.pde. Movement lifts the
  feather; stillness lets it sink. Its resting height selects the wisdom.
*/
final class Scales {
    private var tintAlpha: CGFloat = 0
    private var t: CGFloat = 0
    private var xn1: CGFloat = 0
    private var xn2: CGFloat = 0
    private var yn1: CGFloat = 0
    private var yn2: CGFloat = 0
    private var featherY: CGFloat = -300
    private let easing: CGFloat = 0.01
    private var diagramVisible = true
    private var from: FeatherStart = .middle

    enum FeatherStart { case top, middle }

    private let store: TextureStore
    private let skeleton: Skeleton
    private var p: [Vec3] { skeleton.points }

    init(store: TextureStore, skeleton: Skeleton) {
        self.store = store
        self.skeleton = skeleton
    }

    func showDiagram(_ v: Bool) { diagramVisible = v }
    func startFrom(_ f: FeatherStart) { from = f }
    var feather: CGFloat { featherY }

    func update(_ canvas: Canvas, _ dt: CGFloat, _ clock: CGFloat) {
        let xdist1 = abs(p[4].x - xn1); xn1 = p[4].x
        let xdist2 = abs(p[7].x - xn2); xn2 = p[7].x
        let ydist1 = abs(p[4].y - yn1); yn1 = p[4].y
        let ydist2 = abs(p[7].y - yn2); yn2 = p[7].y
        let avdist = (xdist1 + xdist2 + ydist1 + ydist2) / 4

        var val = mapf(-avdist, -30, 0, -300, 500)
        if val == 100 { val = randomf(100, 300) }
        if val < 0 { val = randomf(-480, -100) }

        if abs(val - featherY) > 100 {
            featherY += (val - featherY) * easing * dt * FPS
        } else {
            t += 0.2 * dt * FPS
            featherY += sin(t) * 5 * dt * FPS
        }

        let tint = Color4(r: 1, g: 1, b: 1, a: Float(tintAlpha / 255))
        if let feather = store.image("feather") {
            let fw = CGFloat(feather.width) * 0.6
            let fh = CGFloat(feather.height) * 0.6
            let y = from == .top ? featherY : featherY + World.h / 2
            canvas.drawImage(feather, World.w / 2 - fw / 2, y - fh / 2, fw, fh, tint: tint)
        }
        if diagramVisible { drawDiagram(canvas, clock, tint) }
    }

    private func drawDiagram(_ canvas: Canvas, _ clock: CGFloat, _ tint: Color4) {
        let name = clock.truncatingRemainder(dividingBy: 0.74) < 0.37 ? "diagram1" : "diagram2"
        canvas.fillRect(World.w / 2 + 350, World.h / 2 + 150, 300, 300, .black)
        if let d = store.image(name) {
            canvas.drawImage(
                d, World.w / 2 + 350, World.h / 2 + 150,
                CGFloat(d.width), CGFloat(d.height), tint: tint)
        }
        if let scale = store.image("scale") {
            canvas.drawImage(scale, -50, -100, CGFloat(scale.width), CGFloat(scale.height), tint: tint)
        }
    }

    func fadeIn(_ dt: CGFloat) { tintAlpha = min(255, tintAlpha + dt * FPS) }
    func fadeOut(_ dt: CGFloat) { tintAlpha = max(0, tintAlpha - dt * FPS) }
}
