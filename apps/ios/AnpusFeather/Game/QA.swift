import CoreGraphics

/*
  The YES / NO question — the port of qa.pde. Answer by tapping a button or by
  moving a hand (touch) into one. Button rects derive from the live world width
  so they stay pinned to the top corners on any screen.
*/
final class QA {
    enum Answer: Equatable { case none, yes, no }

    private(set) var answer: Answer = .none
    private var fillAlpha: CGFloat = 0

    private let btn: CGFloat = 280
    private let margin: CGFloat = 20

    private let store: TextureStore
    private let skeleton: Skeleton
    private var p: [Vec3] { skeleton.points }

    init(store: TextureStore, skeleton: Skeleton) {
        self.store = store
        self.skeleton = skeleton
    }

    private var noRect: CGRect { CGRect(x: margin, y: margin, width: btn, height: btn) }
    private var yesRect: CGRect { CGRect(x: World.w - btn - margin, y: margin, width: btn, height: btn) }

    func answerReset() { answer = .none }

    func ask(_ canvas: Canvas) {
        button(canvas, noRect, "NO", Color4.rgba(255, 0, 0, CGFloat(fillAlpha / 255)))
        button(canvas, yesRect, "YES", Color4.rgba(0, 0, 255, CGFloat(fillAlpha / 255)))
    }

    private func button(_ canvas: Canvas, _ r: CGRect, _ label: String, _ fill: Color4) {
        canvas.fillRect(r.minX, r.minY, r.width, r.height, fill)
        Message.drawCentered(
            canvas, store, label, r.midX, r.midY, fontSize: 60,
            tint: Color4(r: 1, g: 1, b: 1, a: Float(fillAlpha / 255)))
    }

    private func hit(_ x: CGFloat, _ y: CGFloat, _ r: CGRect) -> Bool { r.contains(CGPoint(x: x, y: y)) }

    /// Tap input.
    func enableButtons(_ clicks: [(x: CGFloat, y: CGFloat)]) {
        for c in clicks {
            if hit(c.x, c.y, yesRect) { answer = .yes }
            if hit(c.x, c.y, noRect) { answer = .no }
        }
    }

    /// Hand-position input (skeleton space centered on screen).
    func enableGestures() {
        for hand in [p[4], p[7]] {
            let x = hand.x + World.w / 2
            let y = hand.y + World.h / 2
            if hit(x, y, yesRect) { answer = .yes }
            if hit(x, y, noRect) { answer = .no }
        }
    }

    func fadeIn(_ dt: CGFloat) { fillAlpha = clampf(fillAlpha + dt * FPS, 0, 255) }
    func fadeOut(_ dt: CGFloat) { fillAlpha = clampf(fillAlpha - dt * FPS, 0, 255) }
}
