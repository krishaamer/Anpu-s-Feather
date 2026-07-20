import CoreGraphics

/*
  Skeleton playback — the port of the web app's skeleton.ts (originally
  parser.pde). Plays back the recorded Kinect movement files and blends the
  two hand joints toward the touch point, so the on-screen body follows the
  visitor and drifts back to the recording when they are still.
*/
final class Skeleton {
    private(set) var points: [Vec3] = Array(repeating: Vec3(x: 0, y: 0, z: 0), count: JOINTS)

    private var frames: [[Vec3]] = []
    private var frameClock: CGFloat = 0
    private var index = 0
    private var handBlend: CGFloat = 0

    private let names = [
        "wave1", "wave2", "pray1", "pray2", "swim1", "turn1", "dig1", "shrugging",
    ]

    private let store: TextureStore
    private let pointer: Pointer

    init(store: TextureStore, pointer: Pointer) {
        self.store = store
        self.pointer = pointer
        load(names[0])
    }

    private func load(_ name: String) {
        frames.removeAll()
        let text = store.recording(name)
        for line in text.split(separator: "\n") {
            let pieces = line.split(separator: ",")
            if pieces.count < JOINTS * 3 { continue }
            var frame: [Vec3] = []
            frame.reserveCapacity(JOINTS)
            var i = 0
            while i < JOINTS * 3 {
                let x = CGFloat(Double(pieces[i]) ?? 0)
                let y = CGFloat(Double(pieces[i + 1]) ?? 0)
                let z = CGFloat(Double(pieces[i + 2]) ?? 0)
                frame.append(Vec3(x: x, y: y, z: z))
                i += 3
            }
            frames.append(frame)
        }
        frameClock = 0
    }

    func nextRecording() {
        index = (index + 1) % names.count
        load(names[index])
    }
    func prevRecording() {
        index = (index - 1 + names.count) % names.count
        load(names[index])
    }
    func randomRecording() {
        index = Int.random(in: 0..<names.count)
        load(names[index])
    }

    func update(_ dt: CGFloat) {
        guard !frames.isEmpty else { return }
        frameClock += dt * FPS
        let idx = Int(frameClock) % frames.count
        let frame = frames[idx]

        let target: CGFloat = pointer.idleSeconds() < 2 ? 1 : 0
        handBlend = lerpf(handBlend, target, clampf(dt * 3, 0, 1))

        let px = pointer.x - World.w / 2
        let py = pointer.y - World.h / 2

        for i in 0..<JOINTS { points[i] = frame[i] }

        let b = handBlend
        points[4].x = lerpf(points[4].x, px - 50, b)
        points[4].y = lerpf(points[4].y, py, b)
        points[7].x = lerpf(points[7].x, px + 50, b)
        points[7].y = lerpf(points[7].y, py, b)
    }
}
