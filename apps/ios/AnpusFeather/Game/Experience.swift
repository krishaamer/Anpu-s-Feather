import CoreGraphics
import UIKit

/*
  The scene director — the port of feather.pde + scenes.pde (and the web app's
  experience.ts). One Experience is one complete journey; restarting makes a
  fresh instance. It draws into the renderer's persistent `scene` canvas, and
  during the light/heavy scenes also into the `capture` canvas that the wisdom
  card samples.
*/
final class Experience {
    private let renderer: Renderer
    private let store: TextureStore
    private let pointer: Pointer
    private let music: Music
    private weak var state: GameState?
    private let onRestart: () -> Void

    private let story = Narrative()
    private let skeleton: Skeleton
    private let message: Message
    private let river = River()
    private let pyramid: Pyramid
    private let user: User
    private let scales: Scales
    private let qa: QA
    private let wisdom: Wisdom

    private var clock: CGFloat = 0
    private var captureStarted = false

    private var scene: Canvas { renderer.scene }
    private var capture: Canvas { renderer.capture }

    init(
        renderer: Renderer, store: TextureStore, pointer: Pointer, music: Music,
        state: GameState, onRestart: @escaping () -> Void
    ) {
        self.renderer = renderer
        self.store = store
        self.pointer = pointer
        self.music = music
        self.state = state
        self.onRestart = onRestart

        skeleton = Skeleton(store: store, pointer: pointer)
        message = Message(store: store)
        pyramid = Pyramid(store: store)
        user = User(skeleton: skeleton)
        scales = Scales(store: store, skeleton: skeleton)
        qa = QA(store: store, skeleton: skeleton)
        wisdom = Wisdom(store: store)
        story.setMode(.intro)
    }

    func start() { music.play() }
    func stop() { music.end() }

    func exportCardImage() -> UIImage? {
        wisdom.exportImage(danceImage: renderer.readCaptureCGImage())
    }

    func update(_ dt: CGFloat) {
        clock += dt
        story.update(dt)
        skeleton.update(dt)
        pyramid.tick(dt)
        pointer.decay()

        let t = story.time
        switch story.mode {
        case .intro: intro(t, dt)
        case .questions: questions(t, dt)
        case .light: light(t, dt)
        case .heavy: heavy(t, dt)
        case .scales: scalesScene(t, dt)
        case .wisdom: wisdomScene(t, dt)
        case .outro: outro(t, dt)
        }

        let showSave = story.mode == .wisdom && t > 5.2
        if state?.showSave != showSave { state?.showSave = showSave }
    }

    private func clear() { scene.clear() }
    private func fade(_ a: CGFloat) { scene.fade(a) }

    // MARK: scenes (timings mirror the original)

    private func intro(_ t: CGFloat, _ dt: CGFloat) {
        clear()
        if t < 2.5 {
            message.fadeIn(10, dt)
            river.update(scene, dt)
        } else if t < 3.5 {
            message.fadeOut(10, dt)
            river.update(scene, dt)
        }
        if t < 3.5 {
            message.say(scene, "Em heset net Anpu!")
            message.subtitle(scene, "Praise the God")
        }
        if t >= 3.5 && t < 3.6 {
            message.setAlpha(0)
            river.update(scene, dt)
        }
        if t >= 3.6 && t < 8.9 {
            river.update(scene, dt)
            river.fadeOut(dt)
            pyramid.show(scene)
            pyramid.fadeIn(dt)
            if t < 7 { message.fadeIn(8, dt) } else { message.fadeOut(10, dt) }
            message.say(scene, "I have been waiting for You")
        }
        if t >= 8.9 && t < 12 {
            river.update(scene, dt)
            river.fadeOut(dt)
            pyramid.show(scene)
            pyramid.fadeOut(dt)
            if t >= 11.9 { message.setAlpha(0) }
        }
        if t >= 12 && t < 19 {
            if t < 16 {
                message.fadeIn(8, dt)
                scales.fadeIn(dt)
            } else {
                message.fadeOut(8, dt)
                scales.fadeOut(dt)
            }
            scales.showDiagram(false)
            scales.startFrom(.top)
            scales.update(scene, dt, clock)
            message.say(scene, "How heavy is your heart?")
        }
        if t > 19 {
            message.setAlpha(0)
            story.setMode(.questions)
            skeleton.randomRecording()
        }
    }

    private func questions(_ t: CGFloat, _ dt: CGFloat) {
        clear()
        if t < 0.1 {
            qa.answerReset()
            message.setAlpha(0)
        }
        if t >= 0.1 && t < 1 {
            message.fadeIn(8, dt)
            message.say(scene, "Have you cried this week?")
        }
        if t >= 1 {
            qa.enableGestures()
            qa.enableButtons(pointer.takeClicks())

            message.say(scene, "Have you cried this week?")
            message.fadeOut(6, dt)

            pyramid.show(scene)
            pyramid.fadeIn(dt)

            qa.ask(scene)
            qa.fadeIn(dt)

            user.draw(scene, .questions)
            user.fadeIn(dt)

            if qa.answer == .yes {
                message.setAlpha(0)
                story.setMode(.light)
                return
            }
            if qa.answer == .no {
                message.setAlpha(0)
                story.setMode(.heavy)
                return
            }
        }
    }

