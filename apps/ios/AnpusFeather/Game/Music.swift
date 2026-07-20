import AVFoundation
import CoreGraphics

/*
  Soundtrack — the port of music.pde.
  Copyright-free music "Anubis" by Lucha and R3VXS.
*/
final class Music {
    private var player: AVAudioPlayer?
    private var volume: Float = 1

    init(url: URL) {
        try? AVAudioSession.sharedInstance().setCategory(.ambient, options: [.mixWithOthers])
        try? AVAudioSession.sharedInstance().setActive(true)
        player = try? AVAudioPlayer(contentsOf: url)
        player?.numberOfLoops = -1
        player?.prepareToPlay()
    }

    func play() {
        volume = 1
        player?.volume = volume
        player?.play()
    }

    func fadeOut(_ dt: CGFloat) {
        guard let player, player.isPlaying, volume > 0 else { return }
        volume = max(0, volume - Float(0.05 * dt * FPS))
        player.volume = volume
    }

    func end() { player?.stop() }

    func toggleMute() {
        guard let player else { return }
        player.volume = player.volume > 0 ? 0 : volume
    }
}
