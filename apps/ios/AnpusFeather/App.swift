import MetalKit
import SwiftUI
import UIKit

/*
  App shell. A SwiftUI ZStack layers native overlays (title/Enter, the
  rotate-to-landscape prompt, the Save button) over an MTKView driven by the
  Metal Renderer. GameState wires the renderer, input, audio and the Experience
  together and publishes the UI state the overlays observe.
*/

@main
struct AnpusFeatherApp: App {
    var body: some Scene {
        WindowGroup { RootView() }
    }
}

/// Single source of truth: published UI state plus the renderer/experience wiring.
final class GameState: ObservableObject {
    enum Phase: Equatable { case title, playing }
    @Published var phase: Phase = .title
    @Published var showSave = false
    @Published var portrait = false

    private var renderer: Renderer?
    private let pointer = Pointer()
    private var music: Music?
    private var store: TextureStore?
    private var experience: Experience?

    func attach(_ view: TouchMTKView) {
        guard renderer == nil, let renderer = Renderer(mtkView: view) else { return }
        self.renderer = renderer
        self.store = renderer.textures
        self.music = Music(url: renderer.textures.musicURL)

        view.preferredFramesPerSecond = 60
        view.isPaused = false
        view.enableSetNeedsDisplay = false
        view.isUserInteractionEnabled = true
        view.onTouch = { [weak self] wx, wy, isDown in
            guard let self else { return }
            if isDown { self.pointer.down(wx, wy) } else { self.pointer.moved(wx, wy) }
        }

        renderer.onFrame = { [weak self] dt in self?.experience?.update(dt) }
        renderer.onResize = { [weak self] w, h in
            let p = World.isPortrait(pixelW: w, pixelH: h)
            if self?.portrait != p { self?.portrait = p }
        }
    }

    func startJourney() {
        guard let renderer, let store, let music else { return }
        experience?.stop()
        experience = Experience(
            renderer: renderer, store: store, pointer: pointer, music: music, state: self,
            onRestart: { [weak self] in self?.startJourney() })
        experience?.start()
        phase = .playing
    }

    func saveCard() {
        guard let image = experience?.exportCardImage() else { return }
        Share.present(image: image)
    }
}

/// MTKView subclass that converts touches into world coordinates.
final class TouchMTKView: MTKView {
    var onTouch: ((CGFloat, CGFloat, Bool) -> Void)?

    private func world(_ t: UITouch) -> (CGFloat, CGFloat) {
        let p = t.location(in: self)
        let sf = contentScaleFactor
        let px = p.x * sf
        let py = p.y * sf
        let ds = drawableSize
        let scale = min(ds.width / World.w, ds.height / World.h)
        let offX = (ds.width - World.w * scale) / 2
        let offY = (ds.height - World.h * scale) / 2
        return ((px - offX) / scale, (py - offY) / scale)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let t = touches.first else { return }
        let (x, y) = world(t)
        onTouch?(x, y, true)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let t = touches.first else { return }
        let (x, y) = world(t)
        onTouch?(x, y, false)
    }
}

struct MetalGameView: UIViewRepresentable {
    let game: GameState

    func makeUIView(context: Context) -> TouchMTKView {
        let view = TouchMTKView(frame: .zero)
        game.attach(view)
        return view
    }
    func updateUIView(_ uiView: TouchMTKView, context: Context) {}
}

struct RootView: View {
    @StateObject private var game = GameState()

    private let parchment = Color(red: 232 / 255, green: 220 / 255, blue: 192 / 255)
    private let dim = Color(red: 179 / 255, green: 168 / 255, blue: 136 / 255)

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            MetalGameView(game: game).ignoresSafeArea()

            if game.phase == .title { titleOverlay }

            if game.phase == .playing && game.showSave {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button("Save your wisdom card") { game.saveCard() }
                            .font(.custom("Georgia", size: 16))
                            .foregroundColor(parchment)
                            .padding(.horizontal, 22).padding(.vertical, 12)
                            .background(Color.black.opacity(0.6))
                            .overlay(RoundedRectangle(cornerRadius: 2).stroke(dim.opacity(0.6)))
                            .padding(20)
                    }
                }
            }

            if game.portrait { rotateOverlay }
        }
        .statusBarHidden(true)
    }

    private var titleOverlay: some View {
        VStack(spacing: 20) {
            Text("Anpu\u{2019}s Feather")
                .font(.custom("Georgia", size: 44))
                .foregroundColor(parchment)
            Text(
                "You went on a trip on the Nile river before your death. You are welcomed by Anubis, who weighs your heart against the Feather of Truth. Move your finger to move your spirit. Sound on."
            )
            .font(.custom("Georgia", size: 17))
            .multilineTextAlignment(.center)
            .foregroundColor(dim)
            .frame(maxWidth: 520)
            Button("Enter") { game.startJourney() }
                .font(.custom("Georgia", size: 20))
                .foregroundColor(parchment)
                .padding(.horizontal, 44).padding(.vertical, 14)
                .overlay(Rectangle().stroke(dim.opacity(0.7)))
                .padding(.top, 8)
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }

    private var rotateOverlay: some View {
        VStack(spacing: 22) {
            Text("\u{1F4F1}").font(.system(size: 54))
            Text("Turn your device sideways \u{2014} Anpu\u{2019}s Feather unfolds in landscape.")
                .font(.custom("Georgia", size: 18))
                .multilineTextAlignment(.center)
                .foregroundColor(parchment)
                .frame(maxWidth: 360)
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

/// Presents the iOS share sheet for the finished wisdom card.
enum Share {
    static func present(image: UIImage) {
        guard let vc = topViewController() else { return }
        let av = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        if let pop = av.popoverPresentationController {
            pop.sourceView = vc.view
            pop.sourceRect = CGRect(
                x: vc.view.bounds.midX, y: vc.view.bounds.maxY - 60, width: 1, height: 1)
        }
        vc.present(av, animated: true)
    }

    private static func topViewController() -> UIViewController? {
        let scene = UIApplication.shared.connectedScenes
            .first { $0.activationState == .foregroundActive } as? UIWindowScene
        var vc = scene?.keyWindow?.rootViewController
        while let presented = vc?.presentedViewController { vc = presented }
        return vc
    }
}
