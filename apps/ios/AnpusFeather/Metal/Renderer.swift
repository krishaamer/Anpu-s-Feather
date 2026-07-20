import Metal
import MetalKit
import simd

// Matches `struct Vertex` in Shaders.metal (position, uv, color = 32 bytes).
struct Vertex {
    var position: SIMD2<Float>
    var uv: SIMD2<Float>
    var color: SIMD4<Float>
}

private struct Uniforms {
    var projection: matrix_float4x4
}

enum Pipe: Equatable {
    case textured
    case color
    case point
}

private struct DrawCmd {
    var pipe: Pipe
    var blendAdd: Bool
    var texture: MTLTexture?
    var primitive: MTLPrimitiveType
    var start: Int
    var count: Int
}

/*
  Canvas is the immediate-mode 2D surface the game draws into — the Metal
  equivalent of a CanvasRenderingContext2D. Draw calls append geometry (built
  on the CPU in world coordinates) to a per-frame vertex list and coalesce into
  as few GPU draws as possible while preserving submission order (painter's
  algorithm, which the layered scenes depend on). Its backing texture persists
  across frames, so not clearing produces the light-heart particle trails.
*/
final class Canvas {
    fileprivate(set) var verts: [Vertex] = []
    fileprivate(set) var cmds: [DrawCmd] = []

    /// When true, subsequent draws blend additively (the light-heart glow).
    var blendAdd = false

    func reset() {
        verts.removeAll(keepingCapacity: true)
        cmds.removeAll(keepingCapacity: true)
    }

    private func push(_ pipe: Pipe, _ primitive: MTLPrimitiveType, _ texture: MTLTexture?, _ n: Int) {
        if var last = cmds.last,
            last.pipe == pipe, last.blendAdd == blendAdd, last.primitive == primitive,
            last.texture === texture, last.start + last.count == verts.count - n {
            last.count += n
            cmds[cmds.count - 1] = last
        } else {
            cmds.append(
                DrawCmd(
                    pipe: pipe, blendAdd: blendAdd, texture: texture, primitive: primitive,
                    start: verts.count - n, count: n))
        }
    }

    private func v(_ x: CGFloat, _ y: CGFloat, _ u: CGFloat, _ vv: CGFloat, _ c: Color4) -> Vertex {
        Vertex(
            position: SIMD2(Float(x), Float(y)), uv: SIMD2(Float(u), Float(vv)),
            color: SIMD4(c.r, c.g, c.b, c.a))
    }

    // MARK: filled shapes

    func fillRect(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ c: Color4) {
        verts.append(v(x, y, 0, 0, c))
        verts.append(v(x + w, y, 0, 0, c))
        verts.append(v(x + w, y + h, 0, 0, c))
        verts.append(v(x, y, 0, 0, c))
        verts.append(v(x + w, y + h, 0, 0, c))
        verts.append(v(x, y + h, 0, 0, c))
        push(.color, .triangle, nil, 6)
    }

    /// Clear the whole world rectangle (letterbox bars are left untouched/black).
    func clear() { fillRect(0, 0, World.w, World.h, .black) }

    /// Translucent black wash — soft motion trails, like the scales scene.
    func fade(_ alpha: CGFloat) {
        fillRect(0, 0, World.w, World.h, Color4(r: 0, g: 0, b: 0, a: Float(alpha)))
    }

    func fillEllipse(
        _ cx: CGFloat, _ cy: CGFloat, _ rx: CGFloat, _ ry: CGFloat, _ c: Color4, segments: Int = 40
    ) {
        var prev = SIMD2<Float>(Float(cx + rx), Float(cy))
        for i in 1...segments {
            let a = CGFloat(i) / CGFloat(segments) * .pi * 2
            let p = SIMD2<Float>(Float(cx + cos(a) * rx), Float(cy + sin(a) * ry))
            verts.append(Vertex(position: SIMD2(Float(cx), Float(cy)), uv: .zero, color: SIMD4(c.r, c.g, c.b, c.a)))
            verts.append(Vertex(position: prev, uv: .zero, color: SIMD4(c.r, c.g, c.b, c.a)))
            verts.append(Vertex(position: p, uv: .zero, color: SIMD4(c.r, c.g, c.b, c.a)))
            prev = p
        }
        push(.color, .triangle, nil, segments * 3)
    }

