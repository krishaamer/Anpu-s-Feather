import CoreGraphics

/// Controls the sequence of scenes — the port of narrative.pde.
enum Mode: Equatable {
    case intro, questions, light, heavy, scales, wisdom, outro
}

final class Narrative {
    private(set) var mode: Mode = .intro
    private var sceneTime: CGFloat = 0

    func update(_ dt: CGFloat) { sceneTime += dt }
    var time: CGFloat { sceneTime }

    func setMode(_ m: Mode) {
        mode = m
        sceneTime = 0
    }
    func resetTime() { sceneTime = 0 }
}
