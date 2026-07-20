import CoreGraphics

/*
  Background imagery — the port of pyramid.pde. The two backdrop photos scale
  to frame the sides at any width; Anubis blinks between two frames in the
  center.
*/
final class Pyramid {
    private var tintAlpha: CGFloat = 0
    private var clock: CGFloat = 0
    private let store: TextureStore

    init(store: TextureStore) { self.store = store }

    func tick(_ dt: CGFloat) { clock += dt }
    func setAlpha(_ a: CGFloat) { tintAlpha = a }

    private var tint: Color4 { Color4(r: 1, g: 1, b: 1, a: Float(tintAlpha / 255)) }

    func show(_ canvas: Canvas) {
        guard let p0 = store.image("pyramid0"), let p2 = store.image("pyramid2") else { return }
        let half = (World.w / 2).rounded(.up) + 1
        let lh = CGFloat(p2.height) * (half / CGFloat(p2.width))
        let rh = CGFloat(p0.height) * (half / CGFloat(p0.width))
        canvas.drawImage(p2, 0, 0, half, lh, tint: tint)
        canvas.drawImage(p0, World.w - half, 0, half, rh, tint: tint)

        let name = clock.truncatingRemainder(dividingBy: 1.1) < 0.55 ? "anubis1" : "anubis2"
        if let a = store.image(name) {
            let w = CGFloat(a.width)
            let h = CGFloat(a.height)
            canvas.drawImage(a, World.w / 2 - w / 2, World.h / 2 - 100 - h / 2, w, h, tint: tint)
        }
    }

    func showAlt(_ canvas: Canvas) {
        guard let img = store.image("pyramid3") else { return }
        let scale = World.w / CGFloat(img.width)
        let h = CGFloat(img.height) * scale
        canvas.drawImage(img, 0, World.h - h, World.w, h, tint: tint)
    }

    func fadeIn(_ dt: CGFloat) { tintAlpha = clampf(tintAlpha + 5 * dt * FPS, 0, 255) }
    func fadeOut(_ dt: CGFloat) { tintAlpha = clampf(tintAlpha - 10 * dt * FPS, 0, 255) }
}