    // MARK: strokes

    /// A ring drawn as a triangle band between an inner and outer radius.
    func strokeEllipse(
        _ cx: CGFloat, _ cy: CGFloat, _ rx: CGFloat, _ ry: CGFloat, _ lineW: CGFloat, _ c: Color4,
        segments: Int = 48
    ) {
        let hw = lineW / 2
        var added = 0
        func ring(_ a: CGFloat) -> (SIMD2<Float>, SIMD2<Float>) {
            let ca = cos(a)
            let sa = sin(a)
            let outer = SIMD2<Float>(Float(cx + ca * (rx + hw)), Float(cy + sa * (ry + hw)))
            let inner = SIMD2<Float>(Float(cx + ca * (rx - hw)), Float(cy + sa * (ry - hw)))
            return (outer, inner)
        }
        var prev = ring(0)
        let col = SIMD4(c.r, c.g, c.b, c.a)
        for i in 1...segments {
            let a = CGFloat(i) / CGFloat(segments) * .pi * 2
            let cur = ring(a)
            verts.append(Vertex(position: prev.0, uv: .zero, color: col))
            verts.append(Vertex(position: prev.1, uv: .zero, color: col))
            verts.append(Vertex(position: cur.0, uv: .zero, color: col))
            verts.append(Vertex(position: cur.0, uv: .zero, color: col))
            verts.append(Vertex(position: prev.1, uv: .zero, color: col))
            verts.append(Vertex(position: cur.1, uv: .zero, color: col))
            prev = cur
            added += 6
        }
        push(.color, .triangle, nil, added)
    }

    func thickLine(
        _ x1: CGFloat, _ y1: CGFloat, _ x2: CGFloat, _ y2: CGFloat, _ width: CGFloat, _ c: Color4
    ) {
        let dx = x2 - x1
        let dy = y2 - y1
        let len = max(hypot(dx, dy), 0.0001)
        let nx = -dy / len * width / 2
        let ny = dx / len * width / 2
        let col = SIMD4(c.r, c.g, c.b, c.a)
        func p(_ x: CGFloat, _ y: CGFloat) -> Vertex {
            Vertex(position: SIMD2(Float(x), Float(y)), uv: .zero, color: col)
        }
        verts.append(p(x1 + nx, y1 + ny))
        verts.append(p(x2 + nx, y2 + ny))
        verts.append(p(x2 - nx, y2 - ny))
        verts.append(p(x1 + nx, y1 + ny))
        verts.append(p(x2 - nx, y2 - ny))
        verts.append(p(x1 - nx, y1 - ny))
        push(.color, .triangle, nil, 6)
    }

    /// Cubic bezier, sampled to a thick polyline (the heavy-heart arcs).
    func bezier(
        _ x0: CGFloat, _ y0: CGFloat, _ cx1: CGFloat, _ cy1: CGFloat,
        _ cx2: CGFloat, _ cy2: CGFloat, _ x1: CGFloat, _ y1: CGFloat,
        _ width: CGFloat, _ c: Color4, steps: Int = 24
    ) {
        var px = x0
        var py = y0
        for i in 1...steps {
            let t = CGFloat(i) / CGFloat(steps)
            let mt = 1 - t
            let a = mt * mt * mt
            let b = 3 * mt * mt * t
            let d = 3 * mt * t * t
            let e = t * t * t
            let x = a * x0 + b * cx1 + d * cx2 + e * x1
            let y = a * y0 + b * cy1 + d * cy2 + e * y1
            thickLine(px, py, x, y, width, c)
            px = x
            py = y
        }
    }

    // MARK: images (and rasterized text, which is just a texture)

    func drawImage(
        _ tex: MTLTexture, _ dx: CGFloat, _ dy: CGFloat, _ dw: CGFloat, _ dh: CGFloat,
        tint: Color4 = .white,
        src: CGRect? = nil, texSize: CGSize? = nil
    ) {
        var u0: CGFloat = 0
        var v0: CGFloat = 0
        var u1: CGFloat = 1
        var v1: CGFloat = 1
        if let s = src, let ts = texSize, ts.width > 0, ts.height > 0 {
            u0 = s.minX / ts.width
            v0 = s.minY / ts.height
            u1 = s.maxX / ts.width
            v1 = s.maxY / ts.height
        }
        verts.append(v(dx, dy, u0, v0, tint))
        verts.append(v(dx + dw, dy, u1, v0, tint))
        verts.append(v(dx + dw, dy + dh, u1, v1, tint))
        verts.append(v(dx, dy, u0, v0, tint))
        verts.append(v(dx + dw, dy + dh, u1, v1, tint))
        verts.append(v(dx, dy + dh, u0, v1, tint))
        push(.textured, .triangle, tex, 6)
    }

