import Metal
import MetalKit
import UIKit

/*
  Loads the bundled media — the same art, recorded-movement files and music as
  the web app — and rasterizes text into textures. Text is drawn white with
  straight alpha so a single cached texture can be tinted any colour and faded
  via the vertex colour, exactly like the canvas text in the web version.
*/
final class TextureStore {
    private let device: MTLDevice
    private let loader: MTKTextureLoader
    private var images: [String: MTLTexture] = [:]
    private var textCache: [String: MTLTexture] = [:]

    init(device: MTLDevice) {
        self.device = device
        self.loader = MTKTextureLoader(device: device)
    }

    private var mediaRoot: URL {
        Bundle.main.resourceURL!.appendingPathComponent("Media")
    }

    /// Cached PNG from Media/img.
    func image(_ name: String) -> MTLTexture? {
        if let t = images[name] { return t }
        let url = mediaRoot.appendingPathComponent("img/\(name).png")
        let opts: [MTKTextureLoader.Option: Any] = [
            .origin: MTKTextureLoader.Origin.topLeft,
            .SRGB: false,
        ]
        guard let t = try? loader.newTexture(URL: url, options: opts) else { return nil }
        images[name] = t
        return t
    }

    func size(_ tex: MTLTexture) -> CGSize {
        CGSize(width: tex.width, height: tex.height)
    }

    /// A recorded-skeleton file (Media/data/<name>.txt) as a string.
    func recording(_ name: String) -> String {
        let url = mediaRoot.appendingPathComponent("data/\(name).txt")
        return (try? String(contentsOf: url, encoding: .utf8)) ?? ""
    }

    var musicURL: URL { mediaRoot.appendingPathComponent("audio/anpu.wav") }

    // MARK: text

    struct TextSpec {
        var string: String
        var fontSize: CGFloat
        var bold: Bool = false
        var maxWidth: CGFloat = 0  // 0 = single line, no wrap
        var align: NSTextAlignment = .center
    }

    /// White straight-alpha texture for a string (cached). Tint at draw time.
    func text(_ spec: TextSpec) -> MTLTexture? {
        let key =
            "\(spec.string)|\(spec.fontSize)|\(spec.bold)|\(spec.maxWidth)|\(spec.align.rawValue)"
        if let t = textCache[key] { return t }
        guard let t = rasterize(spec) else { return nil }
        textCache[key] = t
        return t
    }

    private func rasterize(_ spec: TextSpec) -> MTLTexture? {
        let font =
            spec.bold
            ? UIFont(name: "Georgia-Bold", size: spec.fontSize)
                ?? UIFont.boldSystemFont(ofSize: spec.fontSize)
            : UIFont(name: "Georgia", size: spec.fontSize)
                ?? UIFont.systemFont(ofSize: spec.fontSize)

        let para = NSMutableParagraphStyle()
        para.alignment = spec.align
        para.lineBreakMode = .byWordWrapping
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white,
            .paragraphStyle: para,
        ]
        let attr = NSAttributedString(string: spec.string, attributes: attrs)

        let bounding = spec.maxWidth > 0 ? spec.maxWidth : .greatestFiniteMagnitude
        let rect = attr.boundingRect(
            with: CGSize(width: bounding, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)

        let pad: CGFloat = 4
        let w = max(1, Int(ceil(rect.width + pad * 2)))
        let h = max(1, Int(ceil(rect.height + pad * 2)))
        let bytesPerRow = w * 4

        // Let CGContext own its backing store (data: nil); its `data` pointer
        // stays valid for as long as the context is alive.
        let cs = CGColorSpaceCreateDeviceRGB()
        guard
            let ctx = CGContext(
                data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: bytesPerRow,
                space: cs, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue),
            let pixels = ctx.data
        else { return nil }

        UIGraphicsPushContext(ctx)
        ctx.translateBy(x: 0, y: CGFloat(h))
        ctx.scaleBy(x: 1, y: -1)
        attr.draw(
            with: CGRect(x: pad, y: pad, width: CGFloat(w) - pad * 2, height: CGFloat(h) - pad * 2),
            options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        UIGraphicsPopContext()

        // Premultiplied white → straight alpha: force RGB to full where covered.
        let ptr = pixels.bindMemory(to: UInt8.self, capacity: bytesPerRow * h)
        var i = 0
        while i < bytesPerRow * h {
            if ptr[i + 3] > 0 {
                ptr[i] = 255
                ptr[i + 1] = 255
                ptr[i + 2] = 255
            }
            i += 4
        }

        let desc = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: .rgba8Unorm, width: w, height: h, mipmapped: false)
        desc.usage = [.shaderRead]
        guard let tex = device.makeTexture(descriptor: desc) else { return nil }
        tex.replace(
            region: MTLRegionMake2D(0, 0, w, h), mipmapLevel: 0, withBytes: pixels,
            bytesPerRow: bytesPerRow)
        return tex
    }
}