    private func light(_ t: CGFloat, _ dt: CGFloat) {
        if t < 0.1 {
            clear()
            message.setAlpha(0)
            pyramid.setAlpha(0)
            captureStarted = false
        }
        if t < 4.9 { clear() }

        if t >= 0.1 && t < 0.5 { message.alert(scene, "YES", red: false) }

        if t >= 0.5 && t < 3 {
            pyramid.showAlt(scene)
            pyramid.fadeIn(dt)
            if t < 2 { message.fadeIn(8, dt) } else { message.fadeOut(8, dt) }
            message.say(scene, "Your heart seems light")
        }
        if t >= 3 && t < 3.1 { message.setAlpha(0) }
        if t >= 3.2 && t < 4.9 {
            if t < 4 { message.fadeIn(30, dt) } else { message.fadeOut(30, dt) }
            message.say(scene, "Show me")
        }
        if t >= 4.9 && t < 5 { message.setAlpha(0) }

        if t >= 4 && t < 19.9 {
            user.simulate()
            scene.blendAdd = true
            user.draw(scene, .light)
            scene.blendAdd = false
            user.fadeIn(dt)
        }

        if t >= 5 && t < 20 {
            if !captureStarted {
                captureStarted = true
                renderer.clearCaptureTexture()
            }
            capture.blendAdd = true
            user.draw(capture, .light)
            capture.blendAdd = false
        }

        if t > 20 {
            message.setAlpha(0)
            story.setMode(.scales)
        }
    }

    private func heavy(_ t: CGFloat, _ dt: CGFloat) {
        clear()
        if t < 0.1 {
            message.setAlpha(0)
            pyramid.setAlpha(0)
            captureStarted = false
        }
        if t >= 0.1 && t < 0.5 { message.alert(scene, "NO", red: true) }

        if t >= 0.5 && t < 3 {
            pyramid.showAlt(scene)
            pyramid.fadeIn(dt)
            if t < 1.5 { message.fadeIn(10, dt) } else { message.fadeOut(8, dt) }
            message.say(scene, "Your heart must be heavy")
        }
        if t >= 3 && t < 13 {
            pyramid.showAlt(scene)
            pyramid.fadeIn(dt)
            user.draw(scene, .heavy)
            user.fadeIn(dt)
        }
        if t >= 3 && t < 3.1 { message.setAlpha(0) }
        if t >= 3.1 && t < 6 {
            if t < 5 { message.fadeIn(8, dt) } else { message.fadeOut(8, dt) }
            message.say(scene, "Show me")
        }
        if t >= 6 && t < 13 {
            if !captureStarted {
                captureStarted = true
                renderer.clearCaptureTexture()
            }
            user.draw(capture, .heavy)
        }
        if t > 13 {
            message.setAlpha(0)
            story.setMode(.scales)
        }
    }

    private func scalesScene(_ t: CGFloat, _ dt: CGFloat) {
        if t < 0.1 {
            clear()
            message.setAlpha(0)
        }
        if t >= 0.1 && t < 8 {
            fade(0.15)
            scales.showDiagram(true)
            scales.startFrom(.middle)
            scales.update(scene, dt, clock)
            scales.fadeIn(dt)
            message.countdown(scene, 8, t)
        }
        if t >= 8 && t < 10.5 {
            clear()
            if t < 9.5 { message.fadeIn(8, dt) } else { message.fadeOut(8, dt) }
            message.say(scene, "It's not time to die")
        }
        if t > 10.5 {
            message.setAlpha(0)
            story.setMode(.wisdom)
        }
    }

    private func wisdomScene(_ t: CGFloat, _ dt: CGFloat) {
        clear()
        if t < 0.1 {
            message.setAlpha(0)
            wisdom.getQuote(scales.feather)
        }
        if t >= 0.1 && t < 5 {
            if t < 4 { message.fadeIn(8, dt) } else { message.fadeOut(8, dt) }
            message.say(scene, "Sebayt")
            message.subtitle(scene, "Wisdom will guide your life")
        }
        if t >= 5 && t < 5.1 { message.setAlpha(0) }
        if t >= 5.2 && t < 40 {
            wisdom.showCard(scene, capture: renderer.captureTexture, captureSize: renderer.captureSize)
            wisdom.fadeIn(8, dt)
            if t > 10 && !pointer.takeClicks().isEmpty {
                story.setMode(.outro)
                return
            }
        }
        if t >= 40 && t < 42 {
            wisdom.showCard(scene, capture: renderer.captureTexture, captureSize: renderer.captureSize)
            wisdom.fadeOut(8, dt)
        }
        if t > 42 {
            message.setAlpha(0)
            story.setMode(.outro)
        }
    }

    private func outro(_ t: CGFloat, _ dt: CGFloat) {
        clear()
        if t < 0.1 { message.setAlpha(0) }
        if t >= 0.1 && t < 6 {
            if t < 3 {
                message.fadeIn(4, dt)
            } else {
                message.fadeOut(6, dt)
                music.fadeOut(dt)
            }
            message.say(scene, "Ankhek!")
            message.subtitle(scene, "May you live")
        }
        if t > 6 {
            music.end()
            message.setAlpha(255)
            message.subtitle(scene, "Touch the water to live again")
            if !pointer.takeClicks().isEmpty { onRestart() }
        }
    }
}
