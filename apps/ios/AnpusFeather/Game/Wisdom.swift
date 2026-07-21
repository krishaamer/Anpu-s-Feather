import CoreGraphics
import Metal
import UIKit

/*
  Wisdom cards — the port of wisdom.pde. The card art (title, frame, brackets,
  smoke + Anubis panels) is the bundled image; only the captured dance and the
  Sebayt saying are composited in. Quotes are from Sebayt pharaonic Egyptian
  wisdom literature (https://en.wikipedia.org/wiki/Sebayt).
*/
final class Wisdom {
    private var alpha: CGFloat = 0
    private var quote = ""
    private var hasRun = false

    // Placement of the photo window and quote area inside the 1000x800 art.
    private let window = CGRect(x: 97, y: 265, width: 363, height: 367)
    private let quoteBox = CGRect(x: 545, y: 300, width: 355, height: 380)

    private let store: TextureStore

    private let quotes = [
        "If you would only accomplish this, becoming expert in writing: Those writers of knowledge from the time of events after the gods, those who foretold the future, their names have become fixed for eternity, though they are gone, they have completed their lifespan, and all their kin are forgotten.",
        "They did not make for themselves a chapel of copper, or a stela for it of iron from the sky. They did not manage to leave heirs, from their children, to pronounce their names, but they have achieved heirs out of writings, out of the teachings in those.",
        "They are given the book as ritual-priest, The writing-board as loving-son. Teachings are their chapels, the writing-rush their child, and the block of stone the wife. From great to small, (all) are given as his children, for the writer, he is their leader.",
        "The doors of their chapels are undone, Their ka-priests have gone. Their tombstones are smeared with mud, their tombs are forgotten, but their names are read out on their scrolls, written when they were young. Being remembered makes them, to the limits of eternity.",
        "Be a writer - put it in your heart, and your name is created by the same. Scrolls are more useful than tombstones, than building a solid enclosure. They act as chapels and chambers, by the desire of the one pronouncing their name. For sure there is most use in the cemetery for a name in the mouths of men.",
        "A man is dead, his corpse is in the ground: when all his family are laid in the earth, It is writing that lets him be remembered, in the mouth of the reciter of the formula. Scrolls are more useful than a built house, than chapels on the west, they are more perfect than palace towers, longer-lasting than a monument in a temple.",
        "Is there anyone here like Hordedef? Is there another like Imhotep? There is no family born for us like Neferty, and Khety their leader. Let me remind you of the name of Ptahemdjehuty Khakheperraseneb. Is there another like Ptahhotep? Kaires too?",
        "Those who knew how to foretell the future, What came from their mouths took place, and may be found in (their) phrasing. They are given the offspring of others as heirs as if their (own) children. They hid their powers from the whole land, to be read in (their) teachings. They are gone, their names might be forgotten, but writing lets them be remembered.",
    ]

    init(store: TextureStore) { self.store = store }

    /// The feather's resting height picks the saying.
    @discardableResult
    func getQuote(_ featherY: CGFloat) -> String {
        if !hasRun {
            hasRun = true
            let choice = Int(clampf(floor(mapf(featherY, -480, 300, 0, CGFloat(quotes.count))), 0, CGFloat(quotes.count - 1)))
            quote = quotes[choice]
        }
        return quote
    }

    func setAlpha(_ a: CGFloat) { alpha = a }
    func fadeIn(_ speed: CGFloat, _ dt: CGFloat) { alpha = clampf(alpha + speed * dt * FPS, 0, 255) }
    func fadeOut(_ speed: CGFloat, _ dt: CGFloat) { alpha = clampf(alpha - speed * dt * FPS, 0, 255) }

    /// On-screen card (Metal). captureTex holds the accumulated dance.
    func showCard(_ canvas: Canvas, capture: MTLTexture, captureSize: CGSize) {
        guard let card = store.image("wisdom_card_bg") else { return }
        let a = alpha / 255
        let cardW = CGFloat(card.width)
        let cardH = CGFloat(card.height)
        let scale = min((World.w * 0.62) / cardW, (World.h * 0.98) / cardH)
        let cw = cardW * scale
        let ch = cardH * scale
        let cx = World.w / 2 - cw / 2
        let cy = World.h / 2 - ch / 2

        canvas.drawImage(card, cx, cy, cw, ch, tint: Color4(r: 1, g: 1, b: 1, a: Float(a)))

        // Composite the dance into the window, center-cropped to its aspect.
        let win = CGRect(
            x: cx + window.minX * scale, y: cy + window.minY * scale,
            width: window.width * scale, height: window.height * scale)
        let srcAspect = captureSize.width / captureSize.height
        let dstAspect = win.width / win.height
        var sw = captureSize.width
        var sh = captureSize.height
        if srcAspect > dstAspect { sw = sh * dstAspect } else { sh = sw / dstAspect }
        let sx = (captureSize.width - sw) / 2
        let sy = (captureSize.height - sh) / 2
        canvas.drawImage(
            capture, win.minX, win.minY, win.width, win.height,
            tint: Color4(r: 1, g: 1, b: 1, a: Float(a)),
            src: CGRect(x: sx, y: sy, width: sw, height: sh), texSize: captureSize)

        // The saying, wrapped over the right-hand panel.
        let qx = cx + quoteBox.minX * scale
        let qy = cy + quoteBox.minY * scale
        let qw = quoteBox.width * scale
        Message.drawCenteredLeft(
            canvas, store, quote, qx, qy, fontSize: (19 * scale).rounded(), maxWidth: qw,
            tint: Color4.rgba(230, 222, 200, a))
    }

    /// Compose a shareable card image (CoreGraphics), dance from `danceImage`.
    func exportImage(danceImage: CGImage?) -> UIImage? {
        guard
            let cardURL = Bundle.main.resourceURL?.appendingPathComponent("Media/img/wisdom_card_bg.png"),
            let card = UIImage(contentsOfFile: cardURL.path)
        else { return nil }
        let size = card.size
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { rc in
            let ctx = rc.cgContext
            UIColor.black.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
            card.draw(in: CGRect(origin: .zero, size: size))

            if let dance = danceImage {
                // Center-crop the dance into the window.
                let dw = CGFloat(dance.width)
                let dh = CGFloat(dance.height)
                let srcAspect = dw / dh
                let dstAspect = window.width / window.height
                var sw = dw
                var sh = dh
                if srcAspect > dstAspect { sw = sh * dstAspect } else { sh = sw / dstAspect }
                let sx = (dw - sw) / 2
                let sy = (dh - sh) / 2
                if let cropped = dance.cropping(to: CGRect(x: sx, y: sy, width: sw, height: sh)) {
                    ctx.saveGState()
                    // UIKit y-down; draw the CGImage upright via a flipped clip.
                    ctx.translateBy(x: window.minX, y: window.minY)
                    ctx.translateBy(x: 0, y: window.height)
                    ctx.scaleBy(x: 1, y: -1)
                    ctx.draw(cropped, in: CGRect(x: 0, y: 0, width: window.width, height: window.height))
                    ctx.restoreGState()
                }
            }

            let para = NSMutableParagraphStyle()
            para.alignment = .left
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Georgia", size: 19) ?? UIFont.systemFont(ofSize: 19),
                .foregroundColor: UIColor(red: 230 / 255, green: 222 / 255, blue: 200 / 255, alpha: 1),
                .paragraphStyle: para,
            ]
            NSAttributedString(string: quote, attributes: attrs).draw(
                with: quoteBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        }
    }
}