    // MARK: particles

    func point(_ x: CGFloat, _ y: CGFloat, _ size: CGFloat, _ c: Color4) {
        // size travels through the uv.x slot to reach [[point_size]] in the shader.
        verts.append(
            Vertex(
                position: SIMD2(Float(x), Float(y)), uv: SIMD2(Float(size), 0),
                color: SIMD4(c.r, c.g, c.b, c.a)))
        push(.point, .point, nil, 1)
    }
}

/*
  Renderer owns the Metal device and pipelines and drives the frame loop.
  Each frame the game draws into two persistent offscreen canvases — `scene`
  (presented to the screen) and `capture` (the accumulating dance image the
  wisdom card samples) — which are then encoded and the scene blitted to the
  drawable.
*/
final class Renderer: NSObject, MTKViewDelegate {
    let device: MTLDevice
    private let queue: MTLCommandQueue
    private var pipelines: [String: MTLRenderPipelineState] = [:]
    private let sampler: MTLSamplerState

    let scene = Canvas()
    let capture = Canvas()

    private var sceneTex: MTLTexture?
    private var captureTex: MTLTexture!
    private let captureW = 1600
    private let captureH = 900

    // One persistent vertex buffer per canvas, so the capture and scene passes
    // in a single command buffer never clobber each other's geometry.
    private var buffers: [ObjectIdentifier: MTLBuffer] = [:]
    private var lastTime: CFTimeInterval = CACurrentMediaTime()

    /// Called every frame with the elapsed seconds; the game draws here.
    var onFrame: ((CGFloat) -> Void)?
    /// Reports drawable pixel size + portrait state after each resize.
    var onResize: ((CGFloat, CGFloat) -> Void)?

    var textures: TextureStore!

    init?(mtkView: MTKView) {
        guard let device = MTLCreateSystemDefaultDevice(),
            let queue = device.makeCommandQueue()
        else { return nil }
        self.device = device
        self.queue = queue

        mtkView.device = device
        mtkView.colorPixelFormat = .bgra8Unorm
        mtkView.framebufferOnly = false  // we blit the scene texture to the drawable
        mtkView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)

        let sd = MTLSamplerDescriptor()
        sd.minFilter = .linear
        sd.magFilter = .linear
        sd.sAddressMode = .clampToEdge
        sd.tAddressMode = .clampToEdge
        guard let samp = device.makeSamplerState(descriptor: sd) else { return nil }
        sampler = samp

        super.init()

        guard let library = device.makeDefaultLibrary() else { return nil }
        buildPipelines(library)

        captureTex = makeTarget(width: captureW, height: captureH)

