import CoreGraphics
import UIKit

/*
  Text overlays — the port of message.pde. Text is rasterized to white
  textures by the TextureStore and tinted here; the alpha field drives the
  fades, scaled by dt * FPS to match the original per-frame pacing.
*/
final class Message {
    private var alpha: CGFloat = 0
    private let store: TextureStore

    init(store: TextureStore) { self.store = store }

    func setAlpha(_ a: CGFloat) { alpha = a }
    func fadeIn(_ speed: CGFloat, _ dt: CGFloat) { alpha = clampf(alpha + speed * dt * FPS, 0, 255) }
    func fadeOut(_ speed: CGFloat, _ dt: CGFloat) { alpha = clampf(alpha - speed * dt * FPS, 0, 255) }

    /// Draw a text texture centered on (cx, cy) at 1:1 world scale.
    static func drawCentered(
        _ canvas: Canvas, _ store: TextureStore, _ string: String,
        _ cx: CGFloat, _ cy: CGFloat, fontSize: CGFloat, tint: Color4,
        bold: Bool = false, maxWidth: CGFloat = 0
    ) {
        guard
            let tex = store.text(
                TextureStore.TextSpec(
                    string: string, fontSize: fontSize, bold: bold, maxWidth: maxWidth))
        else { return }
        let w = CGFloat(tex.width)
        let h = CGFloat(tex.height)
        canvas.drawImage(tex, cx - w / 2, cy - h / 2, w, h, tint: tint)
    }

    /// Wrapped, left-aligned text anchored at its top-left (the wisdom quote).
    static func drawCenteredLeft(
        _ canvas: Canvas, _ store: TextureStore, _ string: String,
        _ x: CGFloat, _ y: CGFloat, fontSize: CGFloat, maxWidth: CGFloat, tint: Color4
    ) {
        guard
            let tex = store.text(
                TextureStore.TextSpec(
                    string: string, fontSize: fontSize, bold: false, maxWidth: maxWidth,
                    align: .left))
        else { return }
        canvas.drawImage(tex, x, y, CGFloat(tex.width), CGFloat(tex.height), tint: tint)
    }

    func say(_ canvas: Canvas, _ msg: String) {
        Message.drawCentered(
            canvas, store, msg, World.w / 2, World.h / 2, fontSize: 40,
            tint: Color4(r: 1, g: 1, b: 1, a: Float(alpha / 255)))
    }

    func subtitle(_ canvas: Canvas, _ msg: String) {
        Message.drawCentered(
            canvas, store, msg, World.w / 2, World.h / 2 + 40, fontSize: 20,
            tint: Color4(r: 1, g: 1, b: 1, a: Float(alpha / 255)))
    }

    func alert(_ canvas: Canvas, _ msg: String, red: Bool) {
        let tint = red ? Color4.rgba(255, 0, 0, 1) : Color4.rgba(80, 80, 255, 1)
        Message.drawCentered(canvas, store, msg, World.w / 2, World.h / 2, fontSize: 40, tint: tint)
    }

    func countdown(_ canvas: Canvas, _ maxVal: Int, _ s: CGFloat) {
        let x = World.w - 80
        let y: CGFloat = 30
        canvas.fillRect(x - 50, y - 25, 100, 50, .black)
        Message.drawCentered(
            canvas, store, "\(maxVal - Int(s))", x, y, fontSize: 40, tint: .rgba(255, 0, 0, 1))
    }
}