        self.textures = TextureStore(device: device)
        mtkView.delegate = self
    }

    private func buildPipelines(_ lib: MTLLibrary) {
        func make(_ key: String, _ vfn: String, _ ffn: String, additive: Bool) {
            let d = MTLRenderPipelineDescriptor()
            d.vertexFunction = lib.makeFunction(name: vfn)
            d.fragmentFunction = lib.makeFunction(name: ffn)
            let a = d.colorAttachments[0]!
            a.pixelFormat = .bgra8Unorm
            a.isBlendingEnabled = true
            a.rgbBlendOperation = .add
            a.alphaBlendOperation = .add
            a.sourceRGBBlendFactor = .sourceAlpha
            a.sourceAlphaBlendFactor = .sourceAlpha
            if additive {
                a.destinationRGBBlendFactor = .one
                a.destinationAlphaBlendFactor = .one
            } else {
                a.destinationRGBBlendFactor = .oneMinusSourceAlpha
                a.destinationAlphaBlendFactor = .oneMinusSourceAlpha
            }
            pipelines[key] = try? device.makeRenderPipelineState(descriptor: d)
        }
        make("textured", "vtx_main", "frag_textured", additive: false)
        make("color", "vtx_main", "frag_color", additive: false)
        make("color.add", "vtx_main", "frag_color", additive: true)
        make("point", "vtx_point", "frag_point", additive: false)
        make("point.add", "vtx_point", "frag_point", additive: true)
    }

    private func makeTarget(width: Int, height: Int) -> MTLTexture {
        let d = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: .bgra8Unorm, width: max(width, 1), height: max(height, 1), mipmapped: false)
        d.usage = [.renderTarget, .shaderRead]
        d.storageMode = .private
        let t = device.makeTexture(descriptor: d)!
        // Start cleared to opaque black.
        clearTexture(t)
        return t
    }

    private func clearTexture(_ tex: MTLTexture) {
        let rp = MTLRenderPassDescriptor()
        rp.colorAttachments[0].texture = tex
        rp.colorAttachments[0].loadAction = .clear
        rp.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
        rp.colorAttachments[0].storeAction = .store
        if let cb = queue.makeCommandBuffer(),
            let enc = cb.makeRenderCommandEncoder(descriptor: rp) {
            enc.endEncoding()
            cb.commit()
        }
    }

    func clearCaptureTexture() { clearTexture(captureTex) }
    var captureTexture: MTLTexture { captureTex }
    var captureSize: CGSize { CGSize(width: captureW, height: captureH) }

    /// Read the accumulated dance texture back to a CGImage (for card export).
    func readCaptureCGImage() -> CGImage? {
        let w = captureW
        let h = captureH
        let desc = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: .bgra8Unorm, width: w, height: h, mipmapped: false)
        desc.usage = [.shaderRead]
        desc.storageMode = .shared
        guard let shared = device.makeTexture(descriptor: desc),
            let cb = queue.makeCommandBuffer(),
            let blit = cb.makeBlitCommandEncoder()
        else { return nil }
        blit.copy(
            from: captureTex, sourceSlice: 0, sourceLevel: 0,
            sourceOrigin: MTLOrigin(x: 0, y: 0, z: 0),
            sourceSize: MTLSize(width: w, height: h, depth: 1),
            to: shared, destinationSlice: 0, destinationLevel: 0,
            destinationOrigin: MTLOrigin(x: 0, y: 0, z: 0))
        blit.endEncoding()
        cb.commit()
        cb.waitUntilCompleted()

        let bytesPerRow = w * 4
        var data = [UInt8](repeating: 0, count: bytesPerRow * h)
        shared.getBytes(
            &data, bytesPerRow: bytesPerRow, from: MTLRegionMake2D(0, 0, w, h), mipmapLevel: 0)
        let cs = CGColorSpaceCreateDeviceRGB()
        let bitmap = CGImageAlphaInfo.premultipliedFirst.rawValue
            | CGBitmapInfo.byteOrder32Little.rawValue
        return data.withUnsafeMutableBytes { raw -> CGImage? in
            guard
                let ctx = CGContext(
                    data: raw.baseAddress, width: w, height: h, bitsPerComponent: 8,
                    bytesPerRow: bytesPerRow, space: cs, bitmapInfo: bitmap)
            else { return nil }
            return ctx.makeImage()
        }
    }

    // MARK: MTKViewDelegate

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        allocSceneTex(size)
        World.setViewport(pixelW: size.width, pixelH: size.height)
        onResize?(size.width, size.height)
    }

    private func allocSceneTex(_ size: CGSize) {
        let w = Int(size.width)
        let h = Int(size.height)
        if w > 0 && h > 0 && (sceneTex?.width != w || sceneTex?.height != h) {
            sceneTex = makeTarget(width: w, height: h)
        }
    }

    func draw(in view: MTKView) {
        let size = view.drawableSize
        if sceneTex == nil { allocSceneTex(size) }
        guard let sceneTex,
            let drawable = view.currentDrawable
        else { return }

        World.setViewport(pixelW: size.width, pixelH: size.height)

        let now = CACurrentMediaTime()
        let dt = min(CGFloat(now - lastTime), 0.1)
        lastTime = now

        scene.reset()
        capture.reset()
        onFrame?(dt)

        guard let cb = queue.makeCommandBuffer() else { return }

        // Capture pass (persists to accumulate the dance).
        let capProj = orthoStretch(texW: CGFloat(captureW), texH: CGFloat(captureH))
        encode(capture, into: captureTex, proj: capProj, cb: cb)

        // Scene pass (persists so light-heart trails accumulate).
        let sceneProj = orthoContain(pixelW: size.width, pixelH: size.height)
        encode(scene, into: sceneTex, proj: sceneProj, cb: cb)

        // Present: copy the scene texture onto the drawable.
        if let blit = cb.makeBlitCommandEncoder() {
            blit.copy(
                from: sceneTex, sourceSlice: 0, sourceLevel: 0,
                sourceOrigin: MTLOrigin(x: 0, y: 0, z: 0),
                sourceSize: MTLSize(width: sceneTex.width, height: sceneTex.height, depth: 1),
                to: drawable.texture, destinationSlice: 0, destinationLevel: 0,
                destinationOrigin: MTLOrigin(x: 0, y: 0, z: 0))
            blit.endEncoding()
        }
        cb.present(drawable)
        cb.commit()
    }

    private func encode(_ canvas: Canvas, into tex: MTLTexture, proj: matrix_float4x4, cb: MTLCommandBuffer) {
        guard !canvas.verts.isEmpty else { return }
        let bytes = canvas.verts.count * MemoryLayout<Vertex>.stride
        let key = ObjectIdentifier(canvas)
        var buffer = buffers[key]
        if buffer == nil || buffer!.length < bytes {
            buffer = device.makeBuffer(length: max(bytes, 4096), options: .storageModeShared)
            buffers[key] = buffer
        }
        guard let vbuf = buffer else { return }
        canvas.verts.withUnsafeBytes { raw in
            vbuf.contents().copyMemory(from: raw.baseAddress!, byteCount: bytes)
        }
        var uniforms = Uniforms(projection: proj)

        let rp = MTLRenderPassDescriptor()
        rp.colorAttachments[0].texture = tex
        rp.colorAttachments[0].loadAction = .load  // keep prior contents (trails)
        rp.colorAttachments[0].storeAction = .store
        guard let enc = cb.makeRenderCommandEncoder(descriptor: rp) else { return }
        enc.setVertexBuffer(vbuf, offset: 0, index: 0)
        enc.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 1)
        enc.setFragmentSamplerState(sampler, index: 0)

        for cmd in canvas.cmds {
            let key: String
            switch cmd.pipe {
            case .textured: key = "textured"
            case .color: key = cmd.blendAdd ? "color.add" : "color"
            case .point: key = cmd.blendAdd ? "point.add" : "point"
            }
            guard let ps = pipelines[key] else { continue }
            enc.setRenderPipelineState(ps)
            if let t = cmd.texture { enc.setFragmentTexture(t, index: 0) }
            enc.drawPrimitives(type: cmd.primitive, vertexStart: cmd.start, vertexCount: cmd.count)
        }
        enc.endEncoding()
    }

    // World (0..W, 0..H, y-down) → clip, fitted (contain) into the pixel target.
    private func orthoContain(pixelW: CGFloat, pixelH: CGFloat) -> matrix_float4x4 {
        let scale = min(pixelW / World.w, pixelH / World.h)
        let offX = (pixelW - World.w * scale) / 2
        let offY = (pixelH - World.h * scale) / 2
        let sx = Float(scale / pixelW * 2)
        let sy = Float(-scale / pixelH * 2)
        let tx = Float(offX / pixelW * 2 - 1)
        let ty = Float(1 - offY / pixelH * 2)
        return matrix_float4x4(columns: (
            SIMD4(sx, 0, 0, 0), SIMD4(0, sy, 0, 0), SIMD4(0, 0, 1, 0), SIMD4(tx, ty, 0, 1)))
    }

    // World (0..W, 0..H) stretched to fill an offscreen texture (the capture).
    private func orthoStretch(texW: CGFloat, texH: CGFloat) -> matrix_float4x4 {
        _ = texW
        _ = texH
        let sx = Float(2 / World.w)
        let sy = Float(-2 / World.h)
        return matrix_float4x4(columns: (
            SIMD4(sx, 0, 0, 0), SIMD4(0, sy, 0, 0), SIMD4(0, 0, 1, 0), SIMD4(-1, 1, 0, 1)))
    }
}
